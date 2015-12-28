module The
class API

  attr_reader :db

  def self.configure()
    @db = The::Db.get_instance() unless defined? @db
    @languages = {"1"=>"text", "2"=>"javascript", "3"=>"python", "4"=>"ruby", "5"=>"c", "6"=>"c++", "7"=>"java"}
  end
  
  def self.add_paste(params={})
    @db.execute(
                "INSERT INTO pastes (id,date,title,paste,language) VALUES (?,?,?,?,?)",
                nil, Time.now.utc.to_s, params["paste_title"], params["paste_input"], params["paste_language"]
               )
    rows = @db.execute("SELECT id FROM pastes ORDER BY id DESC LIMIT 1;")
    id = rows[0][0]
    paste = { :id=>id, :message=>"paste successfully added"}
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
    return {:id=>id, :date=>date, :title=>title, :language=>language, :paste=>paste, :lang_name=>@languages[language]}
  end

  def self.update_paste(id, params={})
    @db.execute(
                "UPDATE pastes SET date=?, title=?, paste=?, language=? WHERE id=?",
                Time.now.utc.to_s, params["paste_title"], params["paste_input"], params["paste_language"], id
               )
    paste = { :id=>id, :message=>"paste successfully updated"}
    return paste
  end

  def self.delete_paste(id)
    @db.execute("DELETE FROM pastes where id=?;", id)
    return {:id=>id.to_i, :message=>"paste deleted"}
  end

  def self.get_pastes_size()
    row = @db.execute("SELECT count(*) FROM pastes;")
    return row[0][0]
  end

  def self.check_post_paste_params(params)
    if params["paste_input"].nil? ||
       params["paste_language"].nil? ||
       params["paste_title"].nil? ||
       params["paste_input"] == "" || params["paste_input"] == "Enter text" ||
       params["paste_title"] == "" || params["paste_title"] == "Enter title" ||
       params["paste_language"] == ""
      return false, {:message=>"Invalid parameters"}
    else
      return true, {:message=>"Parameters valid"}
    end
  end

end
end
