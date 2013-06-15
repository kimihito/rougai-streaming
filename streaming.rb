#!/usr/bin/env ruby
#-*- coding: utf-8 -*-
require 'tweetstream'
require 'uri'
require 'net/http'
require 'ostruct'
require 'yaml'

CONFIG_FILEPATH = File.join(File.dirname(__FILE__), 'config.yml')

def config
  @conf ||= OpenStruct.new(YAML.load_file(CONFIG_FILEPATH))
end

TweetStream.configure do |c|
  c.consumer_key = config.consumer_key
  c.consumer_secret = config.consumer_secret
  c.oauth_token = config.oauth_token
  c.oauth_token_secret = config.oauth_token_secret
end

client = TweetStream::Client.new
client.track(config.terms) do |status|
    Thread.new{
      uri = URI.parse(config.url)
      Net::HTTP.post_form(uri, {"SN" => status.user.screen_name, "TX" => status.text})
     }
end
client.userstream

