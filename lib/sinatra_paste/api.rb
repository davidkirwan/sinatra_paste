

module The
class API

  attr_reader :db

  def self.configure()
    @db = The::Db.get_instance() unless defined? @db
    @languages = {"1"=>"text", "2"=>"javascript", "3"=>"python", "4"=>"ruby", "5"=>"c"}
  end
  
  def self.add_paste(params={})
    @db.execute(
                "INSERT INTO pastes (id,date,title,paste,language) VALUES (?,?,?,?,?)",
                nil, Time.now.utc.to_s, params["paste_title"], params["paste_input"], params["paste_language"]
               )
    rows = @db.execute("SELECT * FROM pastes ORDER BY id DESC LIMIT 1;")
    id, date, title, language, paste = rows[0]
    paste = { :id=>id, :date=>date, :title=>title, :paste=>paste, :language=>language, :lang_name=>@languages[language]}
    return paste
  end

  def self.get_pastes()
    rows = @db.execute("SELECT * FROM pastes ORDER BY id DESC LIMIT 5;")
    data = Array.new
    rows.each do |i|
      id, date, title, language, paste = i
      data << {:id=>id, :date=>date, :title=>title, :language=>language, :paste=>paste, :lang_name=>@languages[language]}
    end
    return data
  end

  def self.get_paste(id)
    rows = @db.execute("SELECT * FROM pastes where id=?;", id)
    id, date, title, language, paste = rows[0]
    return {:id=>id, :date=>date, :title=>title, :language=>language, :paste=>paste}
  end

  def self.delete_paste(id)
    @db.execute("DELETE FROM pastes where id=?;", id)
    return {:id=>id, :message=>"paste deleted"}
  end

  def self.get_pastes_size()
    row = @db.execute("SELECT count(*) FROM pastes;")
    return row[0][0]
  end

  def self.check_post_paste_params(params)
    puts "params: " + params.inspect
    
    if params["paste_input"].nil? ||
       params["paste_language"].nil? ||
       params["paste_title"].nil?
      return false
    else
      return true
    end
  end

end
end
