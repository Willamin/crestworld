require "yaml"
require "stout"
Stout::Magic.deft

require "./model/*"

database = YAML.parse(File.read({{__DIR__}} + "/../config/database.yml"))["pg"]["database"].as_s

DB.open database do |db|
  db.exec Game.schema
rescue e : PQ::PQError
  if e.field_message(:code) != "42P07" # duplicate table error
    raise e
  end

  puts "table already exists"
end

server = Stout::Server.new
Game.routes(server)
server.default_route = "/"
server.listen
