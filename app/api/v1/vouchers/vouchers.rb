class V1::Vouchers::Vouchers < V1::Base
	include V1::Defaults

	resource :vouchers do

	    desc "Return list of vouchers"
	    get do
			@vouchers = Voucher.all
			present @vouchers, with: V1::Vouchers::Entities
	    end

	    desc "Return a single voucher"
	    get ':id' do
			@voucher = Voucher.find(params[:id])
			present @voucher, with: V1::Vouchers::Entities
		end

		desc "Create a new voucher"
		post do
			@voucher = Voucher.new
			@voucher.issued_by = params[:issued_by] if params[:issued_by]
			@voucher.claimed_by = params[:claimed_by] if params[:claimed_by]
			@voucher.issued_by_name = params[:issued_by_name] if params[:issued_by_name]
			@voucher.claimed_by_name = params[:claimed_by_name] if params[:claimed_by_name]
			@voucher.max_value = params[:max_value] if params[:max_value]
			@voucher.redeemed = params[:redeemed] if params[:redeemed]
			@voucher.save 

			status 201
			present @voucher, with: V1::Entities::Vouchers
		end

		desc "Update a single voucher"
		put ':id' do
			@voucher = Voucher.find(params[:id])
			@voucher.redeemed = params[:redeemed] if params[:redeemed]
			@voucher.save

			present @voucher, with: V1::Entities::Vouchers
		end

		# desc "Delete a single voucher"
		# delete ':id' do
		# 	Voucher.destroy(params[:id])
		# end
	end

end # End Class