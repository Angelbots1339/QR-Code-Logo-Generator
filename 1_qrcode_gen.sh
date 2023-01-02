#!/usr/bin/env bash

# Check if creds.sh exists and is not empty
if [[ -f "creds.sh" && -s "creds.sh" ]]; then
	source creds.sh
else
	>&2 echo "Error: Configuration file 'creds.sh' not found or is empty."
	>&2 echo ''
	exit 1
fi

# Check if ${1} is not empty and only contains characters that do not require URL encoding
if [[ -n $1 && $1 =~ [a-zA-Z0-9_.~-]+ ]]; then
	# Store "${1}" as "${ID}"
	ID="${1}"
else
	# Print an error message to stderr if $1 is empty or contains invalid characters
	>&2 echo "Usage: $0 <ID>"
	>&2 echo "<ID> must be a non-empty string that only contains characters that do not require URL encoding."
	>&2 echo ''
	exit 1
fi

# Update the following variable 'LOGO' with the filename provided during use of 0_upload.sh
LOGO="aafdc6e786d540f089f7051428e8048f8b1dbdbc.svg"

# The following variable 'QR_CODE_DATA' can be modified to whatever your team needs.
# Remember that less is more with QR Codes.  I.E. less characters mean fewer squares and easier scanning
# Our Attendance Scanning app ignores the url and only looks for the badge ID.  This allows the QR code to also serve as a link to our /lostcard page.
QR_CODE_DATA="https://angelbotics.org/lostcard?id='${ID}'"

# Request QR Code
curl -s -X POST 'https://qrcode-monkey.p.rapidapi.com/qr/transparent' \
	-H 'X-RapidAPI-Host: qrcode-monkey.p.rapidapi.com' \
	-H "X-RapidAPI-Key: ${Rapid_API_Key}" \
	-H 'content-type: application/json' \
	--data '{
	"data": "'${QR_CODE_DATA}'",
	"image": "'${LOGO}'",
	"x": 0,
	"y": 0,
	"size": 900,
	"crop": true,
	"download": false,
	"file": "png"
	}' \
	--output ./${ID}.png

if [[ -f ./${ID} ]]; then
	>&2 echo "${ID}.png created"
else
	>&2 echo "Something went wrong.  Consider updating the curl request to include -v for verbose logging"
fi
