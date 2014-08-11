class V1::Base < API::Root
	mount V1::Users::Users
	mount V1::Transactions::Transactions
	mount V1::Vouchers::Vouchers
	mount V1::Redemptions::Redemptions
end