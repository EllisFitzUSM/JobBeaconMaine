from flask import Flask, render_template
from routes.user import user_routes

app = Flask(__name__)
app.register_blueprint(user_routes)

@app.route("/")
def home():
    return render_template('index.html')

app.run(debug=True)