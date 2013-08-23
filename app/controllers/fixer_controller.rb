class FixerController < ApplicationController
	def building
	end

	def randomMap
		@map = Sheet.random
		@map[:poly] = @map.mini
		respond_to do |format|
			format.json { render json: @map }
		end
	end

	def color
	end
end
