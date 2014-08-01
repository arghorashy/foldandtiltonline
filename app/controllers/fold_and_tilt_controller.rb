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
				pFname = Rails.root.join('public', 'uploads', uniqueName)
				File.open(pFname, 'wb') do |file|
					file.write(uploaded_io.read)
				end

				# Warp picture minus
				pminusFname = File.join( File.dirname(pFname), "#{File.basename(pFname, ".*")}-minus.jpg" )
				pplusFname = File.join( File.dirname(pFname), "#{File.basename(pFname, ".*")}-plus.jpg" )
				#params[:errors] = "cd bin/foldandtilt; ./FoldnTilt #{pFname} #{pminusFname} -100"
				IO.popen("cd bin/foldandtilt; ./FoldnTilt #{pFname} #{pminusFname} -100 false") do |result| 
					params[:errors] = result.gets
				end
				IO.popen("cd bin/foldandtilt; ./FoldnTilt #{pFname} #{pplusFname} 100 false") do |result| 
					params[:errors] = result.gets
				end
				

				# Path to picture for view
				params[:pname] = "/uploads/#{uniqueName}"
				params[:pminusname] = "/uploads/#{File.basename(pminusFname)}"
				params[:pplusname] = "/uploads/#{File.basename(pplusFname)}"

				render 'fold_and_tilt/home'

			end
		end
	end

	def about
	end
end
