from flask import Flask, jsonify, request, session
from flask_cors import CORS
import psycopg2
from flask import Flask, request, jsonify
import numpy as np
from keras.models import load_model
from keras.preprocessing.sequence import pad_sequences
from tensorflow.keras.preprocessing.text import Tokenizer
import re
import pandas as pd
from Sastrawi.StopWordRemover.StopWordRemoverFactory import StopWordRemoverFactory
import pickle

app = Flask(__name__)
app.secret_key = 'your_secret_key'  # Kunci untuk sesi (session) di Flask
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

# Route untuk menampilkan semua user
@app.route('/users', methods=['GET'])
def get_all_users():
    conn = get_db_connection()
    cur = conn.cursor()

    # Query untuk mengambil semua data dari tabel users
    cur.execute('SELECT * FROM users')
    users = cur.fetchall()

    cur.close()
    conn.close()

    # Jika tidak ada user
    if not users:
        return jsonify({'message': 'No users found'}), 404

    # Format data pengguna
    user_list = []
    for user in users:
        user_list.append({
            'id': user[0],  # Asumsikan kolom pertama adalah user_id
            'name': user[1],  # Asumsikan kolom kedua adalah nama
            'email': user[2]  # Asumsikan kolom ketiga adalah email
        })

    return jsonify({'users': user_list}), 200


# Route untuk login
@app.route('/login', methods=['POST'])
def login():
    login_data = request.get_json()
    username = login_data.get('email')  # Login menggunakan email
    password = login_data.get('password')

    if not username or not password:
        return jsonify({'message': 'Email and password are required'}), 400

    conn = get_db_connection()
    cur = conn.cursor()

    # Cek apakah email ada di database
    cur.execute('SELECT * FROM users WHERE email = %s', (username,))
    user = cur.fetchone()

    cur.close()
    conn.close()

    if user:
        # Periksa apakah password yang diberikan cocok dengan password yang ada di database (plaintext)
        stored_password = user[3]  # Asumsi kolom 3 adalah password yang ada di database dalam bentuk plaintext
        if password == stored_password:
            session['user_id'] = user[0]  # Simpan user_id dalam session
            return jsonify({
                'message': 'Login successful',
                'user': {
                    'id': user[0],
                    'name': user[1],
                    'email': user[2]
                }
            }), 200
        else:
            return jsonify({'message': 'Invalid password'}), 401
    else:
        return jsonify({'message': 'User not found'}), 404

# Route untuk logout
@app.route('/logout', methods=['POST'])
def logout():
    session.pop('user_id', None)  # Hapus user_id dari session
    return jsonify({'message': 'Logout successful'}), 200

# Route untuk melihat profil pengguna berdasarkan user_id
@app.route('/profile', methods=['GET'])
def profile():
    user_id = request.args.get('user_id')
    if not user_id:
        return jsonify({'message': 'User ID is required'}), 400

    try:
        user_id = int(user_id)  # Pastikan user_id adalah integer
    except ValueError:
        return jsonify({'message': 'Invalid User ID'}), 400

    conn = get_db_connection()
    cur = conn.cursor()

    # Query untuk mengambil data user berdasarkan user_id
    cur.execute('SELECT * FROM users WHERE user_id = %s', (user_id,))
    user = cur.fetchone()

    cur.close()
    conn.close()

    if user:
        return jsonify({
            'user': {
                'id': user[0],
                'name': user[1],
                'email': user[2]
            }
        }), 200
    else:
        return jsonify({'message': 'User not found'}), 404

# Route untuk menambahkan user baru (Register)
@app.route('/register', methods=['POST'])
def register():
    new_user = request.get_json()
    name = new_user.get('name')
    email = new_user.get('email')
    password = new_user.get('password')

    if not name or not email or not password:
        return jsonify({'message': 'Name, email, and password are required'}), 400

    conn = get_db_connection()
    cur = conn.cursor()

    # Cek apakah email sudah terdaftar
    cur.execute('SELECT * FROM users WHERE email = %s', (email,))
    existing_user = cur.fetchone()
    if existing_user:
        return jsonify({'message': 'Email is already registered'}), 400

    # Simpan user baru dengan password yang disertakan langsung (plaintext)
    cur.execute('INSERT INTO users (name, email, password) VALUES (%s, %s, %s)',
                (name, email, password))
    conn.commit()

    cur.close()
    conn.close()

    return jsonify({'message': 'User registered successfully'}), 201

