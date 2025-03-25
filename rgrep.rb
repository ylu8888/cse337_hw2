#!/usr/bin/env ruby

# Check if an option is valid
VALID_OPTIONS = %w[-w -p -v -c -m]
INVALID_OPTION_REGEX = /^-[^0-9wpvcm]$/

# Parsing arguments
filename = nil
options = {}
pattern = nil

ARGV.each_with_index do |arg, index|
  if arg =~ INVALID_OPTION_REGEX
    puts "Invalid option"
    exit
  elsif VALID_OPTIONS.include?(arg)
    options[arg] = true
  elsif filename.nil?
    filename = arg
  elsif pattern.nil?
    pattern = arg
  else
    puts "Invalid combination of options"
    exit
  end
end

# Check for missing arguments
if filename.nil? || pattern.nil?
  puts "Missing required arguments"
  exit
end

# Ensure valid option combinations
if options["-c"] && !(options["-w"] || options["-p"] || options["-v"])
  puts "Invalid combination of options"
  exit
end
if options["-m"] && !(options["-w"] || options["-p"])
  puts "Invalid combination of options"
  exit
end
if options["-m"] && options["-v"]
  puts "Invalid combination of options"
  exit
end

# Default option is -p if none are given
options["-p"] = true if options.empty?

# Read file and apply search
begin
  lines = File.readlines(filename)
rescue Errno::ENOENT
  puts "File not found"
  exit
end

matches = []

lines.each do |line|
  if options["-w"]
    matches << line if line.split.any? { |word| word.match(/\b#{pattern}\b/) }
  elsif options["-p"]
    matches << line if line.match(/#{pattern}/)
  elsif options["-v"]
    matches << line unless line.match(/#{pattern}/)
  end
end

if options["-c"]
  puts matches.size
elsif options["-m"]
  matches.each { |line| puts line.scan(/#{pattern}/).join("\n") }
else
  puts matches
end

=begin
./rgrep.rb
./rgrep.rb test.txt
./rgrep.rb test.txt -f
./rgrep.rb test.txt –v –m ‘\d’
./rgrep.rb test.txt –w road
./rgrep.rb test.txt -w -m road
./rgrep.rb test.txt -w -c road
./rgrep.rb test.txt -p `\d\d'  
./rgrep.rb test.txt -p -c `\d\d' 
./rgrep.rb test.txt -v `^\d\d'   
./rgrep.rb test.txt -v -c '^\d\d'
./rgrep.rb test.txt '\d\d'   
=end
