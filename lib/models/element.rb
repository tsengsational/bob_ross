require_relative "../../bin/environment.rb"
require 'pry'

class Element
  attr_accessor :element
  attr_reader :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def initialize(element, id=nil)
    @element = element
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE elements (id INTEGER PRIMARY KEY, element TEXT);
    SQL
        DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE elements;"
    DB[:conn].execute(sql)
  end

  def save
    id_query = "SELECT COUNT(*) FROM elements;"
    # binding.pry
    @id = DB[:conn].execute(id_query).flatten[0] + 1
    sql = "INSERT INTO elements (element) VALUES (?)"
    arr = DB[:conn].execute(sql, [self.element])
    # @id =
  end

  def self.create(element:)
    new_element = self.new(element)
    new_element.save
    new_element
  end


  def self.insert_data
    elements = Data.transform[0].keys.pop(Data.transform[0].keys.size - 2).map {|element| "#{element}"}
    #binding.pry
    elements.each do |element|
      self.create(element: element)
    end
  end

  def self.find(element)
    sql = <<-SQL
    SELECT *
    FROM elements
    WHERE element = ?
    SQL

    element = DB[:conn].execute(sql, element).flatten
    binding.pry
    new_element = Element.new(element[0])
  end

  def destroy
    sql = <<-SQL
    DELETE
    FROM elements
    WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.id)
  end

  def update
    sql = <<-SQL
    UPDATE elements
    SET element = ?
    WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.element, self.id)
  end


end

#Pry.start
