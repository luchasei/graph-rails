class GraphController < ApplicationController
  def index
	if params[:interval].nil?
	  interval = 'minute' 
	else
	  interval = params[:interval]
	end

	search = Tire.search 'tweets' do
	  query { all }
	    facet 'created_at' do
	      date :created_at, interval: interval
	    end
	end

	facets = search.results.facets['created_at']['entries']
	@facet_time = []
	@facet_count = []
	
	facets.each { |f|
	  @facet_time.push(Time.at(f['time']/1000).strftime "%FT%R")
	  @facet_count.push(f['count'])
	}

        @bargraph = LazyHighCharts::HighChart.new('graph') do |f| 
          f.title(:text => "Tweets About Obama by #{interval.capitalize}")
          f.xAxis(:categories => @facet_time, :labels => {:enabled => false} )
          f.series(:name => "Tweets Collected", :yAxis => 0, :data => @facet_count)
          f.yAxis({:title => {:text => "Tweets Collected", :margin => 20} })
	  f.legend({:enabled => false})
          f.chart({:defaultSeriesType=>"column"})
        end
  end

  def change_interval
	graph_interval = params[:interval] 	
	puts graph_interval
  end

end
