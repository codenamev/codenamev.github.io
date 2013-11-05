require "rubygems"
require 'rake'
require 'yaml'
require 'time'
require 'open-uri'
require 'RMagick'
require "digest/md5"
require 'octokit'
require 'date'
require 'tmpdir'
require 'jekyll'

SOURCE = "."
CONFIG = {
  'layouts' => File.join(SOURCE, "_layouts"),
  'posts' => File.join(SOURCE, "_posts")
}

desc "Generate blog files"
task :generate do
  Jekyll::Site.new(Jekyll.configuration({
    "source"      => ".",
    "destination" => "_site"
  })).process
end


desc "Generate and publish blog to gh-pages"
task :publish => [:generate] do
  Dir.mktmpdir do |tmp|
    system "mv _site/* #{tmp}"
    system "git checkout gh-pages"
    system "rm -rf *"
    system "mv #{tmp}/* ."
    message = "Site updated at #{Time.now.utc}"
    system "git add ."
    system "git commit -am #{message.shellescape}"
    system "git push origin gh-pages --force"
    system "git checkout master"
    system "echo yolo"
  end
end

task :default => :publish

###
# Based on jekyll-bootstrap's Rakefile.
# Thanks, @plusjade
# https://github.com/plusjade/jekyll-bootstrap
###

# Usage: rake post title="A Title" [date="2012-02-09"]
desc "Begin a new post in #{CONFIG['posts']}"
task :post do
  abort("rake aborted: '#{CONFIG['posts']}' directory not found.") unless FileTest.
    directory?(CONFIG['posts'])
  title = ENV["title"] || "new-post"
  slug = title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  begin
    date = (ENV['date'] ? Time.parse(ENV['date']) : Time.now).strftime('%Y-%m-%d')
  rescue Exception => e
    puts "Error - date format must be YYYY-MM-DD, please check you typed it correctly!"
    exit -1
  end
  filename = File.join(CONFIG['posts'], "#{date}-#{slug}.md")
  if File.exist?(filename)
    abort("rake aborted!") if ask("#{filename} already exists. Do you want to overwrite?",
      ['y', 'n']) == 'n'
  end

  puts "Creating new post: #{filename}"
  open(filename, 'w') do |post|
    post.puts "---"
    post.puts "layout: post"
    post.puts "title: \"#{title.gsub(/-/,' ')}\""
    post.puts "category: posts"
    post.puts "---"
  end
end # task :post

desc "Launch preview environment"
task :preview do
  system "jekyll serve"
end # task :preview

desc "Update icons based on your gravatar (define author email in _config.yml)!"
task :icons do
  puts "Getting author email from _config.yml..."
  config = YAML.load_file('_config.yml')
  author_email = config['author']['email']
  gravatar_id = Digest::MD5.hexdigest(author_email)
  base_url = "http://www.gravatar.com/avatar/#{gravatar_id}?s=150"

  origin = "origin.png"
  File.delete origin if File.exist? origin

  puts "Downloading base image file from gravatar..."
  open(origin, 'wb') do |file|
    file << open(base_url).read
  end

  name_pre = "apple-touch-icon-%dx%d-precomposed.png"

  FileList["*apple-touch-ico*.png"].each do |img|
    File.delete img
  end

  FileList["*favicon.ico"].each do |img|
    File.delete img
  end

  puts "Creating favicon.ico..."
  Magick::Image::read(origin).first.resize(16, 16).write("favicon.ico")

  [144, 114, 72, 57].each do |size|
    puts "Creating #{name_pre} icon..." % [size, size]
    Magick::Image::read(origin).first.resize(size, size).
      write(name_pre % [size, size])
  end
  puts "Cleaning up..."
  File.delete origin
end
