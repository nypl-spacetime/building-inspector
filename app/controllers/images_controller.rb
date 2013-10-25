class ImagesController < ApplicationController
	# GET /getimagedata/digitalid
	def getimagedata
		url = params[:url]
		im = Magick::Image.read(url).first
		# im.background_color = "none"
		# test for width (for HQ images)
		# if (im.columns > 800)
		# 	im = im.resize_to_fit(800)
		# end
		im = im.rotate(params[:r].to_f)
		str = Base64.encode64(im.to_blob{self.format = "PNG"})
		output = {
		"width" => im.columns,
		"height" => im.rows,
		"data" => "data:image\/png;base64," + str
		}
		#    http://images.nypl.org/index.php?id="+index+"&t=w
		respond_to do |format|
			format.json { render :json => "#{params[:callback]}(#{output.to_json});" }
			format.png { render :text => im.to_blob{self.format = "PNG"}, :status => 200, :type => 'image/png' }
		end
	end

	# GET /getpixels/digitalid
	def getpixels
		url = params[:url]
		im = Magick::Image.read(url).first
		# test for width (for HQ images)
		# if (im.columns > 800)
		# im = im.resize_to_fit(800)
		# end

		respond_to do |format|
			format.png { render :text => im.to_blob{self.format = "PNG"}, :status => 200, :type => 'image/png' }
		end
	end

end