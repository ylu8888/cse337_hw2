#!/usr/bin/env ruby
VALID_OPTIONS = ["-w", "-p", "-v", "-c", "-m"]
INVALID_OPTION_REGEX = /^-[^0-9wpvcm]$/ #regex for invalid option

#this is to store filename, options, and pattern
filename = nil
options = {}
pattern = nil

#parse each command line argument
ARGV.each do |arg|
  if arg =~ INVALID_OPTION_REGEX
    puts "Invalid option"
    exit
  elsif VALID_OPTIONS.include?(arg) #check if option is included in valid opts
    options[arg] = true
  elsif filename.nil? #filename comes before pattern so fill it first
    filename = arg
  elsif pattern.nil?
    pattern = arg
  else #otherwise we have an invalid combination
    puts "Invalid combination of options"
    exit
  end
end

#if filename or pattern is missing
if filename.nil? || pattern.nil?
  puts "Missing required arguments"
  exit
end

#check for invalid combinations edge cases
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

#the default p is set if the options are empty
options["-p"] = true if options.empty?

#read file line by line
begin
  lines = File.readlines(filename)
rescue Errno::ENOENT #if the file is not found
  puts "File not found"
  exit
end

matches = []

lines.each do |line|
  if options["-w"]
    #if the pattern is found in line, append the whole line
    matches << line if line.match?(/\b#{Regexp.escape(pattern)}\b/)
  elsif options["-p"]
    #if regex pattern matches in line, append
    matches << line if line.match(/#{pattern}/)
  elsif options["-v"]
    #adds the line only if does not match the given pattern
    matches << line unless line.match(/#{pattern}/)
  end
end

if options["-c"] #prints the count of matching lines if c is an arg
  puts matches.size
elsif options["-m"] #prints the matched parts of lines if m is arg
  matches.each { |match| puts match.scan(/\b#{Regexp.escape(pattern)}\b/) }
else
  puts matches
end


=begin

# Test case 1: Invalid option
ruby rgrep.rb test.txt -x
# Test case 2: File Not Found
ruby rgrep.rb hubba.txt -w
# Test case 3: Word search
ruby rgrep.rb test.txt -w street
# Test case 4: Regex search with count
ruby rgrep.rb test.txt -p -c "\d\d"
# Test case 5: Inverted search
ruby rgrep.rb test.txt -v "^\d\d"

=end
