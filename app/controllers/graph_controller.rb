class GraphController < ApplicationController
  def index
	#Default to minutes if no parameter specified
	if params[:interval].nil?
	  interval = 'minute' 
	else
	  interval = params[:interval]
	end

	#Perform a date_histogram facet search on elasticsearch cluster
	search = Tire.search 'tweets' do
	  query { all }
	    facet 'created_at' do
	      date :created_at, interval: interval
	    end
	end

	#Extract the facets from the search.
	facets = search.results.facets['created_at']['entries']
	@facet_time = []
	@facet_count = []
	
	#Divide the facet pairs into 2 separate arrays and make sense of time
	facets.each { |f|
	  @facet_time.push(Time.at(f['time']/1000).strftime "%FT%R")
	  @facet_count.push(f['count'])
	}

	#create a bargraph with the new series data
        @bargraph = LazyHighCharts::HighChart.new('graph') do |f| 
          f.title(:text => "Tweets About Obama by #{interval.capitalize}")
          f.xAxis(:categories => @facet_time, :labels => {:enabled => false} )
          f.series(:name => "Tweets Collected", :yAxis => 0, :data => @facet_count)
          f.yAxis({:title => {:text => "Tweets Collected", :margin => 20} })
	  f.legend({:enabled => false})
          f.chart({:defaultSeriesType=>"column"})
        end
  end


end
