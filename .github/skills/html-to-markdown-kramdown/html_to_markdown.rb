#!/usr/bin/env ruby
# HTML to Markdown Converter (Nokogiri-based)
# Converts HTML files to Markdown following Jekyll kramdown + Rouge conventions
# Usage: ruby html_to_markdown.rb input.html output.md

require 'nokogiri'
require 'uri'
require 'securerandom'

class HTMLToMarkdown
  def initialize(html_file)
    @html_file = html_file
    raw_html_content = File.read(html_file)
    @protected_blocks = {}
    @token_prefix = "__J2M_PROTECTED_#{SecureRandom.hex(8)}_"
    @html_content = protect_jekyll_highlight_blocks(raw_html_content)
    @doc = Nokogiri::HTML(@html_content)
    @conversion_log = []
  end

  def convert
    # Clone document to avoid mutating original
    working_doc = @doc.dup

    # Apply conversions in safe order
    convert_links(working_doc)
    convert_emphasis(working_doc)
    convert_spans(working_doc)
    convert_divs(working_doc)
    convert_inline_code(working_doc)
    convert_headings(working_doc)
    convert_paragraphs(working_doc)
    convert_lists(working_doc)
    convert_pre_blocks(working_doc)
    convert_horizontal_rules(working_doc)

    # Extract body content
    result = working_doc.css('body').inner_html
    result = restore_protected_blocks(result)
    result = normalize_contiguous_inline_code_blocks(result)
    result = ensure_blank_line_before_headings(result)
    
    validate_conversion(result)
    result
  end

  def log_summary
    puts "\n📋 Conversion Summary:"
    @conversion_log.each { |msg| puts msg }
  end

  private

  def convert_links(doc)
    doc.css('a').each do |link|
      href = link['href']
      text = link.text

      # Safety checks
      if href.nil? || href.empty?
        @conversion_log << "⚠️  Skipped link with missing href: #{text}"
        next
      end

      if text.nil? || text.empty?
        @conversion_log << "⚠️  Skipped link with empty text: #{href}"
        next
      end

      markdown_link = "[#{text}](#{href})"
      link.replace(Nokogiri::HTML.fragment(markdown_link))
      @conversion_log << "✅ Converted link: [#{text}](#{href})"
    end
  end

  def convert_emphasis(doc)
    # Convert <strong> and <b> to **text**
    doc.css('strong, b').each do |tag|
      text = tag.text
      next if text.nil? || text.empty?
      
      tag.replace(Nokogiri::HTML.fragment("**#{text}**"))
      @conversion_log << "✅ Converted strong: **#{text}**"
    end

    # Convert <em> and <i> to *text*
    doc.css('em, i').each do |tag|
      text = tag.text
      next if text.nil? || text.empty?
      
      tag.replace(Nokogiri::HTML.fragment("*#{text}*"))
      @conversion_log << "✅ Converted emphasis: *#{text}*"
    end
  end

  def convert_inline_code(doc)
    doc.css('code').each do |code|
      # Do not touch block code content handled by convert_pre_blocks.
      next if code.ancestors.any? { |ancestor| ancestor.name == 'pre' }

      text = code.text
      next if text.nil? || text.empty?

      code.replace(Nokogiri::HTML.fragment("`#{text}`"))
      @conversion_log << "✅ Converted inline code: `#{text}`"
    end
  end

  def convert_spans(doc)
    doc.css('span').each do |span|
      next if in_code_context?(span)

      style = (span['style'] || '').downcase

      if style.include?('font-family') && (style.include?('courier') || style.include?('monospace'))
        text = span.text
        if text.nil? || text.empty?
          span.remove
        else
          span.replace(Nokogiri::HTML.fragment("`#{text}`"))
          @conversion_log << "✅ Converted monospace span: `#{text}`"
        end
      elsif style.include?('font-family: inherit')
        if span.children.any?
          span.replace(span.children)
        else
          span.remove
        end
      end
    end
  end

  def convert_divs(doc)
    doc.css('div').each do |div|
      next if in_code_context?(div)

      classes = (div['class'] || '').split
      if classes.include?('separator')
        div.replace(Nokogiri::HTML.fragment("---\n"))
        @conversion_log << '✅ Converted separator div to horizontal rule'
        next
      end

      if div.text.strip.empty? && div.css('img, table, script, style, iframe, pre').empty?
        div.remove
        next
      end

      # Unwrap no-op wrapper divs with no attributes so markdown content can render naturally.
      if div.attribute_nodes.empty?
        if div.children.any?
          div.replace(div.children)
        else
          div.remove
        end
        @conversion_log << '✅ Unwrapped plain div wrapper'
        next
      end

      if div.element_children.empty?
        html = div.inner_html.strip
        if html.empty?
          div.remove
        else
          div.replace(Nokogiri::HTML.fragment("#{html}\n\n"))
        end
      end
    end
  end

  def convert_headings(doc)
    (1..6).each do |level|
      doc.css("h#{level}").each do |heading|
        text = heading.text.strip
        next if text.empty?
        
        markdown_heading = "#{'#' * level} #{text}\n"
        heading.replace(Nokogiri::HTML.fragment(markdown_heading))
        @conversion_log << "✅ Converted h#{level}: #{markdown_heading.strip}"
      end
    end
  end

  def convert_paragraphs(doc)
    doc.css('p').each do |para|
      text = para.text.strip
      next if text.empty?
      
      para.replace(Nokogiri::HTML.fragment("#{text}\n\n"))
    end
  end

  def convert_lists(doc)
    doc.css('ul, ol').select { |list| top_level_list?(list) }.reverse_each do |list|
      markdown = render_list(list)
      list.replace(Nokogiri::HTML.fragment("#{markdown}\n"))
      @conversion_log << "✅ Converted #{list.name} with #{list.css('li').length} items"
    end
  end

  def top_level_list?(list)
    list.ancestors.none? { |ancestor| ancestor.name == 'ul' || ancestor.name == 'ol' }
  end

  def render_list(list, depth = 0)
    ordered = list.name == 'ol'
    items = list.element_children.select { |child| child.name == 'li' }

    items.each_with_index.map do |li, index|
      render_list_item(li, depth, ordered ? "#{index + 1}. " : '- ')
    end.join("\n")
  end

  def render_list_item(li, depth, marker)
    indent = '  ' * depth
    content = extract_list_item_content(li)
    nested_lists = li.element_children.select { |child| child.name == 'ul' || child.name == 'ol' }

    lines = ["#{indent}#{marker}#{content}".rstrip]
    nested_lists.each do |nested_list|
      nested_markdown = render_list(nested_list, depth + 1)
      lines << nested_markdown unless nested_markdown.empty?
    end

    lines.join("\n")
  end

  def extract_list_item_content(li)
    content_node = li.dup
    content_node.css('ul, ol').remove
    content = content_node.inner_html
    content = content.gsub(/\r\n?/, "\n")
    content = content.gsub(/[ \t]*\n+[ \t]*/, ' ')
    content.strip
  end

  def convert_pre_blocks(doc)
    doc.css('pre').each do |pre|
      code_text = pre.text
      next if code_text.nil? || code_text.empty?

      # Try to detect language
      lang = pre['class']&.match(/language-(\w+)/)&.[](1) || 'plaintext'
      lang = normalize_language(lang)

      fenced = "```#{lang}\n#{code_text}\n```\n"
      pre.replace(Nokogiri::HTML.fragment(fenced))
      @conversion_log << "✅ Converted code block (lang: #{lang})"
    end
  end

  def convert_horizontal_rules(doc)
    doc.css('hr').each do |hr|
      hr.replace(Nokogiri::HTML.fragment("---\n"))
      @conversion_log << "✅ Converted horizontal rule"
    end
  end

  def normalize_language(lang)
    mapping = {
      'js' => 'javascript',
      'ts' => 'typescript',
      'py' => 'python',
      'sh' => 'bash',
      'rb' => 'ruby',
      'html' => 'html',
      'css' => 'css',
      'json' => 'json'
    }
    mapping[lang] || lang
  end

  def in_code_context?(node)
    node.ancestors.any? { |ancestor| %w[pre code].include?(ancestor.name) }
  end

  def protect_jekyll_highlight_blocks(content)
    protected = content.gsub(/\{%\s*highlight\b.*?%\}.*?\{%\s*endhighlight\s*%\}/m) do |block|
      token = next_protected_token(content)
      @protected_blocks[token] = block
      token
    end

    # Keep raw blocks untouched so embedded template/code syntax is not parsed by Nokogiri.
    protected.gsub(/\{%\s*raw\s*%\}.*?\{%\s*endraw\s*%\}/m) do |block|
      token = next_protected_token(content)
      @protected_blocks[token] = block
      token
    end
  end

  def restore_protected_blocks(content)
    restored = content.dup
    @protected_blocks.each do |token, block|
      restored.gsub!(token, block)
    end
    restored
  end

  def next_protected_token(content)
    token = nil
    loop do
      candidate = "#{@token_prefix}#{SecureRandom.hex(6)}__"
      unless content.include?(candidate) || @protected_blocks.key?(candidate)
        token = candidate
        break
      end
    end
    token
  end

  def validate_conversion(converted)
    # Extract all URLs from original
    original_urls = @doc.css('a').map { |a| a['href'] }.compact
    original_link_texts = @doc.css('a').map { |a| a.text }.compact

    # Check converted markdown contains all URLs
    original_urls.each do |url|
      unless converted.include?(url)
        raise "❌ VALIDATION FAILED: URL lost in conversion: #{url}"
      end
    end

    # Check converted markdown contains all link texts
    original_link_texts.each do |text|
      unless converted.include?(text)
        raise "❌ VALIDATION FAILED: Link text lost in conversion: #{text}"
      end
    end

    puts "\n✅ Validation passed:"
    puts "  - #{original_urls.length} URLs preserved"
    puts "  - #{original_link_texts.length} link texts preserved"
  end

  def normalize_contiguous_inline_code_blocks(content)
    lines = content.lines
    output = []
    i = 0
    in_highlight = false
    in_fence = false

    while i < lines.length
      line = lines[i]
      stripped = line.strip

      if stripped.start_with?('{% highlight')
        in_highlight = true
        output << line
        i += 1
        next
      end

      if stripped == '{% endhighlight %}'
        in_highlight = false
        output << line
        i += 1
        next
      end

      if stripped.start_with?('```')
        in_fence = !in_fence
        output << line
        i += 1
        next
      end

      if in_highlight || in_fence
        output << line
        i += 1
        next
      end

      block_lines = []
      j = i

      while j < lines.length
        candidate = lines[j]
        candidate_stripped = candidate.strip

        break if candidate_stripped.start_with?('{% highlight') || candidate_stripped == '{% endhighlight %}' || candidate_stripped.start_with?('```')

        if candidate_stripped.empty?
          j += 1
          next
        end

        match = candidate_stripped.match(/^`([^`]+)`$/)
        break unless match

        block_lines << match[1]
        j += 1
      end

      if block_lines.length >= 2
        lang = detect_code_block_language(block_lines)
        output << "{% highlight #{lang} %}\n"
        block_lines.each { |code_line| output << "#{code_line}\n" }
        output << "{% endhighlight %}\n"
        output << "\n"
        i = j
      else
        output << line
        i += 1
      end
    end

    output.join
  end

  def detect_code_block_language(lines)
    joined = lines.join(' ').downcase
    sql_keywords = %w[select insert update delete from where into values join group by order limit having]
    return 'sql' if sql_keywords.any? { |keyword| joined.match?(/\b#{Regexp.escape(keyword)}\b/) }

    'plaintext'
  end

  def ensure_blank_line_before_headings(content)
    lines = content.lines
    output = []
    in_highlight = false
    in_fence = false

    lines.each do |line|
      stripped = line.strip

      if stripped.start_with?('{% highlight')
        in_highlight = true
      elsif stripped == '{% endhighlight %}'
        in_highlight = false
      elsif stripped.start_with?('```')
        in_fence = !in_fence
      end

      if !in_highlight && !in_fence && stripped.match?(/^\#{1,6}\s+\S/)
        if !output.empty? && !output.last.strip.empty?
          output << "\n"
        end
      end

      output << line
    end

    output.join
  end

end

# Main execution
if __FILE__ == $0
  if ARGV.length < 2
    puts "Usage: ruby html_to_markdown.rb input.html output.md"
    exit 1
  end

  input_file = ARGV[0]
  output_file = ARGV[1]

  unless File.exist?(input_file)
    puts "❌ Error: #{input_file} not found"
    exit 1
  end

  begin
    converter = HTMLToMarkdown.new(input_file)
    markdown = converter.convert
    converter.log_summary

    File.write(output_file, markdown)
    puts "\n✅ Converted to #{output_file}"
  rescue => e
    puts "❌ Conversion failed: #{e.message}"
    puts e.backtrace.first(5)
    exit 1
  end
end
