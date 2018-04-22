class Static
  include Stout::Magic

  def self.routes(server)
    server.get("/clean.css") do |context|
      context << ecrs("#{__DIR__}/../static/clean.css")
    end

    server.get("/game.css") do |context|
      context << ecrs("#{__DIR__}/../static/game.css")
    end

    server.get("/game.js") do |context|
      context << ecrs("#{__DIR__}/../static/game.js")
    end
  end
end
