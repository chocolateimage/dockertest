import os
from flask import Flask
import requests # for testing live rebuilding

is_prod = os.environ.get("PROD","FALSE") == "TRUE"
app = Flask(__name__)

@app.post("/api/data")
def api_data():
    data = "This is some data"
    if is_prod:
        data += " (This is the API telling you that this is prod)"
    return data

if __name__ == "__main__":
    app.run(debug=not is_prod,host="0.0.0.0",port=8081)