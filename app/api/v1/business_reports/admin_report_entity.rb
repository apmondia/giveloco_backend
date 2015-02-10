module V1
  module BusinessReports
    class AdminReportEntity < Grape::Entity

      expose :business_count
      expose :certificates_count
      expose :sales_total
      expose :donation_total

    end

  end
end