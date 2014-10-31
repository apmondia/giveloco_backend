class V1::Base < API::Root
	mount V1::Connections::ConnectionsController
	mount V1::Tags::TagsController
	mount V1::Transactions::TransactionsController
	mount V1::Users::UsersController
  mount V1::Sponsorships::SponsorshipsController
end