class V1::BusinessReports::BusinessReportsController < V1::Base

  resource :business_reports do

    get do
      authenticate!
      can_or_die :index, BusinessReport
      present AdminReport.first, :with => V1::BusinessReports::AdminReportEntity
    end

    segment '/:id' do

      params do
        requires :id
      end
      get do
        authenticate!
        @report = BusinessReport.find(params[:id])
        can_or_die :read, @report
        present @report, :with => V1::BusinessReports::BusinessReportEntity
      end

    end

  end
end