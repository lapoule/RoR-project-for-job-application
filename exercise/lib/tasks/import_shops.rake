desc "Imports all shops given in shops_shopmium.csv"
task :import_shops do
	require 'csv'
	#Read the file from root directory
	#double quotes temporarily substituted into single quotes
	data_to_read = File.read("../shops_shopmium.csv").gsub('"', "'")
	#Parse all data contained into CSV file
	data = CSV.parse(data_to_read, :headers => true, :col_sep => '\t')
	#For each row, print the data it contains
	data.each do |row|
		print row
		STDOUT.flush
	end
end
