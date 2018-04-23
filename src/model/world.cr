require "./world/*"

module World
  alias SimpleInfo = Tuple(String, Array(Choice))
  alias ComplexInfo = Tuple(String, Array(Choice), Hash(String, JSON::Type))

  def self.info_at(data) : SimpleInfo | ComplexInfo
    d = World::Ocean.info_at(data)
    unless d.nil?
      return d
    end

    position = data["position"]?
    case position
    when ""
      {"", [] of Choice}
    when .nil?, "welcome"
      {
        "Welcome to Crest World, a game created for the 41st Ludum Dare Game Jam. My take on the theme \"combine two incompatible genres\" is a choose-your-own-adventure platformer. <br><br>Have fun!",
        [
          Choice.new("cliff", "1 Player Start"),
        ],
      }
    else
      {
        "Position <span class=\"position\">#{position}</span> not found.",
        [Choice.new("welcome", "Restart")],
      }
    end
  end
end
