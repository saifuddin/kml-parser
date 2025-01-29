require 'nokogiri'
require 'byebug'
require 'ruby_kml'

def parse_kml(file_path)
  debugger
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
kml_file_path = ARGV.length == 1 ? ARGV[0] : 'default.kml'

parse_kml(kml_file_path)
