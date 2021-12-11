require_relative 'redis_handler'

class Questionnaire
  LANGUAGES = ['Ruby', 'Javascript', 'Swift (iOS)', 'Java (Android)', 'C#'].freeze

  def self.prompt
    puts question = 'Do you wish to run the questionnaire? [Yes/Fresh start/No]'
    
    loop do
      response = $stdin.gets.chomp

      case response
      when 'Yes'
        run 
        break
      when 'Fresh start'
        fresh_run
        break
      when 'No'  
        puts "Goodbye"
        break
      else
        puts 'Invalid input. ' + question
      end
    end
  end

  def self.run
    responses = []

    LANGUAGES.each do |lang|
      loop do
        puts "Can you code in #{lang}?"
        response = $stdin.gets.chomp

        if response == 'Yes' || response == 'No'
          responses << response
          break
        end
      end
    end

    puts "Rating for current run is #{rating_for_current_run(responses)}/100"
    puts "Rating for all runs is #{get_average_rating}/100"
  end

  def self.rating_for_current_run(responses)
    positive_responses = responses.filter { |response| response == 'Yes' }.count

    rating = (positive_responses.to_f / LANGUAGES.length) * 100

    # Use Redis' rpush method to initiate a list of ratings (if none found) or
    # push to an existing list of ratings
    redis.push(rating)

    rating
  end

  def self.get_average_rating
    # Conversion to integers needed because Redis stores all list values as strings
    sum_of_ratings = redis.all_runs.map(&:to_i).reduce(&:+)
    number_of_runs = redis.all_runs.length

    (sum_of_ratings.to_f / number_of_runs).round(2)
  end

  def self.fresh_run
    redis.delete_all_keys
    run
  end

  def self.redis
    @redis ||= RedisHandler.new
  end
end
