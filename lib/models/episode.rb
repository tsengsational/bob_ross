require_relative "../../bin/environment.rb"
require 'pry'

class Episode
  attr_accessor :episode_number, :title, :season_id
  attr_reader :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def initialize(episode_number, title, season_id, id=nil)
    @episode_number = episode_number
    @title = title
    @season_id = season_id
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE episodes (
      id INTEGER PRIMARY KEY,
      episode_number INTEGER,
      title TEXT,
      season_id INTEGER,
    );
    SQL
        DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE episodes;"
    DB[:conn].execute(sql)
  end

  def save
    id_query = "SELECT COUNT(*) FROM episodes;"
    # binding.pry
    @id = DB[:conn].execute(id_query).flatten[0] + 1
    sql = "INSERT INTO episodes (episode_number, title, season_id) VALUES (?, ?, ?)"
    arr = DB[:conn].execute(sql, [self.episode_number, self.title, self.season_id])
    # @id =
  end

  def self.create(episode_number:, title:, season_id:)
    new_episode = self.new(episode_number, title, season_id)
    new_episode.save
    new_episode
  end


  def self.insert_data
    episodes = Data.transform.each_with_object([]) { |row, arr| arr << [row[:episode].split("E").pop.to_i, row[:title].delete('\"'), row[:episode].slice(1, 2).to_i] }
    episodes.each do |episode|
         #binding.pry
      self.create(episode_number: episode[0], title: episode[1], season_id: episode[2], season_ep: episode[3])
    end
  end

  def self.find_by_title(title:)
    sql = <<-SQL
    SELECT *
    FROM episodes
    WHERE title = ?
    SQL

    episode = DB[:conn].execute(sql, title).flatten
    binding.pry
    new_episode = Episode.new(episode[1], episode[2], episode[3], episode[0])
  end

  def destroy
    sql = <<-SQL
    DELETE
    FROM episodes
    WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.id)
  end

  def update
    sql = <<-SQL
    UPDATE episodes
    SET episode_number = ?, title = ?, season_id = ?
    WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.episode_number, self.title, self.season_id, self.id)
  end


end

#
