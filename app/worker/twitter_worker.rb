class TwitterWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  
  #Async worker to get a tweet
  #Fires according to the time schedule in schedule.rb 
  def perform()
    Tweet.get_tweets
  end
end
