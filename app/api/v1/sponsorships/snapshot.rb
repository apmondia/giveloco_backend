module V1
  module Sponsorships
    class Snapshot < Grape::Entity
      expose :id
      expose :business_id
      expose :cause_id
      expose :status
    end
  end
end
