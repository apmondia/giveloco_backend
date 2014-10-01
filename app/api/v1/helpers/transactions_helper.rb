module V1::Helpers::TransactionsHelper
# =======================================================================
# 	Determines which type of currency is used
# =======================================================================
	def currencyRegion(uid)
		u = User.find(uid)
		if u.country == "CA"
			return "cad"
		else
			return "usd"
		end
	end

end