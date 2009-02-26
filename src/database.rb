require 'rubygems'
require 'sqlite3'


class Database
  attr_reader :db

  def initialize(file)
    @db = SQLite3::Database.new(file, :type_translation => true)
    create_schema
    prepare_statements
  end

  def insert_error(property, input)
    @ins.execute(property.key, Marshal.dump(input))
  end

  private

  def create_schema
    sql =
<<SQL
      CREATE TABLE IF NOT EXISTS error(
        property VARCHAR(16) NOT NULL,
        input BLOB NOT NULL,
        time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP);
SQL
    @db.execute_batch(sql)
  end

  def prepare_statements
    @ins = db.prepare("INSERT INTO error(property, input) VALUES (?, ?)")
  end
end
