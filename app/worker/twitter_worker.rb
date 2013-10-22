class TwitterWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  
  def perform()
    Tweet.get_tweets
  end
end
