# To create api using flask
from flask import Flask, request, jsonify

app = Flask(__name__)


@app.route('/')
def hello_world():
    return 'This is an API'

@app.route('/post', methods=["POST"])
def testpost():
     input_json = request.get_json(force=True) 
     dictToReturn = {'text':input_json['text']}
     return jsonify(dictToReturn) 