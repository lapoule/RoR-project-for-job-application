desc "Imports all shops given in shops_shopmium.csv"
task :import_shops do
	require 'csv'
	#Read the file from root directory
	data_to_read = File.read("../shops_shopmium.csv")
	#Parse all data contained into CSV file
	data = CSV.parse(data_to_read, :headers => true)
	#Just print it on terminal (for the moment...)
	print data
end
