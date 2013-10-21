class TwitterWorker
  include Sidekiq::Worker
  
  def perform()
    Tweet.get_tweets
  end
end