# Route untuk mengubah profil pengguna
@app.route('/update_profile', methods=['PUT'])
def update_profile():
    user_id = request.args.get('user_id')  # Ambil user_id dari query params
    if not user_id:
        return jsonify({'message': 'User ID is required'}), 400

    try:
        user_id = int(user_id)  # Pastikan user_id adalah integer
    except ValueError:
        return jsonify({'message': 'Invalid User ID'}), 400

    update_data = request.get_json()
    name = update_data.get('name')
    email = update_data.get('email')

    if not name and not email:
        return jsonify({'message': 'At least one field (name or email) must be provided'}), 400

    conn = get_db_connection()
    cur = conn.cursor()

    # Cek apakah email sudah terdaftar oleh pengguna lain (jika ada perubahan email)
    if email:
        cur.execute('SELECT * FROM users WHERE email = %s', (email,))
        existing_user = cur.fetchone()
        if existing_user and existing_user[0] != user_id:
            return jsonify({'message': 'Email is already registered by another user'}), 400

    # Update nama dan/atau email
    if name:
        cur.execute('UPDATE users SET name = %s WHERE user_id = %s', (name, user_id))
    if email:
        cur.execute('UPDATE users SET email = %s WHERE user_id = %s', (email, user_id))

    conn.commit()

    cur.close()
    conn.close()

    return jsonify({'message': 'Profile updated successfully'}), 200
# Fungsi preprocessing teks
def preprocessing(text):
    # Case folding
    text = text.lower()

    # Menghapus tanda baca dan karakter non-alfabet
    text = re.sub(r'[^\w\s]', '', text)

    # Menghapus angka
    text = re.sub(r'\d+', '', text)

    # Stopword removal
    factory = StopWordRemoverFactory()
    stopwords = factory.get_stop_words()
    words = text.split()
    text = " ".join([word for word in words if word not in stopwords])

    return text

# Load model dan tokenizer
model_path = '/Users/muhammadzuamaalamin/Documents/bab4riset/fix/dataset/modelfix.h5'
# model_path='/Users/muhammadzuamaalamin/Documents/lab/model/model.h5'
tokenizer_path = '/Users/muhammadzuamaalamin/Documents/bab4riset/fix/dataset/tokenizer.pkl'

try:
    model = load_model(model_path)
    with open(tokenizer_path, 'rb') as f:
        tokenizer = pickle.load(f)
except Exception as e:
    print(f"Error loading model or tokenizer: {e}")
    exit()

# Parameter yang sama dengan pelatihan
max_length = 120
trunc_type = 'post'

@app.route('/predict', methods=['POST'])
def predict():
    try:
        # Ambil data JSON dari request
        data = request.get_json()
        if not data or 'texts' not in data:
            return jsonify({"error": "Data 'texts' tidak ditemukan dalam request"}), 400
        
        texts_to_predict = data['texts']
        
        # Preprocessing teks
        cleaned_texts = [preprocessing(text) for text in texts_to_predict]
        
        # Tokenize dan pad teks
        sequences = tokenizer.texts_to_sequences(cleaned_texts)
        padded_sequences = pad_sequences(sequences, maxlen=max_length, truncating=trunc_type)
        
        # Prediksi
        predictions = model.predict(padded_sequences)
        predicted_labels = np.argmax(predictions, axis=1)  # Ambil kelas dengan probabilitas tertinggi
        
        # Format respons
        results = []
        for i, text in enumerate(cleaned_texts):
            results.append({
                "original_text": texts_to_predict[i],
                "cleaned_text": text,
                "predicted_label": int(predicted_labels[i]),
                "prediction_probabilities": predictions[i].tolist()
            })
        
        return jsonify({"predictions": results})
    
    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
