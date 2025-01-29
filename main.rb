require 'ruby_kml'
require 'nokogiri'
require 'rgeo'
require 'byebug'
require 'awesome_print'
require 'csv'

f = File.open("default.kml")
kmldoc = Nokogiri::XML(f)

# Initialize RGeo factory for spatial calculations (WGS 84 - GPS standard)
factory = RGeo::Geographic.spherical_factory(srid: 4326)

# Function to convert polygon coordinates into an RGeo polygon
def create_polygon(factory, coordinates)
  return nil if coordinates.empty?

  ring = factory.linear_ring(coordinates.map { |lng, lat| factory.point(lng, lat) })
  factory.polygon(ring)
end

# Function to extract coordinates from a given Folder name
def extract_region_coordinates(kmldoc, folder_name)
  folder = kmldoc.css("Folder").find { |f| f.at_css("name")&.text == folder_name }
  
  if folder
    coordinates_array = folder.css("Placemark coordinates").map do |coordinates_node|
      coordinates_node.text.scan(/-?\d+\.\d+,-?\d+\.\d+/).map do |pair|
        pair.split(',').map(&:to_f) # Convert ["101.7472052", "3.0782611"] -> [101.7472052, 3.0782611]
      end
    end.flatten(1) # Flatten to ensure a single 2D array

    return coordinates_array
  else
    return []
  end
end

# Extract coordinates for "Parlimen Cheras" and "Bandar Tun Razak"
parlimen_cheras_coords = extract_region_coordinates(kmldoc, "Parlimen Cheras")
bandar_tun_razak_coords = extract_region_coordinates(kmldoc, "Bandar Tun Razak")

# Create RGeo polygons
parlimen_cheras_polygon = create_polygon(factory, parlimen_cheras_coords)
bandar_tun_razak_polygon = create_polygon(factory, bandar_tun_razak_coords)

# Find the Folder with the name "TB 2024"
tb_folder = kmldoc.css("Folder").find { |folder| folder.at_css("name")&.text == "TB 2024" }

placemarks_data = []
column_headers = ["Nama", "Hasil Rawatan", "Sub Diagnosis (eNotifikasi)", "Kategori Kes Tibi", "Latitude", "Longitude", "Recode Parlimen", "Mukim (alamat enotis)"]

if tb_folder
  placemarks_data = tb_folder.css("Placemark").map do |placemark|
    extended_data = {}

    # Extract ExtendedData fields
    placemark.css("ExtendedData Data").each do |data|
      name = data["name"]
      value = data.at_css("value")&.text
      extended_data[name] = value
    end

    # Extract coordinates for this placemark
    latitude = extended_data["Latitude"]&.to_f
    longitude = extended_data["Longitude"]&.to_f
    point = factory.point(longitude, latitude) # Convert to RGeo point

    # Determine region using RGeo
    region = if parlimen_cheras_polygon&.contains?(point)
               "Parlimen Cheras"
             elsif bandar_tun_razak_polygon&.contains?(point)
               "Bandar Tun Razak"
             else
               "Parlimen Seputeh" # Default if outside both
             end

    # Replace "Recode Parlimen" with the identified region
    [
      extended_data["Nama"],
      extended_data["Hasil Rawatan"],
      extended_data["Sub Diagnosis (eNotifikasi)"],
      extended_data["Kategori Kes Tibi"],
      extended_data["Latitude"],
      extended_data["Longitude"],
      region,  # <-- Region assigned here
      extended_data["Mukim (alamat enotis)"]
    ]
  end

  # Output CSV file
  csv_filename = "placemarks_data.csv"
  CSV.open(csv_filename, "w", write_headers: true, headers: column_headers) do |csv|
    placemarks_data.each do |row|
      csv << row
    end
  end

  puts "CSV file '#{csv_filename}' has been successfully created."
else
  puts "Folder 'TB 2024' not found."
end
