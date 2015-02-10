class CreateAdminReport < ActiveRecord::Migration
  def up
    self.connection.execute <<-SQL
      CREATE VIEW admin_reports AS
        SELECT
          1 as id,
          COUNT(business_reports.id) AS business_count,
          SUM(business_reports.certificates_count) AS certificates_count,
          SUM(business_reports.sales_total) AS sales_total,
          SUM(business_reports.donation_total) AS donation_total
        FROM business_reports;
    SQL
  end

  def down
    self.connection.execute <<-SQL
      DROP VIEW admin_reports;
    SQL
  end
end
