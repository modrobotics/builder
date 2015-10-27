autoload :Lundby, "#{BUILDER_DIRECTORY}/lundby.rb"
require 'numbers_in_words'
require 'numbers_in_words/duck_punch'
require 'httparty'

class Builder
  def self.build(all_types, is_kits)
    built = []

    elves = JSON.parse(HTTParty.get("http://tasks.internal.modrobotics.com/elves", headers: {'accept'=>"application/json"}).body)
    loop do
      puts "Enter your last name:"
      last_name = gets.chomp.downcase

      matches = elves.select{|e| e['name'].downcase.include? last_name}

      case matches.length
      when 0
        puts "No match!"        
      when 1
        @elf = matches.first
        break
      else
        puts "Wait, who are you?"
        matches.each_with_index do |e, i|
          puts "#{i+1} - #{e['name']}"
        end
        selection = gets.chomp.to_i
        @elf = matches[selection-1]
        break
      end
    end

    loop do
      system('cls')
      if built.length > 0
        puts "Today, you have built:"
        built.each {|b| puts b}
        puts
      end 
      puts "Welcome to Builder, #{@elf['name']}!"

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
          @number = entry.in_numbers
          if @number == 0 && entry != 'zero'
            puts "Sorry, I don't recognize that number. Please try again."
          else
            break
          end
        end        

        print "Now building #{@number} #{type['name']}s"
        print '.'

        if is_kits
          Lundby.kit(@number, type['name'])
        end

        print '.'

        #Send HTTP requests to the current TMI server. This is good for now, but ideally TMI will be removed from the transaction.
        response = JSON.parse(HTTParty.post("http://tasks.internal.modrobotics.com/task_types/#{type['id']}/postselect?elf_id=#{@elf['id']}", headers: {'accept'=>"application/json"}).body)
        task_id = response['id']
        
        print '.'
        sleep 1
        print '.'
        
        response = JSON.parse(HTTParty.put("http://tasks.internal.modrobotics.com/tasks/#{task_id}/complete", 
                                           headers: {'accept'=>"application/json"},
                                           body: {'passed'=>@number}).body)
        
        print '.'

        if response['success']
          built << "#{Time.now.strftime('%X')}: #{@number} #{type['name']}s"
          puts
          puts ["All Done!", "Snazzy!", "Ka-Pow!", "Fancy!", "Wowzers!"].sample
          sleep 1
        else
          puts "Submission failed somewhere!"
          puts response
          puts "Deleting task..."
          response = JSON.parse(HTTParty.delete("http://tasks.internal.modrobotics.com/tasks/#{task_id}", headers: {'accept'=>"application/json"}).body)
          exit
        end
      end
    end
  end
end
