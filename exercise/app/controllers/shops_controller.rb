class ShopsController < ApplicationController

	def index
		
		#Default : display all shops
		if not (params[:length] || params[:number])
			@display = "all"
			@shops = Shop.all.order(zip: :asc)
		else
			#Display user's neighbourhood
			if params[:length]
				@display = "neighbourhood"
				#Display all shops in the user's neighbourhood
				#Look for the user location
				if Rails.env.development? || Rails.env.test?
					#To test location data on localhost, let's take a constant IP
					@loc = Geocoder.search("89.170.91.235").first
				else
					#Of course we won't do that in production
					@loc = Geocoder.search(request.remote_ip).first
				end
				@length = params[:length]
				@shops = Shop.near([@loc.data["latitude"], @loc.data["longitude"]], @length, :units => :km)
				#Sometimes it doesn't work perfectly since it returns shops more than [distance] kilometers away.
			else

				#Shows the nearest shops considering user's location
				#Look for the user location
				@display = "near"
				if Rails.env.development? || Rails.env.test?
					#To test location data on localhost, let's take a constant IP
					@loc = Geocoder.search("89.170.91.235").first
				else
					#Of course we won't do that in production
					@loc = Geocoder.search(request.remote_ip).first
				end
				
				@number = params[:number]
				#I assume this is not proper code but... didn't find how to do it better !
				@shops = Shop.near([@loc.data["latitude"], @loc.data["longitude"]], 999999).limit(@number)
			end
		end	
	end

	def show
		#Display information on the selected shop
		@shops = [Shop.find(params[:id])]
	end

	def new
	#Defined to keep information if the shop can't be saved
	#(wrong or missing data)
		@shop = Shop.new
	end

	def edit
	#Same thing as new after updating
		@shop = Shop.find(params[:id])
	end

	def create
		@shop = Shop.new(shop_parameters)
		if @shop.save
			redirect_to @shop#index
		else
			render 'new'
		end
	end

	def update
		@shop = Shop.find(params[:id])
		if @shop.update(shop_parameters)
			redirect_to @shop
		else
			render 'edit'
		end
	end

	def destroy
		@shop = Shop.find(params[:id])
		@shop.destroy
		redirect_to @shop#index
	end

	def show_nearest
	#Shows the 10 nearest shops considering user's location
		#Look for the user location
		if Rails.env.development? || Rails.env.test?
			#To test location data on localhost, let's take a constant IP
			@loc = Geocoder.search("89.170.91.235").first
		else
			#Of course we won't do that in production
			@loc = Geocoder.search(request.remote_ip).first
		end	
		@shops = Shop.all.order(distance: :asc).limit(10)
	end

	private
	def shop_parameters
	#Let's consider we need all data for a valid shop
		params.require(:shop).permit(:chain, :name, :latitude, :longitude, :address, :city, :zip, :phone, :country_code)
	end
end
