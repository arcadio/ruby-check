require 'errordatabase'
require 'fileutils'
require 'property_helpers'


module ErrorDatabaseSpec
  describe ErrorDatabase do
    include PropertyHelpers

    DB_FILE = 'errors.db'

    it_should_behave_like 'Property'

    after(:each) do
      begin
        FileUtils::rm(DB_FILE)
      rescue Errno::ENOENT; end
    end

    it "should create the schema when the database file doesn't exist" do
      db = ErrorDatabase.new(DB_FILE)
      db.driver.execute('SELECT * FROM error')
    end

    it 'should not create the schema when it already exists' do
      db = ErrorDatabase.new(DB_FILE)
      p = property :a => String do |a|
        a.size == a.length
        end
      d = Marshal.dump(['a'])
      db.driver.execute("INSERT INTO error VALUES ('p1', '#{d}', 0.5)")
      db2 = ErrorDatabase.new(DB_FILE)
      r = db.driver.execute('SELECT * FROM error')
      Marshal.load(r.first[1]).should == ['a']
    end

    it 'should create the schema when the database file but not the
    tables exist' do
      db = ErrorDatabase.new(DB_FILE)
      db.driver.execute('DROP TABLE error')
      db2 = ErrorDatabase.new(DB_FILE)
      db2.driver.execute('SELECT * FROM error')
    end

    it 'should insert errors correctly when they do not exist' do
      db = ErrorDatabase.new(DB_FILE)
      p = property :p1 => [Fixnum, String] do |a,b| true end
      db.insert_error(p, [1, 'ab'])
      db.driver.execute('SELECT * FROM error').should ==
        [['p1', Marshal.dump([1, 'ab']), 1.0]]
    end

    it 'should insert errors correctly when they exist'

    it 'should update data correctly'

    it 'should return the failing cases ordered correctly and unmarshalled' do
      p = property :p1 => [Fixnum, String] do |a,b| true end
      db = ErrorDatabase.new(DB_FILE)
      c1 = [123, 'abc']
      m1 = Marshal.dump(c1)
      db.driver.execute("INSERT INTO error VALUES ('p1', '#{m1}', 0.5)")
      c2 = [245, 'cde']
      m2 = Marshal.dump(c2)
      db.driver.execute("INSERT INTO error VALUES ('p1', '#{m2}', 1)")
      db.get_cases(p).should == [c2, c1]
    end
  end
end
