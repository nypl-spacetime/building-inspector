class VisualizerController < ApplicationController
	
	respond_to :json

	def sheet_flags_json
		if params[:id] == nil
			respond_with( "no sheet id specified" )
			return
		end
		sheet = Sheet.find(params[:id])
		@output = {}
		@output[:sheet] = sheet
		@output[:polygons] = sheet.mini
		@output[:flags] = sheet.flags
		respond_with(@output)
	end

	def sheet_flags_view
		@sheets = Sheet.all
	end

end