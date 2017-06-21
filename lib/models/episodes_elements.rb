require_relative "../../bin/environment.rb"
require 'pry'

class EpisodesElements
  attr_accessor :ep_id, :el_id
  attr_reader :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def initialize(ep_id, el_id, id=nil)
    @ep_id = ep_id
    @el_id = el_id
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE episodes_elements (id INTEGER PRIMARY KEY, ep_id INTEGER, el_id INTEGER);
    SQL
        DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE episodes_elements;"
    DB[:conn].execute(sql)
  end

  def save
    id_query = "SELECT COUNT(*) FROM episodes_elements;"
    # binding.pry
    @id = DB[:conn].execute(id_query).flatten[0] + 1
    sql = "INSERT INTO episodes_elements (ep_id, el_id) VALUES (?, ?)"
    arr = DB[:conn].execute(sql, [self.ep_id, self.el_id])
    # @id =
  end

  def self.create(ep_id:, el_id:)
    new_episode_element = self.new(ep_id, el_id)
    new_episode_element.save
    new_episode_element
  end


  def self.insert_data
    # arr.each_with_object([]).with_index {|(e, h), i|}
    count = 0
    episodes_elements = Data.transform.each_with_object([]) do |row, arr|
      count += 1
      row.each_with_index do |(column, value), index|
        if value == 1
          arr << [count, index - 1]
          # binding.pry
        end
      end
    end
    episodes_elements.each do |ep_el|
      self.create(ep_id: ep_el[0], el_id: ep_el[1])
    end
  end

  def self.find(ep_id:, el_id:)
    sql = <<-SQL
    SELECT *
    FROM episodes_elements
    WHERE ep_id = ? AND el_id = ?
    SQL

    element_episode = DB[:conn].execute(sql, ep_id, el_id).flatten
    binding.pry
    new_el_ep = EpisodesElements.new(element_episode[1], element_episode[2], element_episode[0])
  end

  def destroy
    sql = <<-SQL
    DELETE
    FROM episodes_elements
    WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.id)
  end

  def update
    sql = <<-SQL
    UPDATE episodes_elements
    SET ep_id = ?, el_id = ?
    WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.ep_id, self.el_id, self.id)
  end

  def most_frequent_element
    sql = <<-SQL
    SELECT elements.element, COUNT(*)
    FROM episodes_elements
    JOIN elements
    ON episodes_elements.el_id = elements.id
    GROUP BY elements.element
	  ORDER BY COUNT(episodes_elements.el_id) DESC LIMIT 1
    SQL

    DB[:conn].execute(sql)
  end

  def self.most_frequent_element_per_season
    query = <<-SQL
      SELECT elements.element,  seasons.season, COUNT(*)
      FROM elements
      JOIN episodes_elements
      ON episodes_elements.el_id = elements.id
      JOIN episodes
      ON episodes_elements.ep_id = episodes.id
      JOIN seasons
      ON seasons.id = episodes.season_id
      WHERE seasons.id = ?
      GROUP BY elements.element
      ORDER BY COUNT(episodes_elements.el_id)  DESC
      SQL

    (1..31).map do |curr_season_id|
      DB[:conn].execute(query, curr_season_id).first
    end
    binding.pry
  end

  def elements_per_episode
    sql = <<-SQL
    SELECT episodes.id, COUNT(*)
    FROM episodes
    JOIN episodes_elements
    ON episodes.id = episodes_elements.ep_id
    JOIN elements
    ON episodes_elements.el_id = elements.id
    GROUP BY episodes.id
    SQL
    
    DB[:conn].execute(sql)
  end

end

Pry.start
