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
				@display = "near"
				if Rails.env.development? || Rails.env.test?
					@loc = Geocoder.search("89.170.91.235").first
				else
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
		#When the form initializes, there's no error
		@error = []
	end

	def edit
	#Same thing as new after updating
		@shop = Shop.find(params[:id])
		@error = []
	end

	def create
		@shop = Shop.new(shop_parameters)
		if @shop.save
			redirect_to @shop#index
		else
			#Associate each field with its error
			@attributes = [:chain, :name, :latitude, :longitude, :address, :city, :zip, :phone, :country_code]
			@error = []
			@attributes.reverse.each do |att|
				if @shop.errors[att].first.nil?
					@error.push("") #Nothing to display, but we want to keep the order
				else
					@error.push("Error: " + att.to_s + " " + @shop.errors[att].first + "!")
				end
			end
			render 'new'
		end
	end

	def update
		@shop = Shop.find(params[:id])
		if @shop.update(shop_parameters)
			redirect_to @shop
		else
			@attributes = [:chain, :name, :latitude, :longitude, :address, :city, :zip, :phone, :country_code]
			@error = []
			@attributes.reverse.each do |att|
				if @shop.errors[att].first.nil?
					@error.push("")
				else
					@error.push("Error: " + att.to_s + " " + @shop.errors[att].first + "!")
				end
			end
			render 'edit'
		end
	end

	def destroy
		@shop = Shop.find(params[:id])
		@shop.destroy
		redirect_to @shop#index
	end

	private
	def shop_parameters
	#Let's consider we need all data for a valid shop
		params.require(:shop).permit(:chain, :name, :latitude, :longitude, :address, :city, :zip, :phone, :country_code)
	end

end
