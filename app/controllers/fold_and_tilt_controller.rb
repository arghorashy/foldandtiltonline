class FoldAndTiltController < ApplicationController
	def home

	end

	def getUniqueFilename
		time = Time.new

		return "#{time.strftime("%Y%m%d%H%M%S")}-#{rand(1000)}.jpeg"
	end

	def uploadPicture

		uploaded_io = params[:picture]
		if (File.extname(uploaded_io.original_filename) != ".jpg" && File.extname(uploaded_io.original_filename) != ".jpeg")
			params[:jpeg] = false
			render 'fold_and_tilt/home'

		else
			uniqueName = getUniqueFilename()
			

			
			File.open(Rails.root.join('public', 'uploads', uniqueName), 'wb') do |file|
				file.write(uploaded_io.read)
			end

			params[:pname] = "/uploads/#{uniqueName}"

			params[:jpeg] = true
			render 'fold_and_tilt/home'

		end
	end

	def about
	end
end
