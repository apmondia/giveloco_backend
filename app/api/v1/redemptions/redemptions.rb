class V1::Redemptions::Redemptions < V1::Base
	include V1::Defaults

	resource :redemptions do

	    desc "Return list of redemptions"
	    get do
			@redemptions = Redemption.all
			present @redemptions, with: V1::Redemptions::Entities
	    end

	    desc "Return a single redemption"
	    get ':id' do
			@redemption = Redemption.find(params[:id])
			present @redemption, with: V1::Redemptions::Entities
		end

		desc "Create a new redemption"
		post do
			@redemption = Redemption.new
			@redemption.voucher = params[:voucher] if params[:voucher]
			@redemption.vendor = params[:vendor] if params[:vendor]
			@redemption.redeemed_by = params[:redeemed_by] if params[:redeemed_by]
			@redemption.redeemer_name = params[:redeemer_name] if params[:redeemer_name]
			@redemption.vendor_name = params[:vendor_name] if params[:vendor_name]
			@redemption.value = params[:value] if params[:value]
			@redemption.save 

			status 201
			present @redemption, with: V1::Entities::Redemptions
		end

		# desc "Update a single redemption"
		# put ':id' do
		# 	@redemption = Redemption.find(params[:id])
		# 	@redemption.save

		# 	present @redemption, with: V1::Entities::Redemptions
		# end

		# desc "Delete a single redemption"
		# delete ':id' do
		# 	Redemption.destroy(params[:id])
		# end
	end

end # End Class