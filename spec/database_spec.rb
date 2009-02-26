require 'database'
require 'fileutils'


module DatabaseSpec
  describe Database do
    DB_FILE = 'errors.db'

    after(:each) do
      Property.reset
      begin
        FileUtils::rm(DB_FILE)
      rescue Errno::ENOENT; end
    end

    it "should create the schema when the database file doesn't exist" do
      db = Database.new(DB_FILE)
      db.driver.execute('SELECT * FROM error')
    end

    it "shouldn't create the schema when it already exists" do
      db = Database.new(DB_FILE)
      p = property :a => String do |a|
        a.size == a.length
        end
      db.insert_error(p, "az_")
      db2 = Database.new(DB_FILE)
      r = db.driver.execute('SELECT * FROM error')
      Marshal.load(r.first[1]).should == 'az_'
    end

    it 'should create the schema when the database file exists but not the tables' do
      db = Database.new(DB_FILE)
      db.driver.execute('DROP TABLE error')
      db2 = Database.new(DB_FILE)
      db2.driver.execute('SELECT * FROM error')
    end
  end
end
