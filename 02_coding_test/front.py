import os
from flask import Flask, jsonify, make_response, request, abort, render_template

app = Flask(__name__)

log = app.logger


@app.errorhandler(412)
def version_mismatch(error):
    return 'Version mismatch. Expected: {}: {}.{}'.format(
        X_BROKER_API_VERSION_NAME,
        X_BROKER_API_MAJOR_VERSION,
        X_BROKER_API_MINOR_VERSION), 412



@app.route('/')
def index():
    return render_template("index.html")


@app.route('/result', methods=['GET', 'POST'])
def weather():
    result = request.form
    return render_template("result.html", result = result)


if __name__ == "__main__":
    app.debug = True
    app.run(host='0.0.0.0', port=int(os.getenv('VCAP_APP_PORT', '9094')))
