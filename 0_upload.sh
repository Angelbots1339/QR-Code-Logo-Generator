#!/usr/bin/env bash

# Check if creds.sh exists and is not empty
if [[ -f "creds.sh" && -s "creds.sh" ]]; then
	source creds.sh
else
	>&2 echo "Error: Configuration file 'creds.sh' not found or is empty."
	>&2 echo ''
	exit 1
fi

# Check if an argument was passed and if the file specified by ${1} exists and has a valid file extension
if [[ -n "${1}" && -f "${1}" && "${1}" =~ ^.*\.(png|svg|pdf|eps)$ ]]; then
	# Do something if an argument was passed and the file exists and has a valid file extension
	IMAGE_FILE="${1}"
else
	# Print an error message to stderr if no argument was passed or the file does not exist or has an invalid file extension
	>&2 echo "Error: Usage: $0 <uploadFile>"
	>&2 echo '<uploadFile> must be a file with a valid extension (png, svg, pdf, or eps).'
	>&2 echo ''
	exit 1
fi


# Functionize curl file upload 
function file_upload {
	curl -sF "file=@${IMAGE_FILE}" \
		--url https://qrcode-monkey.p.rapidapi.com/qr/uploadImage \
		-H 'X-RapidAPI-Host: qrcode-monkey.p.rapidapi.com' \
		-H "X-RapidAPI-Key: ${Rapid_API_Key}"
}

# Store curl file upload json response as ${RESPONSE}
RESPONSE=$(file_upload)


# Check if the jq command is available to pretty print the json output
if command -v jq > /dev/null; then
	# Use jq to pretty print and store the file name as ${SERVERSIDE_FILENAME}
	echo "${RESPONSE}" | jq '.'
	SERVERSIDE_FILENAME=$(echo "${RESPONSE}" | jq '.file')
else
	# Print an error message to stderr if jq is not available
	# Use grep and regular expressions to store the file name as ${SERVERSIDE_FILENAME}
	echo >&2 "Error: jq is not available. Please install jq if you want cleaner json output." >&2
	echo "${RESPONSE}"
	SERVERSIDE_FILENAME=$(echo "${RESPONSE}" | grep -Eo '[a-z0-9]+.[a-zA-Z]{3}')
fi

>&2 echo "You'll need to add `"${SERVERSIDE_FILENAME}"` to 1_qrcode_gen.sh"


