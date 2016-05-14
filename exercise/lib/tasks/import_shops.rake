desc "Imports all shops given in shops_shopmium.csv"
task :import_shops do
	require 'csv'
	data_to_read = File.read("../shops_shopmium.csv")
	data = CSV.parse(data_to_read, :headers => true)
	print data
end
