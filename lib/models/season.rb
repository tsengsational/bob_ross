require_relative "../../bin/environment.rb"
require 'pry'

class Season
  attr_accessor :season
  attr_reader :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def initialize(season, id=nil)
    @season = season
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE seasons (
      id INTEGER PRIMARY KEY,
      season INTEGER
    );
    SQL
        DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE seasons;"
    DB[:conn].execute(sql)
  end

  def save
    id_query = "SELECT COUNT(*) FROM seasons;"
    # binding.pry
    @id = DB[:conn].execute(id_query).flatten[0] + 1
    sql = "INSERT INTO seasons (season) VALUES (?)"
    arr = DB[:conn].execute(sql, [self.season])
    # @id =
  end

  def self.create(season:)
    new_season = self.new(season)
    new_season.save
    new_season
  end

  def self.insert_data
    sql = Data.insert_1
    DB[:conn].execute(sql)
  end

  def self.insert_data_orm
    seasons = Data.transform.each_with_object([]) { |row, arr|  arr << row[:episode].slice(1, 2).to_i}.uniq
    # binding.pry
    seasons.each do |season|
      self.create(season: season)
    end
  end

  def self.find(season:)
    sql = <<-SQL
    SELECT *
    FROM seasons
    WHERE season = ?
    SQL

    season = DB[:conn].execute(sql, season).flatten
    binding.pry
    new_season = Season.new(season[1], season[0])
  end

  def destroy
    sql = <<-SQL
    DELETE
    FROM seasons
    WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.id)
  end

  def update
    sql = <<-SQL
    UPDATE seasons
    SET season = ?
    WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.season, self.id)
  end

end

#Pry.start
