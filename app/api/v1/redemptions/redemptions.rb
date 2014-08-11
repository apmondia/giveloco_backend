class V1::Redemptions::Redemptions < V1::Base
	include V1::Defaults

	resource :redemptions do

	    desc "Return list of redemptions"
	    get do
			@redemptions = Redemption.all
			present @redemptions, with: V1::Redemptions::Entities
	    end

	    desc "Return a single redemptions"
	    get ':id' do
			@redemption = Redemption.find(params[:id])
			present @redemption, with: V1::Redemptions::Entities
		end

		desc "Create a new redemptions"
		post do
			@redemption = Redemption.new
			@redemption.first_name = params[:first_name] if params[:first_name]
			@redemption.last_name = params[:last_name] if params[:last_name]
			@redemption.save 

			status 201
			present @redemption, with: V1::Entities::Redemptions
		end

		desc "Update a single redemptions"
		put ':id' do
			@redemption = Redemption.find(params[:id])
			@redemption.first_name = params[:first_name] if params[:first_name]
			@redemption.last_name = params[:last_name] if params[:last_name]
			@redemption.save

			present @redemption, with: V1::Entities::Redemptions
		end

		desc "Delete a single redemptions"
		delete ':id' do
			Redemption.destroy(params[:id])
		end
	end

end # End Class