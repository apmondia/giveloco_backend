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
			@voucher.first_name = params[:first_name] if params[:first_name]
			@voucher.last_name = params[:last_name] if params[:last_name]
			@voucher.save 

			status 201
			present @voucher, with: V1::Entities::Vouchers
		end

		desc "Update a single voucher"
		put ':id' do
			@voucher = Voucher.find(params[:id])
			@voucher.first_name = params[:first_name] if params[:first_name]
			@voucher.last_name = params[:last_name] if params[:last_name]
			@voucher.save

			present @voucher, with: V1::Entities::Vouchers
		end

		desc "Delete a single voucher"
		delete ':id' do
			Voucher.destroy(params[:id])
		end
	end

end # End Class