#!/usr/bin/env ruby
# Validation script for HTML to Markdown conversion
# Verifies that critical content (links, code, emphasis, lists) is preserved
# Usage: ruby validate_conversion.rb original.html converted.md

require 'nokogiri'

class ConversionValidator
  def initialize(html_file, markdown_file, delete_source: true)
    @html_file = html_file
    @markdown_file = markdown_file
    @delete_source = delete_source
    @html_content = File.read(html_file)
    @markdown_content = File.read(markdown_file)
    @doc = Nokogiri::HTML(@html_content)
    @issues = []
  end

  def validate_all
    validate_links
    validate_code
    validate_emphasis
    validate_lists
    validate_headings
    validate_html_artifacts
    
    print_report
    success = @issues.empty?
    delete_source_if_requested(success)
    success
  end

  private

  def validate_links
    links = @doc.css('a')
    return if links.empty?

    puts "\n🔗 Validating #{links.length} links..."
    
    links.each do |link|
      href = link['href']
      text = link.text

      next if href.nil? || href.empty? || text.nil? || text.empty?

      # Check URL is in markdown
      unless @markdown_content.include?(href)
        @issues << "❌ LINK URL LOST: #{href} from '#{text}'"
      end

      # Check link text is in markdown
      unless @markdown_content.include?(text)
        @issues << "❌ LINK TEXT LOST: '#{text}' (href: #{href})"
      end

      # Check for Markdown link format
      markdown_link = "[#{text}](#{href})"
      if @markdown_content.include?(markdown_link)
        puts "  ✅ #{text} → #{href}"
      else
        puts "  ⚠️  #{text} (text and URL present but may not be linked)"
      end
    end
  end

  def validate_code
    code_blocks = @doc.css('code')
    return if code_blocks.empty?

    puts "\n💻 Validating #{code_blocks.length} inline code elements..."
    
    code_blocks.each do |code|
      text = code.text
      next if text.nil? || text.empty?

      unless @markdown_content.include?(text)
        @issues << "❌ CODE LOST: `#{text}`"
      else
        puts "  ✅ `#{text}`"
      end
    end
  end

  def validate_emphasis
    strong_tags = @doc.css('strong, b')
    em_tags = @doc.css('em, i')

    puts "\n**Bold** Validating #{strong_tags.length} bold elements..."
    strong_tags.each do |tag|
      text = tag.text
      next if text.nil? || text.empty?

      unless @markdown_content.include?(text)
        @issues << "❌ BOLD TEXT LOST: #{text}"
      else
        puts "  ✅ **#{text}**"
      end
    end

    puts "\n*Italic* Validating #{em_tags.length} italic elements..."
    em_tags.each do |tag|
      text = tag.text
      next if text.nil? || text.empty?

      unless @markdown_content.include?(text)
        @issues << "❌ ITALIC TEXT LOST: #{text}"
      else
        puts "  ✅ *#{text}*"
      end
    end
  end

  def validate_lists
    list_items = @doc.css('ul li, ol li')
    return if list_items.empty?

    puts "\n📝 Validating #{list_items.length} list items..."
    
    list_items.each do |item|
      text = item.text.strip.gsub("\u00a0", ' ').strip
      next if text.empty?

      unless @markdown_content.include?(text)
        @issues << "❌ LIST ITEM LOST: #{text}"
      else
        puts "  ✅ #{text}"
      end
    end
  end

  def validate_headings
    headings = @doc.css('h1, h2, h3, h4, h5, h6')
    return if headings.empty?

    puts "\n📌 Validating #{headings.length} headings..."
    
    headings.each do |heading|
      text = heading.text.strip
      next if text.empty?

      unless @markdown_content.include?(text)
        @issues << "❌ HEADING LOST: #{text}"
      else
        puts "  ✅ #{text}"
      end
    end
  end

  def validate_html_artifacts
    puts "\n🧹 Validating converted Markdown has no trivial leftover HTML..."

    checks = [
      { pattern: /<a\b/i, label: 'anchor tag <a ...>' },
      { pattern: /<br\s*\/?>/i, label: 'line break tag <br ...>' },
      { pattern: /<span\b[^>]*font-family[^>]*(courier|monospace)/i, label: 'monospace span style remnants' },
      { pattern: /<div>\s*<\/div>/im, label: 'empty div wrapper' },
      { pattern: /<div\s*>/i, label: 'plain div wrapper <div>' }
    ]

    checks.each do |check|
      if @markdown_content.match?(check[:pattern])
        @issues << "❌ HTML ARTIFACT FOUND: #{check[:label]}"
      else
        puts "  ✅ No #{check[:label]}"
      end
    end
  end

  def print_report
    puts "\n" + "="*60
    if @issues.empty?
      puts "✅ VALIDATION PASSED - All critical content preserved!"
    else
      puts "❌ VALIDATION FAILED - Issues found:"
      @issues.each { |issue| puts "  #{issue}" }
    end
    puts "="*60
  end

  def delete_source_if_requested(success)
    return unless success
    return unless @delete_source
    return unless File.exist?(@html_file)
    return unless @html_file.downcase.end_with?('.html')
    return unless @markdown_file.downcase.end_with?('.md')

    File.delete(@html_file)
    puts "🗑️  Deleted source HTML: #{@html_file}"
  rescue => e
    @issues << "⚠️  Could not delete source HTML '#{@html_file}': #{e.message}"
    puts "⚠️  Could not delete source HTML '#{@html_file}': #{e.message}"
  end
end

# Main execution
if __FILE__ == $0
  if ARGV.length < 2
    puts "Usage: ruby validate_conversion.rb original.html converted.md [--keep-source]"
    exit 1
  end

  keep_source = ARGV.include?('--keep-source')
  positional_args = ARGV.reject { |arg| arg == '--keep-source' }

  if positional_args.length < 2
    puts "Usage: ruby validate_conversion.rb original.html converted.md [--keep-source]"
    exit 1
  end

  html_file = positional_args[0]
  markdown_file = positional_args[1]

  unless File.exist?(html_file) && File.exist?(markdown_file)
    puts "❌ Error: Files not found"
    exit 1
  end

  validator = ConversionValidator.new(html_file, markdown_file, delete_source: !keep_source)
  success = validator.validate_all
  
  exit(success ? 0 : 1)
end
