from pathlib import Path

from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    model_base_path: str = "/Users/gandisuastika/Study/TEL-U/ACADEMIC/Semester-6/UNI-PROJECT/GAB - TUBES PCD, APB, MTPP/dev/pcd_ai model/models"
    model_variety_path: str = "model_variety_best.h5"
    model_ripeness_path: str = "model_ripeness_finetuned.h5"
    model_freshness_path: str = "model_freshness_best.h5"
    class_indices_variety: str = "class_indices_variety.json"
    class_indices_ripeness: str = "class_indices_ripeness.json"
    class_indices_freshness: str = "class_indices_freshness.json"
    host: str = "0.0.0.0"
    port: int = 8000
    image_size: int = 224

    def get_full_model_path(self, filename: str) -> str:
        return str(Path(self.model_base_path) / filename)

    class Config:
        env_file = ".env"


settings = Settings()
