module V1
	module Users
		class Entities < Grape::Entity
			expose :id, :documentation => {:type => "integer", :desc => "The numeric id of the user"}
			expose :role, :documentation => {:type => "string", :desc => "The user's type"}
			expose :email, :documentation => {:type => "string", :desc => "The email address of the user"}
			expose :first_name, :documentation => {:type => "string", :desc => "The user's First Name"}
			expose :last_name, :documentation => {:type => "string", :desc => "The user's Last Name"}
			expose :company_name, :documentation => {:type => "string", :desc => "The user's Business or Cause Name"}
			expose :street_address, :documentation => {:type => "string", :desc => "The user's Address"}
			expose :city, :documentation => {:type => "string", :desc => "The user's City"}
			expose :state, :documentation => {:type => "string", :desc => "The user's State"}
			expose :country, :documentation => {:type => "string", :desc => "The user's Country"}
			expose :zip, :documentation => {:type => "string", :desc => "The user's Zip / Postal Code"}
			expose :tags, :documentation => {:type => "text", :desc => "Tags describing the business/cause's field of operation"}
			expose :summary, :documentation => {:type => "text", :desc => "A tweet-length summary description of the business/cause"}
			expose :description, :documentation => {:type => "text", :desc => "A long form description of the business/cause"}
			expose :website, :documentation => {:type => "string", :desc => "The business / cause's website"}
			expose :balance, :documentation => {:type => "decimal", :desc => "The user's current credit balance"}
			expose :total_debits, :documentation => {:type => "integer", :desc => "The user's total debit transactions"}
			expose :total_debits_value, :documentation => {:type => "decimal", :desc => "The total value of the user's debit transactions"}
			expose :total_credits, :documentation => {:type => "integer", :desc => "The user's total debit transactions"}
			expose :total_credits_value, :documentation => {:type => "decimal", :desc => "The total value of the user's credit transactions"}
			expose :is_featured, :documentation => {:type => "boolean", :desc => "Determines if the organization is featured on the homepage"}
			expose :supporters, :documentation => {:type => "integer", :desc => "A list of user IDs that have supported a cause"}
			expose :supported_causes, :documentation => {:type => "integer", :desc => "A list of user IDs that a business has supported"}
			expose :transactions_created, :using => Transactions::Entities, :documentation => {:type => "object", :desc => "This is a list of transactions CREATED by this user."}
			expose :transactions_accepted, :using => Transactions::Entities, :documentation => {:type => "object", :desc => "This is a list of transactions ACCEPTED by this user."}
			expose :vouchers_issued, :using => Vouchers::Entities, :documentation => {:type => "integer", :desc => "A list of voucher IDs claimed by a user"}
			expose :vouchers_claimed, :using => Vouchers::Entities, :documentation => {:type => "integer", :desc => "A list of voucher IDs claimed by a user"}
			expose :redemptions, :using => Redemptions::Entities, :documentation => {:type => "integer", :desc => "A list of the user's redeemed vouchers"}
			expose :created_at, :documentation => {:type => "datetime", :desc => "The date and time when the user was created"}
			expose :updated_at, :documentation => {:type => "datetime", :desc => "The date and time when the user was last updated"}
			expose :last_sign_in_at, :documentation => {:type => "datetime", :desc => "The date and time when the user last signed in"}
			expose :deleted_at, :documentation => {:type => "datetime", :desc => "The date and time when the user deleted his/her account"}
		end
	end
end

# Ex.Entities: https://github.com/bloudraak/grape-sample-blog-api-with-entities/blob/master/app/api/blog/entities.rb