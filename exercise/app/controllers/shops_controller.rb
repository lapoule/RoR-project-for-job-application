class ShopsController < ApplicationController
	def index
		@shops = Shop.all
	end

	def show
		@shop = Shop.find(params[:id])
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


	private
	def shop_parameters
	#Let's consider we need all data for a valid shop
		params.require(:shop).permit(:chain, :name, :latitude, :longitude, :address, :city, :zip, :phone, :country_code)
	end

end
