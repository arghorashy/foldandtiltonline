class FoldAndTiltController < ApplicationController
	def home

	end

	def getUniqueFilename
		time = Time.new

		return "#{time.strftime("%Y%m%d%H%M%S")}-#{rand(1000)}.jpeg"
	end

	def uploadPicture
		params[:status] = "ok"

		# Has picture been chosen
		if (! params.has_key?(:picture))
			params[:status] = "picnotchosen"
			render 'fold_and_tilt/home'
		else 

			uploaded_io = params[:picture]

			# Is picture JPEG
			if (File.extname(uploaded_io.original_filename) != ".jpg" && File.extname(uploaded_io.original_filename) != ".jpeg")
				params[:status] = "picnotjpeg"
				render 'fold_and_tilt/home'

			# Alright, all good. go ahead!
			else
				uniqueName = getUniqueFilename()
				
				# Save picture
				File.open(Rails.root.join('public', 'uploads', uniqueName), 'wb') do |file|
					file.write(uploaded_io.read)
				end

				# Path to picture for view
				params[:pname] = "/uploads/#{uniqueName}"
				
				render 'fold_and_tilt/home'

			end
		end
	end

	def about
	end
end
