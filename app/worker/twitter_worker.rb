class TwitterWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  
  #Async worker to get a tweet
  def perform()
    Tweet.get_tweets
  end
end
