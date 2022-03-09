require 'rest-client'
require 'open-uri'
require 'json'

begin
	# Download the latest backup
	response = RestClient.get 'https://www.autobus.io/api/snapshots/latest', {params: {"token": "804f1114551852d6bdac04264c5b66a2d44dd1ed48fe1184"}}
	puts response.body
	File.open('/Users/davide/WorkingOn/AVQ/Backups/backup_' + Time.now.strftime("%Y%m%d") + ".dump", "wb") do |file|
		file.write open(response.body).read
	end

	# Get backups list
	response = RestClient.get 'https://www.autobus.io/api/snapshots', {params: {"token": "804f1114551852d6bdac04264c5b66a2d44dd1ed48fe1184"}}
	snapshots = []
	JSON.parse(response.body).collect{|x| snapshots << JSON.parse('{"' + x['id'] + '":"' + x['url'] + '"}') }
	
	# 1..size - skip first backup listed, which is the latest, then cleans the other (old) ones...
	begin
		[1..snapshots.size].each do |i|
			snapshot_id = snapshots[i][0].keys[0]
			print "Deleting old backup: " + snapshot_id + " ... "

			result = RestClient.delete 'https://www.autobus.io/api/snapshots/' + snapshot_id, {params: {"token": "804f1114551852d6bdac04264c5b66a2d44dd1ed48fe1184"}}
			puts result.body
		end
	rescue
		puts "No old backups to purge"
	end
end
