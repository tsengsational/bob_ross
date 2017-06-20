require_relative 'environment'
require 'pry'
require_relative '../lib/data.rb'


db = SQLite3::Database.new('../db/bob_ross.db')
sql_runner = SQLRunner.new(db)

sql_runner.execute_insert_arg(Data.insert_1)
sql_runner.execute_insert_arg(Data.insert_2)
sql_runner.execute_insert_arg(Data.insert_3)
sql_runner.execute_insert_arg(Data.insert_4)

Pry.start
