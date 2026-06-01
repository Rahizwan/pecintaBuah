# AI Inference — FastAPI

## Tech Stack
- **Python 3.12** / **FastAPI** / **Uvicorn**
- **ML Framework:** TensorFlow / Keras
- **Image Processing:** OpenCV, Pillow, NumPy

## Models

The system uses three trained models:

| Model | Task | Output Classes |
|-------|------|----------------|
| Variety | Fruit type classification | apple, banana, orange |
| Ripeness | Ripeness level | ripe, unripe, overripe |
| Freshness | Freshness level | fresh, semi-fresh, not-fresh |

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/predict` | Upload image → all 3 predictions |
| GET | `/health` | Health check |

### Predict Request

```
POST /predict
Content-Type: multipart/form-data

file: <image.jpg/png>
```

### Predict Response

```json
{
  "variety": {
    "prediction": "apple",
    "confidence": 0.98
  },
  "ripeness": {
    "prediction": "ripe",
    "confidence": 0.95
  },
  "freshness": {
    "prediction": "fresh",
    "confidence": 0.92
  }
}
```

## Model Training

Training notebooks are in the `pcd_ai model/` directory (separate from this branch), containing:

- `train_model1_variety.ipynb` — KNN for fruit variety
- `train_model2_ripeness.ipynb` — KNN for ripeness
- `train_model3_freshness.ipynb` — KNN for freshness
- `eda_check.ipynb` — Exploratory data analysis
- `test_inference.ipynb` — Inference testing

## Serving

```bash
.venv/bin/python -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```
