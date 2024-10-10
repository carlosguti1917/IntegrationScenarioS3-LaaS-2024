from flask import Flask, request, jsonify
import time

app = Flask(__name__)

@app.route('/mock', methods=['POST'])
def mock():
    data = request.json
    time.sleep(3)  # Wait for 3 seconds
    return jsonify(data), 201

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
