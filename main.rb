require 'nokogiri'
require 'byebug'

 def parse_kml(file_path)
   # Read the KML file
   file = File.open(file_path)
   doc = Nokogiri::XML(file)
   file.close

   # Extract placemarks
   placemarks = doc.xpath('//Placemark')
   placemarks.each do |placemark|
     name = placemark.at_xpath('name')&.text
     coordinates = placemark.at_xpath('.//coordinates')&.text

     puts "Name: #{name}"
     puts "Coordinates: #{coordinates}"
   end
 end

 # Example usage
 if ARGV.length != 1
   puts "Usage: ruby main.rb <kml_file_path>"
   exit
 end

 parse_kml(ARGV[0])