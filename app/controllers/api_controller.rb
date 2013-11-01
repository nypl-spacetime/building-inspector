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
		output = {}
		output[:message] = msg
		output[:polygon_count] = count
		output[:page] = page
		output[:polygons] = poly
		render json: output
	end

end
