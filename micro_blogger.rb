require 'jumpstart_auth'
require 'bitly'
require 'klout'


class MicroBlogger
  attr_reader :client

  def initialize
    puts "Initializing"
   @client = JumpstartAuth.twitter
   Bitly.use_api_version_3
   @bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6') 
   Klout.api_key = 'xu9ztgnacmjx3bu82warbr3h'
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
         when 'spam' then spam_my_follo       
         when 'spam' then spam_my_followers(parts[1..-1].join(" "))
         when 'elt' then everyones_last_tweet
         when 's' then shorten(parts[1])
         when 'turl' then tweet parts[1..-2].join(" ") + " " +shorten(parts[-1])         when 'klout' then klout_scores 
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
   @client.followers.each do |follower|
   screen_names << follower ['screen_name'] 
   end 
   screen_names
end

  def spam_my_followers(message)
   followers_list.each do |follower|
   dm(follower, message)
   end
  end

  def everyones_last_tweet	
   friends = @client.friends
   friends.collect {|friend| friend.screen_name.downcase}
   friends.sort_by! {|friend| friend.screen_name}

   friends.each do |friend|
    last_tweet = friend.status.text
    timestamp = friend.status.created_at
    date = timestamp.strftime("%A, %b %d")
    puts "#{friend.screen_name} said this on #{date}:"
    puts "#{last_tweet}"
    end
  end

  def shorten(original_url)
    short_url = @bitly.shorten(original_url).short_url
    puts "Shortening this URL: #{short_url}"
  end

  def klout_scores
   friends = friends = @client.friends.collect{|f| f.screen_name}
   friends.each do |friend|
   identity = Klout::Identity.find_by_screen_name(friend)
      user = Klout::User.new(identity.id)
      puts friend+" has "+user.score.score.round(2).to_s+" Klout score."
     puts ""
   end
 end
end

blogger = MicroBlogger.new
blogger.run
blogger.klout_scores
