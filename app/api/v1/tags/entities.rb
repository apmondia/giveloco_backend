module V1
	module Tags
		class Entities < Grape::Entity
	    	expose :name, :documentation => {:type => "string", :desc => "The name of the tag"}
		end
	end
end