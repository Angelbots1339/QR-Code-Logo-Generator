[QRCode-Monkey](https://www.qrcode-monkey.com/) offers free basic QR Codes but they also offer transparent QR Codes for a small price through [RapidAPI](https://rapidapi.com/qrcode-monkey/api/custom-qr-code-with-logo).  We opted to spend the ~$20 for 1000 API calls to create our branded QR Codes.  You can find a good summary of all the QR Code customization options [here](https://www.qrcode-monkey.com/qr-code-api-with-logo/)

Once you have [registered](https://rapidapi.com/auth/sign-up) with RapidAPI and [Subscribed](https://rapidapi.com/qrcode-monkey/api/custom-qr-code-with-logo/pricing) to QRCode-Monkey, update the `creds.sh` file with your API key.

QR Codes have 3 positioning squares and 1 alignment square that cannot be moved nor obstructed. To assist with optimal logo placement we included `QR_FreeSpaceTemplate.svg`.
![](https://raw.githubusercontent.com/Angelbots1339/QR-Code-Logo-Generator/7515d70ad0a63f82d98deffb2615308d0115ec78/QR_FreeSpaceTemplate.svg)
*Our testing found that 900x900 pixels was the optimal size to preserve resolution when the final QR Code is returned by the service*

example: `Angelbotics_QR_Friendly_logo.svg`
![](https://raw.githubusercontent.com/Angelbots1339/QR-Code-Logo-Generator/7515d70ad0a63f82d98deffb2615308d0115ec78/Angelbotics_QR_Friendly_logo.svg)

Once your team_logo.svg is ready, start by uploading a square 900x900 pixel SVG image
`$ ./0_upload.sh team_logo.svg`

The service will provide a json body response containing the filename:
`{"file":"19ff575213641e17a9773772d52e01329fb7c78e.svg"}`

The filename should be used to update the `1_qrcode_gen.sh` LOGO variable
`25. LOGO="19ff575213641e17a9773772d52e01329fb7c78e.svg"`
Be sure to also update the QR_CODE_DATA variable
`30. QR_CODE_DATA="https://angelbotics.org/lostcard?id='${ID}'"`

You can now request your transparent QR Code:
`./1_qrcode_gen.sh 123456`

sample output:
![](https://github.com/Angelbots1339/QR-Code-Logo-Generator/blob/main/555121_white_bg.png?raw=true)
