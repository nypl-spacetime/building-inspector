class ApiController < ApplicationController

	def polygons
		per_page = 500
		page = 1
		if params[:page] != nil && params[:page] != ''
			page = params[:page].to_i
		end
		offset = per_page * (page-1)
		# returns all the polygons with their consensus value
		count = 0
		columns = "id, geometry, sheet_id, consensus, dn, centroid_lat, centroid_lon"
		if params[:flag_type] == nil
			count = Polygon.select("COUNT(id) as pcount").where("consensus IS NOT NULL").first.pcount
			poly = Polygon.select(columns).where("consensus IS NOT NULL").limit(per_page).offset(offset)
		elsif params[:flag_type] == "yes"
			count = Polygon.select("COUNT(id) as pcount").where("consensus = 'yes'").first.pcount
			poly = Polygon.select(columns).where("consensus = 'yes'").limit(per_page).offset(offset)
		elsif params[:flag_type] == "no"
			count = Polygon.select("COUNT(id) as pcount").where("consensus = 'no'").first.pcount
			poly = Polygon.select(columns).where("consensus = 'no'").limit(per_page).offset(offset)
		elsif params[:flag_type] == "fix"
			count = Polygon.select("COUNT(id) as pcount").where("consensus = 'fix'").first.pcount
			poly = Polygon.select(columns).where("consensus = 'fix'").limit(per_page).offset(offset)
		elsif params[:flag_type] == "all"
			count = Polygon.select("COUNT(id) as pcount").first.pcount
			poly = Polygon.select(columns).limit(per_page).offset(offset)
		end
		msg = "List for informative purposes only. This is not a definitive list. This URL may be changed at any time without prior notice."
	
		geojson = []
		poly.each do |p|
			geojson.push(p.to_geojson)
		end

		output = {}
		output[:message] = msg
		output[:polygon_count] = count
		output[:page] = page
		output[:per_page] = per_page
		output[:total_pages] = (count.to_f / per_page.to_f).ceil
		output[:type] = "FeatureCollection"
		output[:features] = geojson
		render json: output
	end

	def polygons_for_ids
		per_page = 500
		page = 1
		count = 0
		if params[:list] == nil
			output = {}
			output[:message] = "Provide a list of ids"
			output[:polygon_count] = count
			output[:page] = page
			output[:per_page] = per_page
			output[:total_pages] = (count.to_f / per_page.to_f).ceil
			render json: output
			return
		end
		if params[:page] != nil && params[:page] != ''
			page = params[:page].to_i
		end
		offset = per_page * (page-1)
		# returns all the polygons with their consensus value
		columns = "id, geometry, sheet_id, consensus, dn, centroid_lat, centroid_lon"
		ids = params[:list].split(",").map {|id| id.to_i}
		if ids.count > 0
			count = Polygon.select("COUNT(id) as pcount").where("id IN (?)", ids).first.pcount
			poly = Polygon.select(columns).where("id IN (?)", ids).offset(offset)
		end
		msg = "List for informative purposes only. This is not a definitive list. This URL may be changed at any time without prior notice."
	
		geojson = []

		if poly
			poly.each do |p|
				geojson.push(p.to_geojson)
			end
		end

		output = {}
		output[:message] = msg
		output[:polygon_count] = count
		output[:page] = page
		output[:per_page] = per_page
		output[:total_pages] = (count.to_f / per_page.to_f).ceil
		output[:type] = "FeatureCollection"
		output[:features] = geojson
		render json: output
	end

end
