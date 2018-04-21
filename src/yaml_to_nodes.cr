require "yaml"

Dir.new("#{__DIR__}/../world").children.each do |file|
  data = YAML.parse(File.read("#{__DIR__}/../world/#{file}"))

  puts %Q(Node.new("#{data["name"].as_s}").tap do |node|)
  puts %Q(node.description = <<-NODE_DESCRIPTION)
  puts data["description"].as_s
  puts %Q(NODE_DESCRIPTION)

  data["links"].each do |link_name, link_description|
    puts %Q(node.links << Link.new("#{link_name}", "#{link_description}"))
  end

  puts %Q(crest << node)
  puts %Q(end)
  puts
end
