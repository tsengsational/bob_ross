require 'csv'
require 'pry'

class Data
attr_accessor

@@extracted_data = CSV.table('bin/elements-by-episode.csv')
@@transform = @@extracted_data.map { |row| row.to_h }

values_1 = transform.each_with_object([]) { |row, arr|  arr << "(#{row[:episode].slice(1, 2)})"}.uniq.join(", ")

@@insert_1 = "INSERT INTO seasons (season) VALUES #{values_1};"

values_2 = transform.each_with_object([]) { |row, arr| arr << "(#{row[:episode].split("E").pop}, #{row[:title]}, #{row[:episode].slice(1, 2)})" }.join(", ")

@@insert_2 = "INSERT INTO episodes (episode, title, season_id) VALUES #{values_2};"

values_3 = transform[0].keys.pop(transform[0].keys.size - 2).map {|element| "(#{element})"}.join(", ")

@@insert_3 = "INSERT INTO elements (element) VALUES #{values_3}"

values_4 = transform.each_with_object([]) do |row, arr|
  row.each_with_index do |(column, value), index|
    if value == 1
      arr << "(#{row[:episode].split("E").pop}, #{index - 1})"
    end
  end
end.join(', ')


@@insert_4 = "INSERT INTO episodes_elements (ep_id, el_id) VALUES #{values_4};"

def insert_1
  @@insert_1
end

def insert_2
  @@insert_2
end

def insert_3
  @@insert_3
end

def insert_4
  @@insert_4
end

Pry.start
end
