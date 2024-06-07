# Python code so that it reads the HTML template and returns it to the webpage

from flask import Flask, render_template
app = Flask(__name__)
@app.route('/')
def home():
    return render_template('web.html')
if __name__ == '__main__':
    app.run(debug=True)