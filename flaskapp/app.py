from flask import Flask, jsonify, request, session
from flask_cors import CORS
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
model_path = 'flaskapp/modelfix.h5'
# model_path='/Users/muhammadzuamaalamin/Documents/lab/model/model.h5'
tokenizer_path = 'tokenizer.pkl'

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
