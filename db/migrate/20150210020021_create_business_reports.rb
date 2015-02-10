class CreateBusinessReports < ActiveRecord::Migration
  def up
    self.connection.execute <<-SQL
      CREATE VIEW business_reports AS
        SELECT
          sponsorships.business_id as id,
          COUNT(certificates.id) AS certificates_count,
          SUM(certificates.amount) AS sales_total,
          SUM(certificates.amount * (certificates.donation_percentage/100.0) ) AS donation_total
        FROM certificates INNER JOIN sponsorships ON certificates.sponsorship_id = sponsorships.id
        GROUP BY sponsorships.business_id;
    SQL
  end

  def down
    self.connection.execute <<-SQL
      DROP VIEW business_reports;
    SQL
  end
end
