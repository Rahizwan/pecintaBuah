import logging
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.config import settings
from app.routers.prediction_routes import router as prediction_router
from app.services import model_service

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)
logger = logging.getLogger(__name__)


@asynccontextmanager
async def lifespan(app: FastAPI):
    logger.info("Starting AI Intelligence Layer...")
    model_service.load_all_models()
    logger.info("AI Intelligence Layer ready. Serving on %s:%s", settings.host, settings.port)
    yield
    logger.info("Shutting down AI Intelligence Layer...")


app = FastAPI(
    title="Fruit Scan AI Engine",
    description="Parallel Tri-Model AI inference for fruit type, ripeness, and freshness detection using MobileNetV2",
    version="1.0.0",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(prediction_router, prefix="/api/v1", tags=["Prediction"])


@app.get("/", tags=["Root"])
async def root():
    return {"message": "Fruit Scan AI Engine is running", "docs": "/docs"}
