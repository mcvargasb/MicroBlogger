require 'jumpstart_auth'

class MicroBlogger
  attr_reader :client

  def initialize
    puts "Initializing"
    @client = JumpstartAuth.twitter
  end

    def run
    command = ""
    while command != "q"
      puts ""
      printf "enter command: "
      input = gets.chomp
      parts = input.split
      command = parts[0]
      case command
         when 'q' then puts "Goodbye!"
         when 't' then tweet(parts[1..-1].join(" "))
         when 'dm' then dm(parts[1], parts[2..-1].join(" "))
      else
           puts "Sorry, I don't know how to (#{command})"
      end
    end
  end

  def tweet(message)
   if message.length > 140
    puts "The message is longer than 140 characters"
   else     
    @client.update(message)
   end
  end

  def dm(target, message)
   string = "d"+" "+target+" "+message
   screen_names = @client.followers.collect{|follower|follower.screen_name}
   
   if screen_names.include?(target)
    puts "Trying to send #{target} this direct message:"
    puts message
    tweet(string)
   else
    puts "You can only DM people who follow you"
   end
 end

  def followers_list
   screen_names = []
  end 
end

blogger = MicroBlogger.new
blogger.run
