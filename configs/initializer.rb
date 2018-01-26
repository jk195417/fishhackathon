require 'rubygems'
require 'bundler'
Bundler.require(:default)
require 'csv'
require 'yaml'
require 'json'
require 'logger'

module App
  class << self
    attr_accessor :root_path, :log
  end
  self.root_path = Pathname.new(File.dirname(__FILE__)).join('..')
  def self.logger
    self.log ||= Logger.new('error.log')
  end
end

# load env
env_filepath = App.root_path.join('configs', 'env.yml')
env_string = File.exist?(env_filepath) ? File.read(env_filepath) : ''
YAML.safe_load(env_string).each { |k, v| ENV[k] = v }

require_relative App.root_path.join 'models', 'anchor.rb'
require_relative App.root_path.join 'services', 'worker.rb'
require_relative App.root_path.join 'services', 'csv_parser.rb'
require_relative App.root_path.join 'services', 'elevation_api.rb'
require_relative App.root_path.join 'services', 'what_3_words_api.rb'
