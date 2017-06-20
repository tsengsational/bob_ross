require 'bundler/setup'
Bundler.require

require_relative 'sql_runner.rb'
require 'pry'
require 'csv'
require 'json'
require 'require_all'

require_all 'lib'
