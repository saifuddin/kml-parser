# KML Data Extractor

## Overview
This script extracts data from a KML file and determines which region each set of coordinates belongs to. It supports spatial analysis using the `rgeo` gem to check if points fall within predefined regional boundaries.

## Features
- Parses KML files and extracts relevant data fields.
- Uses geospatial calculations to determine if coordinates belong to:
  - **Parlimen Cheras**
  - **Bandar Tun Razak**
  - **Parlimen Seputeh** (default if outside both regions)
- Outputs results into a structured CSV file for further analysis.

## Usage
1. **Install Dependencies:**
   ```sh
   gem install ruby_kml nokogiri rgeo awesome_print csv
   ```
2. **Run the script:**
   ```sh
   ruby script.rb
   ```
3. **Output:** The extracted data is saved as `placemarks_data.csv`.

## Important Note
🚨 **DO NOT COMMIT KML FILES TO THIS REPOSITORY** 🚨

The KML files contain **confidential data** and should never be included in version control. Ensure they are securely stored and accessed only by authorized users.

## License

This project is licensed under the MIT License.

```
MIT License

Copyright (c) 2025

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## Contributions
Contributions are welcome! Feel free to fork this repository and submit a pull request.

## Contact
For any issues or questions, please open an issue or reach out to the maintainers.

