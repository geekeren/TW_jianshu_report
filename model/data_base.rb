require "sqlite3"
class DataBase < SQLite3::Database

def initialize
  @db = super.new "data/jianshu.sqlite3"
end
# Open a database

end