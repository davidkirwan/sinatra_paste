require "sqlite3"

module The
class Db

  def self.drop_tables()
    rows = @db.execute <<-SQL
      drop table if exists pastes;
    SQL
  end

  def self.create_table()
    @db.execute <<-SQL
      create table if not exists pastes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        title TEXT,
        language TEXT,
        paste TEXT
      );
    SQL
  end

  def self.populate_table()
    size = @db.execute("SELECT count(*) FROM pastes;")

    if size[0][0] == 0
      initial = [ 
	        {:date=>Time.now.utc - 5000, :title=>"title 5", :language=>"4", :paste=>"some paste 5000"}, 
	        {:date=>Time.now.utc - 4000, :title=>"title 4", :language=>"1", :paste=>"some paste 4000"},
		{:date=>Time.now.utc - 3000, :title=>"title 3", :language=>"2", :paste=>"some paste 3000"},
		{:date=>Time.now.utc - 2000, :title=>"title 2", :language=>"2", :paste=>"some paste 2000"},
		{:date=>Time.now.utc - 1000, :title=>"title 1", :language=>"3", :paste=>"some paste 1000"},
		{:date=>Time.now.utc, :title=>"Latest title", :language=>"4", :paste=>"some paste latest"}
	      ]
      initial.each do |i|
        @db.execute("INSERT INTO pastes (id,date,title,language,paste) VALUES (?,?,?,?,?)", 
                    nil, i[:date].to_s, i[:title], i[:language], i[:paste])
      end
    end
  end

  # {"date":"2015-12-25 20:58:03 UTC","title":"dfdf","paste":"dfdf","language":"1","id":1006}
  def self.get_instance()
    begin
      @db = SQLite3::Database.new "pastes.db"
      @db
    rescue SQLite3::Exception => e
      puts e.backtrace
    end
  end
  
end
end

