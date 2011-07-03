require 'active_record'

module Apart

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3" ,
  :host => "localhost" ,
  :username => "" ,
  :password => "" ,
  :database => "c:/boomerang/db/boomerang.db"
)

end