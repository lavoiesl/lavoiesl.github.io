#!/usr/bin/env ruby
require 'webrick'
require 'nokogiri'
require 'selenium-webdriver'
require 'pathname'

SITE_DIR = Pathname.new('_site').realpath rescue nil
PORT = 4000
BASE_URL = "http://127.0.0.1:#{PORT}"

abort("_site directory not found. Build the site before running this check.") unless SITE_DIR && SITE_DIR.directory?

def find_mermaid_pages(site_dir)
  pages = []
  Dir.glob(File.join(site_dir, '**', '*.html')).each do |path|
    begin
      html = File.read(path, encoding: 'UTF-8')
      doc = Nokogiri::HTML(html)
      has_mermaid = !doc.css('.mermaid').empty? || !doc.css('pre code.language-mermaid').empty?
      next unless has_mermaid
      rel = Pathname.new(path).relative_path_from(Pathname.new(site_dir)).to_s
      pages << rel
    rescue StandardError
      next
    end
  end
  pages
end

class SilentLog < WEBrick::Log
  def log(level, data); end
end

def start_server(site_dir)
  root = site_dir
  server = WEBrick::HTTPServer.new(
    Port: PORT,
    DocumentRoot: root,
    Logger: SilentLog.new,
    AccessLog: []
  )
  trap('INT') { server.shutdown }
  Thread.new { server.start }
  server
end

server = start_server(SITE_DIR.to_s)
pages = find_mermaid_pages(SITE_DIR.to_s)

if pages.empty?
  puts 'No Mermaid diagrams found in built site. Skipping check.'
  server.shutdown
  exit 0
end

options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless=new')
options.add_argument('--no-sandbox')
options.add_argument('--disable-gpu')
options.add_argument('--disable-dev-shm-usage')

# If GitHub Action exposes Chrome path, use it
chrome_path = ENV['CHROME_PATH']
options.binary = chrome_path if chrome_path && !chrome_path.empty?

driver = Selenium::WebDriver.for(:chrome, options: options)

failures = []
pages.each do |rel|
  url = File.join(BASE_URL, rel)
  begin
    driver.navigate.to(url)
    wait = Selenium::WebDriver::Wait.new(timeout: 15)
    wait.until { driver.find_elements(css: '.mermaid svg').any? }
  rescue StandardError => e
    failures << [url, e.message]
  end
end

driver.quit
server.shutdown

if failures.any?
  puts 'Mermaid rendering check failed on the following pages:'
  failures.each { |u, err| puts " - #{u}: #{err}" }
  exit 1
else
  puts "Mermaid rendering check passed on #{pages.length} page(s)."
end

