class V1::Connections::ConnectionsController < V1::Base
	include V1::Defaults

	# before do
 #    	authenticate!
 #    end

	resource :connections do

	    desc "Return complete list of connections"
	    get do
			@connections = Connection.all
			present @connections, with: V1::Connections::Entities, type: 'list-view'
	    end

	# =======================================================================
	# 	Return lists of connections by transaction type
	# =======================================================================
	    desc "Return list of donation connections"
	    get 'type/donation' do
			@donations = Connection.where("trans_type = 'donation'")
			present @donations, with: V1::Connections::Entities
	    end

	    desc "Return list of pledge connections"
	    get 'type/pledge' do
			@pledges = Connection.where("trans_type = 'pledge'")
			present @pledges, with: V1::Connections::Entities
	    end

	    desc "Return list of redemption connections"
	    get 'type/redemption' do
			@redemptions = Connection.where("trans_type = 'redemption'")
			present @redemptions, with: V1::Connections::Entities
	    end


	# =======================================================================
	# 	Return single connection
	# =======================================================================
	    desc "Return a single connection"
	    get ':id' do
			@connection = Connection.find(params[:id])
			present @connection, with: V1::Connections::Entities
		end

	end

end # End Class