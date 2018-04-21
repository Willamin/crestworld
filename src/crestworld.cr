require "crest"

crest = Crest.new

{{ run("#{__DIR__}/yaml_to_nodes.cr") }}

crest.current_node = "cliff"
crest.show
