from pydantic import BaseModel, Field


class ConfidenceScores(BaseModel):
    fruit_type: float = Field(..., ge=0.0, le=1.0, description="Confidence score for fruit type prediction")
    ripeness_status: float = Field(..., ge=0.0, le=1.0, description="Confidence score for ripeness prediction")
    freshness_level: float = Field(..., ge=0.0, le=1.0, description="Confidence score for freshness prediction")


class Metrics(BaseModel):
    inference_time_seconds: float = Field(..., description="AI inference time in seconds")
    payload_size_kb: float = Field(..., description="Uploaded image size in KB")


class PredictionResponse(BaseModel):
    fruit_type: str = Field(..., description="Predicted fruit type: apples, banana, or oranges")
    ripeness_status: str = Field(..., description="Predicted ripeness: unripe, ripe, or overripe")
    freshness_level: str = Field(..., description="Predicted freshness: fresh or unfresh")
    confidence: ConfidenceScores = Field(..., description="Confidence scores for each prediction")
    metrics: Metrics = Field(..., description="Performance metrics for the prediction")


class HealthResponse(BaseModel):
    status: str
    models_loaded: dict[str, bool]
