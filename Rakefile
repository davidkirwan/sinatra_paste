require File.join(File.dirname(__FILE__), '/lib/sinatra_paste/db')

namespace :db do
  
  desc "Create the DB and populate it with some initial pastes"
  task :create do
    @db = The::Db.get_instance()
    The::Db.create_table()
    The::Db.populate_table()
  end

  desc "Drop the paste tables in the DB"
  task :drop do
    @db = The::Db.get_instance()
    The::Db.drop_tables()
  end
end
