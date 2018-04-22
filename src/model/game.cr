require "granite_orm/adapter/pg"
require "uuid"
require "json"

class Game < Granite::ORM::Base
  include Stout::Magic
  adapter pg
  field uuid : String
  field data : String

  property uuid : String?
  property data : String?
  property description = "Welcome to Crest World"
  property choices = [] of Choice

  def initialize; end

  def initialize(@uuid); end

  def self.routes(server)
    server.get("/", :game_start, &->start(Stout::Context))
    server.get("/game", &->start(Stout::Context))
    server.get("/game/:game_uuid", :game_show, &->show(Stout::Context))
    server.post("/game/:game_uuid", :game_update, &->update(Stout::Context))
    server.get("/info") do |context|
      pp ENV
      pp Dir.current
    end
  end

  def self.start(context)
    game_id = UUID.random
    context.response.headers["Location"] = "/game/#{game_id}"
    context.response.status_code = 302
  end

  ECR.def_to_s "#{__DIR__}/../template/game.html.ecr"

  def self.show(context)
    uuid = context.params["game_uuid"]?

    if uuid.nil?
      return self.start(context)
    end

    uuid = uuid.to_s

    game = Game.find_or_create_by(:uuid, uuid)
    if game.data.nil?
      game.data = "{}"
      game.save
    end

    game.data.try do |data|
      data = JSON.parse(data).as_h
      info = World.info_at(data["position"]?)
      game.description = info[0]
      game.choices = info[1]
    end

    context << game.to_s
  rescue e
    pp e
  end

  def self.update(context)
    uuid = context.params["game_uuid"]?
    choice = context
      .params
      .post_params
      .try &.as_h
      .select { |param| param.starts_with?("choice") }
      .first
      .first
      .match(/choice\[(.*)\]/)
      .try &.[1]

    if uuid.nil?
      return self.start(context)
    end

    uuid = uuid.to_s
    game = Game.find_or_create_by(:uuid, uuid)
    game.save

    game.data.try do |data|
      data = JSON.parse(data).as_h
      data["position"] = choice
      game.data = data.to_json
      game.save
    end

    context.response.headers["Location"] = "/game/#{uuid}"
    context.response.status_code = 302
    puts
  rescue e
    pp e
  end

  def self.find_or_create_by(key, value)
    game = Game.find_by(key, value)
    if game.nil?
      game = Game.new(value)
      game.save
    end
    game
  end

  def self.schema
    <<-SQL
    CREATE TABLE games (
      id BIGSERIAL PRIMARY KEY,
      uuid UUID UNIQUE,
      data TEXT,
      created_at TIMESTAMP,
      updated_at TIMESTAMP
    );
    SQL
  end
end
