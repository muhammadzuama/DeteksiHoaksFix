from flask import Flask, jsonify, request
from flask_cors import CORS  # Import Flask-CORS
import psycopg2

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Koneksi ke database PostgreSQL
def get_db_connection():
    conn = psycopg2.connect(
        host="localhost",
        database="hoaks",
        user="postgres",
        password="1905"
    )
    return conn

# Route untuk memeriksa koneksi API
@app.route('/')
def index():
    return 'Flask PostgreSQL API is running'

# Route untuk mendapatkan semua data users dari PostgreSQL
@app.route('/users', methods=['GET'])
def get_users():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT * FROM users')
    rows = cur.fetchall()
    cur.close()
    conn.close()

    # Konversi hasil query ke format JSON
    users = []
    for row in rows:
        users.append({
            'id': row[0],
            'name': row[1],
            'email': row[2]
        })

    return jsonify(users)

@app.route('/history', methods=['GET'])
def get_history():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT * FROM history')
    rows = cur.fetchall()
    cur.close()
    conn.close()

    # Konversi hasil query ke format JSON
    history = []
    for row in rows:
        history.append({
            'id': row[0],
            'input': row[2],          # Asumsi kolom 2 adalah 'input'
            'hasil': row[3],          # Asumsi kolom 3 adalah 'hasil'
            'waktu': row[4],          # Asumsi kolom 4 adalah 'waktu'
            'user_id': row[1],        # Asumsi kolom 1 adalah 'user_id'
            'release': row[5],        # Asumsi kolom 5 adalah 'release'
        })

    return jsonify(history)

# Route untuk menambahkan user baru
@app.route('/users', methods=['POST'])
def add_user():
    conn = get_db_connection()
    cur = conn.cursor()

    new_user = request.get_json()
    name = new_user['name']
    email = new_user['email']

    cur.execute('INSERT INTO users (name, email) VALUES (%s, %s)',
                (name, email))
    conn.commit()
    cur.close()
    conn.close()

    return jsonify({'status': 'User added successfully'}), 201

if __name__ == '__main__':
    app.run(host='192.168.1.4', port=5000, debug=True)