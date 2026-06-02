import os
import shutil
import random

PROJECT_ROOT = "/Users/gandisuastika/Study/TEL-U/ACADEMIC/Semester-6/UNI-PROJECT/GAB - TUBES PCD, APB, MTPP/pcd_ai model"

SOURCE_DIR = os.path.join(PROJECT_ROOT, "master_dataset")
DEST_DIR = os.path.join(PROJECT_ROOT, "notebooks/script/devider")

SOURCES = {
    "part_1": f"{SOURCE_DIR}/dataset_kematangan_buah/train/unripe",
    "part_2": f"{SOURCE_DIR}/dataset_kematangan_buah/train/ripe",
    "part_3": f"{SOURCE_DIR}/dataset_kesegaran_buah/train/fresh",
    "part_4": f"{SOURCE_DIR}/dataset_kesegaran_buah/train/unfresh",
}

NUM_IMAGES = 50

def create_devider():
    os.makedirs(DEST_DIR, exist_ok=True)
    
    for part_name, source_folder in SOURCES.items():
        part_dir = os.path.join(DEST_DIR, part_name)
        os.makedirs(part_dir, exist_ok=True)
        
        all_images = [f for f in os.listdir(source_folder) 
                      if f.lower().endswith(('.jpg', '.jpeg', '.png'))]
        
        selected = random.sample(all_images, NUM_IMAGES)
        
        for idx, img_name in enumerate(selected, 1):
            src_path = os.path.join(source_folder, img_name)
            dest_path = os.path.join(part_dir, f"img_{idx}.jpg")
            shutil.copy2(src_path, dest_path)
        
        print(f"✓ {part_name}: copied {len(selected)} images")
    
    print(f"\n✅ Done! Files saved to: {DEST_DIR}")

if __name__ == "__main__":
    create_devider()