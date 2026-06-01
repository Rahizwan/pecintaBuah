import logging
import time

from fastapi import APIRouter, HTTPException, UploadFile

from app.schemas.prediction import HealthResponse, PredictionResponse
from app.services import model_service
from app.utils import image_processing

logger = logging.getLogger(__name__)

router = APIRouter()


@router.post(
    "/predict",
    response_model=PredictionResponse,
    summary="Predict fruit type, ripeness, and freshness from an image",
)
async def predict(file: UploadFile):
    if not file.content_type or not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="File must be an image (jpeg, png, etc.)")

    image_bytes = await file.read()

    if len(image_bytes) == 0:
        raise HTTPException(status_code=400, detail="Uploaded image is empty")

    payload_size_kb = len(image_bytes) / 1024.0

    try:
        image_array = image_processing.preprocess_image(image_bytes)

        inference_start = time.time()
        result = model_service.run_parallel_inference(image_array)
        inference_time = time.time() - inference_start

        logger.info(
            "Inference completed: inference_time=%.4fs, payload_size=%.2fKB",
            inference_time,
            payload_size_kb,
        )

        result.metrics = {
            "inference_time_seconds": round(inference_time, 4),
            "payload_size_kb": round(payload_size_kb, 2),
        }

        return result
    except Exception as e:
        logger.error("Prediction failed: %s", str(e))
        raise HTTPException(status_code=500, detail="Prediction failed. Please try again.")


@router.get(
    "/health",
    response_model=HealthResponse,
    summary="Check if all AI models are loaded",
)
async def health_check():
    model_status = model_service.get_model_status()
    all_loaded = all(model_status.values())

    return HealthResponse(
        status="healthy" if all_loaded else "degraded",
        models_loaded=model_status,
    )
