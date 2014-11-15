desc "This task is called by the Heroku scheduler add-on"
task :mark_finished_campaigns => :environment do
  puts "Starting marking finished campaigns..."

  	running_campaings = Campaign.where("isdisabled = false AND campaign_status_id = 2 AND campaigns.updated_at + interval '?' day < now()", Generic.get_campaign_run_interval)

  	if running_campaings.length > 0
  		running_campaings.each do |campaign|
  			campaign.campaign_status_id = 3 # Finished
			campaign.save
			puts "Marked as finished campaign #" + campaign.id.to_s
		end
  	end

  puts "Finished marking finished campaigns..."

end
