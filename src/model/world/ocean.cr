module World::Ocean
  def self.info_at(data) : SimpleInfo | ComplexInfo | Nil
    position = data["position"]?
    case position
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
    when "right_button"
      {
        "You press the right button. Nothing happens.",
        [Choice.new("inside_2a", "Continue")],
      }
    when "left_button"
      if data["2a_left?"]?
        {
          "You press the left button. Nothing happens.",
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
    when "platform_2b"
      if data["2a_left?"]?
        {
          "A platform floats just out of reach. On it is a pedestal. A short metal bridge juts out from the island towards it. Behind you is another platform.",
          [
            Choice.new("first_platform", "Jump on the platform behind you"),
            Choice.new("third_platform", "Jump to the island with the pedestal."),
          ],
        }
      else
        {
          "A platform floats just out of reach. On it is a pedestal. Behind you is another platform.",
          [
            Choice.new("death", "Try to jump anyways"),
            Choice.new("first_platform", "Jump on the platform behind you"),
          ],
        }
      end
    when "death"
      {
        "That jump must've been too far. You fall to your death.",
        [Choice.new("welcome", "Game Over")],
      }
    when "third_platform"
      {
        "You land on the platform successfully! In the middle is a pedestal. Behind you is a floating island.",
        [
          Choice.new("platform_2b", "Jump to the island behind you."),
          Choice.new("pedestal", "Examine the pedestal"),
        ],
      }
    when "pedestal"
      {
        "You find an inscription on the pedestal. It reads:<quote>I hope you enjoyed this journey. I wanted to keep this short and sweet. No one wants to play a text adventure platformer for too long. Thanks for playing!</quote>",
        [
          Choice.new("welcome", "Continue"),
        ],
      }
    else
      nil
    end
  end
end
