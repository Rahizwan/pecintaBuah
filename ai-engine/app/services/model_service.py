import json
import logging
from concurrent.futures import ThreadPoolExecutor

import numpy as np
import tensorflow as tf

from app.config import settings
from app.schemas.prediction import ConfidenceScores, Metrics, PredictionResponse

logger = logging.getLogger(__name__)

_executor = ThreadPoolExecutor(max_workers=3)

_variety_model = None
_ripeness_model = None
_freshness_model = None
_variety_labels = None
_ripeness_labels = None
_freshness_labels = None


def _load_model_and_labels(model_path: str, indices_path: str):
    model = tf.keras.models.load_model(model_path)
    with open(indices_path, "r") as f:
        indices = json.load(f)
    first_key = next(iter(indices.keys()))
    try:
        int(first_key)
        labels = {int(k): v for k, v in indices.items()}
    except ValueError:
        labels = {int(v): k for k, v in indices.items()}
    return model, labels


def load_all_models():
    global _variety_model, _ripeness_model, _freshness_model
    global _variety_labels, _ripeness_labels, _freshness_labels

    logger.info("Loading variety model from %s", settings.get_full_model_path(settings.model_variety_path))
    _variety_model, _variety_labels = _load_model_and_labels(
        settings.get_full_model_path(settings.model_variety_path),
        settings.get_full_model_path(settings.class_indices_variety),
    )

    logger.info("Loading ripeness model from %s", settings.get_full_model_path(settings.model_ripeness_path))
    _ripeness_model, _ripeness_labels = _load_model_and_labels(
        settings.get_full_model_path(settings.model_ripeness_path),
        settings.get_full_model_path(settings.class_indices_ripeness),
    )

    logger.info("Loading freshness model from %s", settings.get_full_model_path(settings.model_freshness_path))
    _freshness_model, _freshness_labels = _load_model_and_labels(
        settings.get_full_model_path(settings.model_freshness_path),
        settings.get_full_model_path(settings.class_indices_freshness),
    )

    logger.info("All models loaded successfully")


def _predict_variety(image_array: np.ndarray) -> tuple[str, float]:
    predictions = _variety_model.predict(image_array, verbose=0)
    class_idx = int(np.argmax(predictions[0]))
    confidence = float(np.max(predictions[0]))
    label = _variety_labels.get(class_idx, "unknown")
    return label, confidence


def _predict_ripeness(image_array: np.ndarray) -> tuple[str, float]:
    predictions = _ripeness_model.predict(image_array, verbose=0)
    class_idx = int(np.argmax(predictions[0]))
    confidence = float(np.max(predictions[0]))
    label = _ripeness_labels.get(class_idx, "unknown")
    return label, confidence


def _predict_freshness(image_array: np.ndarray) -> tuple[str, float]:
    score = float(_freshness_model.predict(image_array, verbose=0)[0][0])
    class_idx = 1 if score > 0.5 else 0
    confidence = score if class_idx == 1 else 1 - score
    label = _freshness_labels.get(class_idx, "unknown")
    return label, confidence


def run_parallel_inference(image_array: np.ndarray) -> PredictionResponse:
    future_variety = _executor.submit(_predict_variety, image_array)
    future_ripeness = _executor.submit(_predict_ripeness, image_array)
    future_freshness = _executor.submit(_predict_freshness, image_array)

    variety_label, variety_confidence = future_variety.result()
    ripeness_label, ripeness_confidence = future_ripeness.result()
    freshness_label, freshness_confidence = future_freshness.result()

    return PredictionResponse(
        fruit_type=variety_label,
        ripeness_status=ripeness_label,
        freshness_level=freshness_label,
        confidence=ConfidenceScores(
            fruit_type=round(variety_confidence, 4),
            ripeness_status=round(ripeness_confidence, 4),
            freshness_level=round(freshness_confidence, 4),
        ),
        metrics=Metrics(inference_time_seconds=0.0, payload_size_kb=0.0),
    )


def get_model_status() -> dict[str, bool]:
    return {
        "variety": _variety_model is not None,
        "ripeness": _ripeness_model is not None,
        "freshness": _freshness_model is not None,
    }
