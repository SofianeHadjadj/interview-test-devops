import os
from flask import Flask, jsonify, make_response, request, abort, render_template, redirect, url_for
from contextlib import closing
from urllib.request import urlopen
import dateutil.parser
import json
import requests


app = Flask(__name__)

log = app.logger


@app.errorhandler(412)
def version_mismatch(error):
    return 'Version mismatch. Expected: {}: {}.{}'.format(
        X_BROKER_API_VERSION_NAME,
        X_BROKER_API_MAJOR_VERSION,
        X_BROKER_API_MINOR_VERSION), 412


# Fonction 


@app.route('/weather', methods=['GET', 'POST'])
def get_weather():
    insee = request.form['insee']

    with closing(urlopen('https://api.meteo-concept.com/api/forecast/nextHours?token=2841e5554eb1c1a1953abd90b32f5c025be6f8d4ab76a092f2cbe0cda66a2b3a&insee=' + insee)) as f:
        decoded = json.loads(f.read())
        (city,forecast) = (decoded[k] for k in ('city','forecast'))

        saturday = None
        for i,f in enumerate(forecast):
            day = dateutil.parser.parse(f['datetime']).strftime('%H:%M  ') # today : 0, tomorrow : 1, etc. (13 max)

    cityname = city['name']
    temperature = forecast[0]['temp2m']
    rain = forecast[0]['rr10']

    info_weather = {
        "Name of the city" : cityname,
        "Temperature" : temperature,
        "Precipitation" : rain
    }


    url = 'http://0.0.0.0:9094/result'

    x = requests.post(url, data = info_weather, allow_redirects=True)

    return x.text


if __name__ == "__main__":
    app.debug = True
    app.run(host='0.0.0.0', port=int(os.getenv('VCAP_APP_PORT', '9096')))



