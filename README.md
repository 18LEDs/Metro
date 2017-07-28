#Metro
----------
### An API integration with metrotransit.org to display the next vehicle arrival given a transit route, transit stop, and desired direction.

### aka GRE NVR-B-L8

### Prerequisites

----------
Ruby 2+


### Assumptions

----------
User has Valid Transit Route and Transit Stop names


### Usage

----------

This script will accept 3 arguments from command line in the following order: transit route, transit stop, and desired direction.  These arguments should be wrapped in double quotes

**Example**:  ruby metro.rb "5 - Brklyn Center - Fremont - 26th Av - Chicago - MOA" "7th St  and Olson Memorial Hwy" "south"

If the script is invoked without arguments, a User Guided experience launches.  This will accept the inputs with or without quotes.


