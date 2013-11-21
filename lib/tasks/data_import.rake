namespace :data_import do

	desc "Import a polygon GeoJSON for a sheet file"
	task :ingest_geojson => :environment do
		id = ENV['id']
		layer_id = ENV['layer_id']
		bbox = ENV['bbox'] # W,S,E,N

		if ENV['force']==nil
			abort "This process was not forced (required due to destructive nature)"
		end

		process_file(id, bbox, layer_id)
	end

	desc "Import GeoJSON sheet files based on config file"
	task :ingest_bulk => :environment do
		if ENV['force']==nil
			abort "This process was not forced (required due to destructive nature)"
		end

		if ENV['id']==nil
			abort "You need to specify a layer id"
		end

		id = ENV['id']

		file = "public/files/config-ingest-layer#{id}.json"

		if not File.exists?(file)
			abort "Config file #{file} not found."
		end
		
		str = IO.read(file)
		json = JSON.parse(str)
		
		if json.count == 0
			abort "Config #{file} has no sheets."
		end
		
		json.each do |f|
			process_file(f["id"].to_i, f["bbox"].join(","), id)
		end
	end

	desc "Import GeoJSON centroid sheet files based on config file"
	task :ingest_centroid_bulk => :environment do
		if ENV['force']==nil
			abort "This process was not forced (required due to destructive nature)"
		end

		if ENV['id']==nil
			abort "You need to specify a layer id"
		end

		id = ENV['id']

		file = "public/files/config-ingest-layer#{id}.json"

		if not File.exists?(file)
			abort "Config file #{file} not found."
		end
		
		str = IO.read(file)
		json = JSON.parse(str)
		
		if json.count == 0
			abort "Config #{file} has no sheets."
		end
		
		json.each do |f|
			process_centroids(f["id"].to_i)
		end
	end

end

def process_file(id, bbox, layer_id)
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

	sheet = Sheet.new(:map_id => id, :bbox => bbox, :status => "unprocessed", :layer_id => layer_id)
	sheet.save

	json["features"].each do |f|
		polygon = Polygon.new()
		polygon[:sheet_id] = sheet.id
		polygon[:status] = "unprocessed"
		polygon[:vectorizer_json] = f.to_json
		polygon[:color] = f['properties']['Color']
		polygon[:centroid_lat] = f['properties']['CentroidY']
		polygon[:centroid_lon] = f['properties']['CentroidX']
		polygon[:geometry] = f['geometry']['coordinates'].to_json
		polygon[:dn] = f['properties']['DN']
		polygon.save
	end
end

def process_centroids(id)
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

	nilcentroids = 0
	json["features"].each do |f|
		polygon = Polygon.where("dn = ? and sheets.map_id = ?", f['properties']['DN'], id).joins(:sheet).readonly(false)
		if polygon
			if polygon.count > 1
				puts "Polygon #{f['properties']['DN']} in sheet #{id} has twin sibling."
				next
			end
			p = polygon.first
			if f['geometry']['coordinates'] != nil
				p[:centroid_lat] = f['geometry']['coordinates'][1].to_f
				p[:centroid_lon] = f['geometry']['coordinates'][0].to_f
			else
				nilcentroids = nilcentroids + 1
				geo = JSON.parse(p.geometry)
				point = geo[0][geo[0].count/2]
				p[:centroid_lat] = point[1]
				p[:centroid_lon] = point[0]
			end
			p.save
		end
	end
	puts "Found #{nilcentroids} nil centroids in #{id}." if nilcentroids > 0
end

