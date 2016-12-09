#!/usr/bin/env ruby
require 'github/markdown'
require 'pry'
require 'rdiscount'
require 'require_all'
require 'sinatra'
require 'yaml'

set :port, 3000

get '/' do
  @title = 'Home'
  erb :home
end

# -----------------------------------------
get '/gh-md/' do
  @title = 'GitHub Markdown (not maintained anymore)'
  erb :githubmarkdown
end

post '/preview' do
  GitHub::Markdown.render_gfm params['md']
end
# -----------------------------------------

get '/just-md/' do
  markdown :foo
end

get '/md-inside-layout/' do
  @title = 'Markdown inside layout through locals'
  erb :mdinsidelayout, :locals => { :text => markdown(:foo) }
end

get '/md-as-variable/' do
  @title = 'Markdown inside layout as a variable'
  @text = markdown(:foo)
  erb :mdinsidelayout
end

get '/md-with-frontmatter/' do
  @title = 'Markdown inside layout when it contains Front-Matter'
  @text = markdown(:fronted)
  erb :mdinsidelayout
end

get '/md-from-view/' do
  @title = 'Markdown called from inside the view'
  erb :mdcalledfromview
end

get '/blog/' do
  @title = 'Blog list'
  @posts = all_posts
  erb :blog
end

get '/blog/:slug' do |post_slug|
  filename = filename_of(post_slug)
  @title = post_frontmatter(filename).fetch('title', '')
  @text  = post_markdown(filename)
  erb :post
end

# Regex from Jekyll
# https://github.com/jekyll/jekyll/blob/master/lib/jekyll/document.rb#L10
YAML_FRONT_MATTER_REGEXP = %r!\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)!m
POSTS_DIR = 'content/posts/'

def post_frontmatter(filename)
  YAML::load_file(File.join(__dir__, filename))
end

def post_markdown(filename)
  file = File.open(filename, "r")
  body = file.read.sub(YAML_FRONT_MATTER_REGEXP, '')
  file.close
  RDiscount.new(body).to_html
end

def all_posts
  posts = []
  Dir.glob(POSTS_DIR + '*.md') do |filename|
    frontmatter = post_frontmatter(filename)
    posts << {
      url: '/blog/' + frontmatter.fetch('slug', ''),
      title: frontmatter.fetch('title', '')
    }
  end
  posts
end

def filename_of(slug)
  Dir.glob(POSTS_DIR + '*.md') do |filename|
    frontmatter = post_frontmatter(filename)
    if frontmatter.fetch('slug', '') == slug
      return filename
    end
  end
  ''
end

# http://stackoverflow.com/a/16319628/2750478
