module V1
  module BusinessReports
    class BusinessReportEntity < Grape::Entity

      expose :id
      expose :certificates_count
      expose :sales_total
      expose :donation_total

    end

  end
end