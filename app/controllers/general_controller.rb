class GeneralController < ApplicationController
  def home
  	@current_page = "homepage"
  end

  def about
  end

  def win
  	ids = Flag.select(:polygon_id).where(:flag_value => "yes").order("random()").limit(30).map { |p| p.polygon_id }
	pp = Polygon.where(:id => ids).map { |p| JSON.parse(p.vectorizer_json) }
	obj = {}
	obj[:type] = "FeatureCollection"
	obj[:features] = pp
	@json = obj.to_json
  end

end
