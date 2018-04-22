module World
  def self.info_at(position) : Tuple(String, Array(Choice))
    case position
    when ""
      {"", [] of Choice}
    when "cliff"
      {
        "You're standing on the edge of a cliff, overlooking an ocean. It seems high enough that you'd perish if you fell. Ahead of you and a little higher, there's a floating platform. It appears as though you can reach if if you jump.",
        [Choice.new("first_platform", "Jump to the platform")],
      }
    when "first_platform"
      {
        "You managed to reach the platform! Behind you is the bluff. Below you and to your right is another floating island. A third floating island hovers to your left.",
        [
          Choice.new("cliff", "Jump back to the cliff"),
          Choice.new("platform_2a", "Jump to the right"),
          Choice.new("platform_2b", "Jump to the left"),
        ],
      }
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
