#!/usr/bin/python
import sys, getopt, subprocess, os, datetime, ogr, re, json

def main(argv):
	instructions = 'Usage: %s <input directory>' % sys.argv[0]
	inputfile = ''
	try:
		opts, args = getopt.getopt(argv,"hi:o:",["ifile=","ofile="])
	except getopt.GetoptError:
		print instructions
		sys.exit(2)
	for opt, arg in opts:
		if opt == '-h':
			print instructions
			sys.exit()
		elif opt in ("-i"):
			inputfile = arg

	if len(argv) == 1:
		inputfile = argv[0]

	if inputfile == '':
		print instructions
		sys.exit(2)

	inputfile = argv[0]

	print ""
	print ""
	print ""
	print ""
	print ""
	print "NYPL Labs Map Ingest Config Creator v0.2"
	print "========================================"
	print "By: Mauricio Giraldo Arteaga @mgiraldo / @nypl_labs"
	print ""

	config_list = []

	for ff in os.listdir(inputfile):
		if ff.endswith(".tif"):
			base_name = ff[:ff.find(".tif")]

			# get geotiff data
			geoText = subprocess.Popen(["gdalinfo", inputfile + "/" + ff], stdout=subprocess.PIPE).communicate()[0]
			pattern = re.compile(r"Upper Left\s*\(\s*([0-9\-\.]*),\s*([0-9\-\.]*).*\n.*\n.*\nLower Right\s*\(\s*([0-9\-\.]*),\s*([0-9\-\.]*).*")
			geoMatch = pattern.findall(geoText)
			# print pattern
			print "\n"
			print "Geodata obtained:"
			print "-----------------"
			print "W", geoMatch[0][0]
			print "N", geoMatch[0][1]
			print "E", geoMatch[0][2]
			print "S", geoMatch[0][3]
			print "\n"

			W = geoMatch[0][0]
			N = geoMatch[0][1]
			E = geoMatch[0][2]
			S = geoMatch[0][3]

			this_config = {}
			this_config['id'] = base_name
			this_config['bbox'] = [float(W), float(S), float(E), float(N)]
			config_list.append(this_config)

	# NOTE: assumes input of folder WITH NO TRAILING SLASHES
	config_data = {
	    "description":"ADD_A_DESCRIPTION",
	    "name":"ADD_A_NAME",
	    "year":"ADD_A_YEAR(S)",
	    "bbox": [-180, 90, 180, 90], # [W,S,E,N]
	    "tilejson":"URL_FOR_TILEJSON_SPEC",
	    "tileset_type":"tms_or_wmts",
	    "sheets":config_list
	}
	config_file = open("config-ingest-layer" + (inputfile[inputfile.rfind("/")+1:]) + ".json", "w")
	config_file.write(json.dumps(config_data, indent=4))
	config_file.close()

if __name__ == "__main__":
	main(sys.argv[1:])


