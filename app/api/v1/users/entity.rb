module V1
	module Users
		class Entity < Grape::Entity

			expose :id, :documentation => {:type => "integer", :desc => "The numeric id of the user"}
			expose :role, :documentation => {:type => "string", :desc => "The user's type"}

			with_options(if: {:type => 'authorized'}) do
				expose :email, :documentation => {:type => "string", :desc => "The email address of the user"}
				expose :first_name, :documentation => {:type => "string", :desc => "The user's First Name"}
				expose :last_name, :documentation => {:type => "string", :desc => "The user's Last Name"}
			end

			expose :images do
				expose :profile_picture do
					expose :original,  :documentation => {:type => "attachment", :desc => "The URL for the user's profile picture"}
					expose :medium,  :documentation => {:type => "attachment", :desc => "The URL for the user's profile picture"}
					expose :thumb,  :documentation => {:type => "attachment", :desc => "The URL for the user's profile picture"}
				end
			end

      expose :publishable_key
			expose :phone, :documentation => {:type => "string", :desc => "The phone number for the business or cause"}
			expose :company_name, :documentation => {:type => "string", :desc => "The user's Business or Cause Name"}
			expose :street_address, :documentation => {:type => "string", :desc => "The user's Address"}
			expose :city, :documentation => {:type => "string", :desc => "The user's City"}
			expose :state, :documentation => {:type => "string", :desc => "The user's State"}
			expose :country, :documentation => {:type => "string", :desc => "The user's Country"}
			expose :zip, :documentation => {:type => "string", :desc => "The user's Zip / Postal Code"}
			expose :tag_list, :as => :tags, :documentation => {:type => "text", :desc => "Tags describing the business/cause's field of operation"}
			expose :summary, :documentation => {:type => "text", :desc => "A tweet-length summary description of the business/cause"}
			expose :description, :documentation => {:type => "text", :desc => "A long form description of the business/cause"}
			expose :website, :documentation => {:type => "string", :desc => "The business / cause's website"}

			expose :has_stripe_connect
			expose :stripe_user_omniauth_authorize_path

			expose :sponsors, :using => V1::Sponsorships::Snapshot, :documentation => {:type => "object", :desc => "A list of business IDs that have sponsored a cause"}, if: lambda { |user, options| user.role == :cause }
			expose :sponsorships, :using => V1::Sponsorships::Snapshot, :documentation => {:type => "object", :desc => "A list of cause IDs that a business has sponsored"}, if: lambda { |user, options| user.role == :business }

			with_options(if: {:type => 'authorized'}) do
				expose :customer_id, :documentation => {:type => "string", :desc => "The user's Stripe customer ID."}
				expose :balance, :documentation => {:type => "decimal", :desc => "The user's current credit balance"}
				expose :total_funds_raised, :documentation => {:type => "decimal", :desc => "The total value of donations received by a cause"}, if: lambda { |user, options| user.role == :cause }
				expose :authentication_token, :as => :auth_token, :documentation => {:type => "string", :desc => "The user's current authentication token"}
			end

			expose :is_activated, :documentation => {:type => "boolean", :desc => "Determines if the organization is visible to the public"}
			expose :is_published, :documentation => {:type => "boolean", :desc => "Determines if the organization is visible to the public"}
			expose :is_featured, :documentation => {:type => "boolean", :desc => "Determines if the organization is featured on the homepage"}

			expose :created_at, :documentation => {:type => "datetime", :desc => "The date and time when the user was created"}
			expose :updated_at, :documentation => {:type => "datetime", :desc => "The date and time when the user was last updated"}
			expose :confirmed_at, :documentation => {:type => "datetime", :desc => "The date and time when the user's account registration was confirmed'"}
			expose :last_sign_in_at, :documentation => {:type => "datetime", :desc => "The date and time when the user last signed in"}
			expose :deleted_at, :documentation => {:type => "datetime", :desc => "The date and time when the user deleted his/her account"}

    end

  end
end

# Ex.Entities: https://github.com/bloudraak/grape-sample-blog-api-with-entities/blob/master/app/api/blog/entity.rb