namespace :data_import do

	desc "Import a polygon GeoJSON for a sheet file"
	task :ingest_geojson => :environment do
		id = ENV['id']
		bbox = ENV['bbox']

		if ENV['force']==nil
			abort "This process was not forced (required due to destructive nature)"
		end

		process_file(id, bbox)
	end

	desc "Import GeoJSON sheet files based on config file"
	task :ingest_bulk => :environment do
		if ENV['force']==nil
			abort "This process was not forced (required due to destructive nature)"
		end

		file = "public/files/config-ingest.json"

		if not File.exists?(file)
			abort "Config file #{file} not found."
		end
		
		str = IO.read(file)
		json = JSON.parse(str)
		
		if json.count == 0
			abort "Config #{file} has no sheets."
		end
		
		json.each do |f|
			process_file(f["id"].to_i, f["bbox"].join(","))
		end
	end

	desc "Import GeoJSON centroid sheet files based on config file"
	task :ingest_centroid_bulk => :environment do
		if ENV['force']==nil
			abort "This process was not forced (required due to destructive nature)"
		end

		file = "public/files/config-ingest.json"

		if not File.exists?(file)
			abort "Config file #{file} not found."
		end
		
		str = IO.read(file)
		json = JSON.parse(str)
		
		if json.count == 0
			abort "Config #{file} has no sheets."
		end
		
		json.each do |f|
			process_centroid(f["id"].to_i)
		end
	end

end

def process_file(id, bbox)
	file = "public/files/#{id}-traced.json"

	if not File.exists?(file)
		puts "Sheet ID #{id} not found."
		return
	end
	
	str = IO.read(file)
	json = JSON.parse(str)
	
	if json["features"] == nil
		puts "Sheet ID #{id} has no features."
		return
	end
	
	# now we can create the sheet and polygons

	#first check if sheet exists
	sheet = Sheet.where(:map_id => id)

	if (sheet.count != 0)
		sheet.destroy_all
	end

	sheet = Sheet.new(:map_id => id, :bbox => bbox, :status => "unprocessed")
	sheet.save

	json["features"].each do |f|
		polygon = Polygon.new()
		polygon[:sheet_id] = sheet.id
		polygon[:status] = "unprocessed"
		polygon[:vectorizer_json] = f.to_json
		polygon[:color] = f['properties']['Color']
		polygon[:geometry] = f['geometry']['coordinates'].to_json
		polygon[:dn] = f['properties']['DN']
		polygon.save
	end
end

def process_centroid(id)
	file = "public/files/#{id}-centroid.json"

	if not File.exists?(file)
		puts "Sheet ID #{id} not found."
		return
	end
	
	str = IO.read(file)
	json = JSON.parse(str)
	
	if json["features"] == nil
		puts "Sheet ID #{id} has no features."
		return
	end
	
	# now we can update the sheet polygons

	#first check if sheet exists
	sheet = Sheet.where(:map_id => id)

	if (sheet == nil)
		puts "Sheet does not exist. Do a base ingest first."
		return
	end

	json["features"].each do |f|
		if f['geometry']['coordinates'] != nil
			polygon = Polygon.where(:dn => f['properties']['DN']).first
			if polygon
				polygon[:centroid_lat] = f['geometry']['coordinates'][1].to_f
				polygon[:centroid_lon] = f['geometry']['coordinates'][0].to_f
				polygon.save
			end
		end
	end
end