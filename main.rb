require 'ruby_kml'

def parse_kml(file_path)
  # Read the KML file using ruby_kml
  kml = KML.parse(File.read(file_path))

  # Extract placemarks
  kml.features.each do |feature|
    if feature.is_a?(KML::Placemark)
      name = feature.name
      coordinates = feature.geometry.coordinates

      puts "Name: #{name}"
      puts "Coordinates: #{coordinates}"
    end
  end
end

# Example usage
kml_file_path = ARGV.length == 1 ? ARGV[0] : 'default.kml'

parse_kml(kml_file_path)
