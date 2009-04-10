require 'property'
require 'rubygems'
require 'sqlite3'


class ErrorDatabase
  attr_reader :alpha, :driver

  def initialize(file, alpha = 0.6)
    @alpha = alpha
    @driver = SQLite3::Database.new(file, :type_translation => true)
    create_schema
  end

  def insert_error(property, tcase)
    k = property.key.to_s
    m = Marshal.dump(tcase)
    where = "WHERE property='#{k}' and tcase='#{m}'"
      c = @driver.get_first_row("SELECT COUNT(*) FROM error #{where}").first.to_i
    if c == 0
      @driver.execute("INSERT INTO error VALUES ('#{k}', '#{m}', 1)")
    else
      p = @driver.get_first_row("SELECT probability FROM error #{where}").first
      p = alpha + (1 - alpha ) * p
      @driver.execute("UPDATE error SET probability=#{p} #{where}")
    end

    # insertar en base de datos
    # si error no esta insertar
    # si esta actualizar

    # update_property excepto caso
  end

  def update_property(property)
    # actualizar probabilidades

  end

  def get_cases(property)
    @driver.execute("SELECT tcase FROM error WHERE property = '#{property.key}' " +
                    'ORDER BY probability DESC').map { |e| Marshal.load(e.first) }
  end

  private

  def create_schema
    sql =
<<SQL
      CREATE TABLE IF NOT EXISTS error(
        property VARCHAR(16),
        tcase BLOB,
        probability REAL NOT NULL,
        PRIMARY KEY (property, tcase)
      );
SQL
    @driver.execute_batch(sql)
  end
end
