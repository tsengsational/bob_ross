CREATE TABLE seasons (id INTEGER PRIMARY KEY, season INTEGER);
CREATE TABLE episodes (id INTEGER PRIMARY KEY, episode_number INTEGER, title TEXT, season_id INTEGER);
CREATE TABLE elements (id INTEGER PRIMARY KEY, element TEXT);
CREATE TABLE episodes_elements (id INTEGER PRIMARY KEY, ep_id INTEGER, el_id INTEGER);
