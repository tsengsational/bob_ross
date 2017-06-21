require 'bundler/setup'
Bundler.require

require_relative 'sql_runner.rb'
require 'pry'
require 'csv'
require 'json'
require 'require_all'

DB = {:conn => SQLite3::Database.new('./db/bob_ross.db')}


require_all 'lib'
require_all 'lib/models'
