import json

# Load the notebook
with open("train_model1_variety.ipynb", "r") as f:
    nb = json.load(f)

# Find Cell 3 (index 2) - the one with test_generator.class_indices
cell_index = 2

# New source for Cell 3 with setup code
new_source = [
    "import os\n",
    "import json\n",
    "from tensorflow.keras.preprocessing.image import ImageDataGenerator\n",
    "\n",
    "# --- SETUP: Recreate test_generator if not exists ---\n",
    "if 'test_generator' not in globals():\n",
    "    print(\"[INFO] Recreating test_generator...\")\n",
    "    DATASET_PATH = 'master_dataset/dataset_jenis_buah'\n",
    "    TEST_DIR = os.path.join(DATASET_PATH, 'test')\n",
    "    IMG_SIZE = (224, 224)\n",
    "    BATCH_SIZE = 32\n",
    "    \n",
    "    test_datagen = ImageDataGenerator(rescale=1./255)\n",
    "    test_generator = test_datagen.flow_from_directory(\n",
    "        TEST_DIR,\n",
    "        target_size=IMG_SIZE,\n",
    "        batch_size=BATCH_SIZE,\n",
    "        class_mode='categorical',\n",
    "        shuffle=False\n",
    "    )\n",
    "\n",
    "# Mengambil dictionary class indices dari generator\n",
    "class_indices = test_generator.class_indices\n",
    "\n",
    "# Membalik dictionary agar mudah dibaca: {index: label}\n",
    "labels_map = {v: k for k, v in class_indices.items()}\n",
    "\n",
    "# Simpan ke folder models\n",
    "json_path = 'models/class_indices_variety.json'\n",
    "with open(json_path, 'w') as f:\n",
    "    json.dump(labels_map, f, indent=4)\n",
    "\n",
    "print(f\"[SUCCESS] Label map disimpan di: {json_path}\")\n",
    "print(\"Isi Label Map:\", labels_map)"
]

# Update the cell
nb["cells"][cell_index]["source"] = new_source

# Also fix Cell 2 (evaluation cell - index 1) to add setup code
cell_2_index = 1
cell_2_source = nb["cells"][cell_2_index]["source"]
setup_code = [
    "import os\n",
    "import tensorflow as tf\n",
    "from tensorflow.keras.preprocessing.image import ImageDataGenerator\n",
    "\n",
    "# --- SETUP: Restore variables if not exist ---\n",
    "if 'model' not in globals():\n",
    "    print(\"[INFO] Loading saved model...\")\n",
    "    DATASET_PATH = 'master_dataset/dataset_jenis_buah'\n",
    "    TEST_DIR = os.path.join(DATASET_PATH, 'test')\n",
    "    IMG_SIZE = (224, 224)\n",
    "    BATCH_SIZE = 32\n",
    "    \n",
    "    model = tf.keras.models.load_model('models/model_variety_best.h5')\n",
    "    test_datagen = ImageDataGenerator(rescale=1./255)\n",
    "    print(\"[INFO] Model loaded successfully.\")\n",
    "\n"
]

# Prepend setup code to Cell 2
nb["cells"][cell_2_index]["source"] = setup_code + cell_2_source

# Save the notebook
with open("train_model1_variety.ipynb", "w") as f:
    json.dump(nb, f, indent=2)

print("Notebook updated successfully!")
print("Cell 2 and Cell 3 now have setup code to reload model and variables after kernel restart.")
