class UsersController < ApplicationController

	def user_params
		# Permitted fields that can have data values on form submission
		params.require(:user).premit()
	end

	def index
		@users = User.all
	end

	def show
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id]).update_attributes(user_params)
	end

	def destroy
		@user = User.find(params[:id])
		@user.destroy
	end

end
