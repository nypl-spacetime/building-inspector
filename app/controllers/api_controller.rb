class ApiController < ApplicationController

	def polygons
		per_page = 500
		page = 1
		if params[:page] != nil && params[:page] != ''
			page = params[:page].to_i
		end
		type = params[:task]
		consensus = params[:consensus]
		offset = per_page * (page-1)
		# returns all the polygons with their consensus value
		count = 0
		columns = "polygons.id, geometry, sheet_id, CP.consensus, dn, centroid_lat, centroid_lon"
		join = " LEFT JOIN consensuspolygons AS CP ON CP.polygon_id = polygons.id"
		where = "1=1"

		if consensus != nil
			where = "CP.task = "+Polygon.sanitize(type)+" AND CP.consensus = "+Polygon.sanitize(consensus)
		else
			where = "CP.task = "+Polygon.sanitize(type)
		end

		count = Polygon.select("COUNT(polygons.id) as pcount").joins(join).where(where).first.pcount
		poly = Polygon.select(columns).joins(join).where(where).limit(per_page).offset(offset)

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

	def consolidated
		per_page = 500
		page = 1
		if params[:page] != nil && params[:page] != ''
			page = params[:page].to_i
		end
		offset = per_page * (page-1)
		# returns all the polygons with their consensus value
		count = 0

		count = Polygon.select("COUNT(polygons.id) AS pcount").joins(:consensuspolygons).where("consensuspolygons.task=? AND consensuspolygons.consensus=?","geometry","yes").first.pcount

		per_page = count if params[:brett]

		poly = Polygon.select("*, (SELECT consensus FROM consensuspolygons _C WHERE _C.polygon_id=polygons.id AND _C.task='color') AS color").joins(:consensuspolygons).where("consensuspolygons.task=? AND consensuspolygons.consensus=?","geometry","yes").offset(offset).limit(per_page)

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
			respond_with("no comma-separated list of ids provided")
			return
		end
		if params[:page] != nil && params[:page] != ''
			page = params[:page].to_i
		end
		offset = per_page * (page-1)
		# returns all the polygons with their consensus value
		columns = "id, geometry, sheet_id, dn, centroid_lat, centroid_lon"
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
