desc "Destroys all shops created in the application (not only the ones imported from CSV file"
task destroy_all_shops: :environment do
	Shop.delete_all
end
