from flask import Flask, request, jsonify
from flask_cors import CORS  # Import CORS
import numpy as np
from tensorflow.keras.preprocessing.sequence import pad_sequences
import json
import joblib
from tensorflow.keras.preprocessing.text import tokenizer_from_json
import tensorflow as tf

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Load the model
model = tf.keras.models.load_model('assets/MEDICAN_CNNv68.h5')

# Load the LabelEncoder
label_encoder = joblib.load('assets/label_encoder2.pkl')

# Load the tokenizer
with open('assets/tokenizer2.json') as f:
    tokenizer_json = json.load(f)
    tokenizer = tokenizer_from_json(tokenizer_json)

@app.route('/predict', methods=['POST'])
def predict():
    data = request.json
    new_diagnosis = data.get("diagnosis")

    # Convert the diagnosis to a sequence
    new_sequence = tokenizer.texts_to_sequences([new_diagnosis])
    new_padded = pad_sequences(new_sequence, maxlen=100, padding='post')

    # Get the model's prediction
    prediction = model.predict(new_padded)

    # Get the index of the highest probability
    predicted_index = np.argmax(prediction, axis=1)

    # Convert the index to the corresponding class label
    predicted_class = label_encoder.inverse_transform(predicted_index)

    return jsonify({'predicted_class': predicted_class[0]})

if __name__ == '__main__':
    app.run(debug=True)
