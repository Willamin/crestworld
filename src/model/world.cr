module World
  alias SimpleInfo = Tuple(String, Array(Choice))
  alias ComplexInfo = Tuple(String, Array(Choice), Hash(String, JSON::Type))

  def self.info_at(data) : SimpleInfo | ComplexInfo
    position = data["position"]?
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
    when "platform_2a"
      {
        "On the far side of this island is a ladder that goes underground. Behind you is a platform that's within jumping distance",
        [
          Choice.new("first_platform", "Jump to the platform behind you"),
          Choice.new("inside_2a", "Climb down the ladder"),
        ],
      }
    when "inside_2a"
      extra = ""
      if data["2a_left?"]?
        extra += " It looks like the left button has been pressed."
      end
      {
        "After climbing down the ladder, you find your self in a small room. There is a small television screen that's been smashed, a control panel with 2 buttons, and an uncomfortable looking chair." + extra,
        [
          Choice.new("platform_2a", "Climb back up the ladder"),
          Choice.new("left_button", "Push the left button"),
          Choice.new("right_button", "Push the right button"),
        ],
      }
    when "left_button"
      if data["2a_left?"]?
        {
          "It doesn't seem like pressing the button more will have any effect.",
          [Choice.new("inside_2a", "Continue")],
        }
      else
        data["2a_left?"] = true
        {
          "You press the left button. Briefly, the television screen flickers, but goes dim moments later.",
          [Choice.new("inside_2a", "Continue")],
          data,
        }
      end
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
