class V1::Tags::TagsController < V1::Base
	include V1::Defaults

	resource :tags do

	    desc "Return list of tags"
	    get do
			@tags = User.tag_counts_on(:tags)
			present @tags
			# present @tags, with: V1::Tags::Entities
	    end

	    desc "Return a single tag"
	    get ':id' do
			@tag = User.tag_counts_on(:tags).find(params[:id])
			present @tag
		end

		desc "Delete a single tag"
		delete ':id' do
			@tag = User.tag_counts_on(:tags).find(params[:id])
			@tag.destroy
		end
	end

end # End Class