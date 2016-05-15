desc "Imports all shops given in shops_shopmium.csv"
task import_shops: :environment do
	require 'csv'
	CSV.foreach("../shops_shopmium.csv", :headers => true) do |row|
		Shop.create!(chain: row["chain"], name: row[" name"], latitude: row[" latitude"].to_f.round(6), longitude: row[" longitude"].to_f.round(6), address: row[" address"], city: row[" city"], zip: row[" zip"], phone: row[" phone"], country_code: row[" country_code"])
	end
end
