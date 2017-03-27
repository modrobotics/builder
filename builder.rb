require 'numbers_in_words'
require 'numbers_in_words/duck_punch'
require 'httparty'

response = JSON.parse(HTTParty.get("https://dash.modrobotics.com/modules/assemblyCompletions/api.php",
                                   verify: false, query: {"action" => 'getItems', "secret" => 'depressedleprechaun'}).body)

all_types = [
             {title: 'Box Cubelets', types: response.select{|t| t['category'] == "box_cubelet"}}, 
             {title: 'MOSS', types: response.select{|t| t['category'] == "moss"}}, 
             {title: 'Kits', types: response.select{|t| t['category'] == "kitting"}}
            ]

built = []

puts "Enter your last name:"
last_name = gets.chomp.downcase

loop do
  system('cls')
  if built.length > 0
    puts "Today, you have built:"
    built.each {|b| puts b}
    puts
  end 
  puts "Welcome to Builder, #{last_name}!"

  if all_types.length == 1
    types = all_types[0]
  else
    puts "Choose a category:"
    all_types.each_with_index do |t, i|
      puts "#{i+1} - #{t[:title]}"
    end
    selection = gets.chomp.to_i
    puts all_types[selection-1][:title] + ":"
    types = all_types[selection-1][:types]
  end

  types.each do |t|
    puts "#{t['id']} - #{t['name']}"
  end
  selection = gets.chomp
  
  type = types.select{|t| t['id'].to_i == selection.to_i}.first
  if type.nil?
    puts "I don't recognize that command! Restarting..."
    sleep 1
    system('cls')
  else

    loop do
      puts "#{type['name']}: How many would you like to build? (Use words, not digits)"
      entry = gets.chomp
      @quantity = entry.in_numbers
      if @quantity == 0 && entry != 'zero'
        puts "Sorry, I don't recognize that number. Please try again."
      else
        break
      end
    end        

    print "Now building #{@quantity} #{type['name']}s"
    print '.'
    response = HTTParty.post(
                             "https://dash.modrobotics.com/modules/assemblyCompletions/api.php",
                             body: {
                               "action" => 'postCompletion', 
                               "secret" => "depressedleprechaun", 
                               "task_type_id" => type['id'], 
                               "last_name" => last_name, 
                               "quantity" => @quantity},
			     verify: false
                             )

    if response['success']
      built << "#{@quantity} #{type['name']}s (#{Time.now.strftime('%I:%M %p')})"
      puts
      puts ["All Done!", "Snazzy!", "Ka-Pow!", "Fancy!", "Wowzers!"].sample
      sleep 1
    else
      puts "Submission failed somewhere!"
      puts response
    end
  end
end
