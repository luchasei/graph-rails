class Tweet < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks

  #Method to collect tweets on a cron job
  def self.get_tweets
     #make stats interesting instead of being flat
     count = rand(3..15)     
     
     #Create Twitter Search object
     Twitter.search("obama", :count=>count, :result_type=>"recent").results.map do |status|
	#Make sure we don't collect duplicates
	unless Tweet.exists?(['text = ? AND from_user = ?', status.text, status.from_user])
		Tweet.create!({
			:from_user => status.from_user,
			:text => status.text,
			:created_at => status.created_at
		 })
	end
      end
   end

end
