require 'bundler/setup'
Bundler.require
require 'open-uri'
require 'active_support/cache'

CACHE = ActiveSupport::Cache.lookup_store(:dalli_store)
CACHE_EXPIRES_IN = ENV['CACHE_EXPIRES_IN'].to_i rescue 60
DEBUG = ENV['DEBUG']

def text(url)
  if result = CACHE.read(url)
    puts "read cache for: #{url}" if DEBUG
    result
  else
    puts "write cache for: #{url}" if DEBUG
    result = Instapi.text(URI.encode(url)) rescue {:text => 'Faild to fetch content :('}
    CACHE.write(url, result, :expires_in => CACHE_EXPIRES_IN)
    result
  end
end

get '/' do
  haml :index
end

get '/rss' do
  content_type 'application/xml;charset=UTF-8'
  rss = Nokogiri::XML(open(params[:url]).read)
  rss.xpath('//item').each do |item|
    description = Nokogiri::XML::Node.new 'description', rss
    link = item.xpath('link').first.content
    description.content = text(link)[:text]
    item.add_child(description)
  end
  rss.to_xml
end
