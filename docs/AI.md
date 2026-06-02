# AI Model Training — Fruit Classification

Branch: [`AI_PROJECT`](https://github.com/Rahizwan/pecintaBuah/tree/AI_PROJECT)

## Overview

Three **MobileNetV2** models trained to classify fruit images:

| Model | Task | Classes | Best Accuracy |
|-------|------|---------|---------------|
| Variety | Jenis buah | apple, banana, orange | **97.48%** |
| Ripeness | Tingkat kematangan | ripe, unripe, overripe | **92.67%** |
| Freshness | Tingkat kesegaran | fresh, semi-fresh, not-fresh | **97.92%** |

## Clone Repository

```bash
git clone -b AI_PROJECT https://github.com/Rahizwan/pecintaBuah.git fruit-ai
cd fruit-ai
```

## Setup Environment

### 1. Buat Virtual Environment

```bash
python3.12 -m venv .venv
source .venv/bin/activate
```

### 2. Install Dependencies

```bash
pip install --upgrade pip
pip install tensorflow numpy matplotlib seaborn scikit-learn Pillow jupyter
```

> **Catatan:** Jika pakai laptop Apple Silicon (M1/M2/M3), TensorFlow akan otomatis mendeteksi GPU (Metal). Jika pakai Windows/Laptop biasa, gunakan `tensorflow-cpu` jika tidak punya GPU NVIDIA.

### 3. Download Dataset

Folder `master_dataset/` (2.8 GB) **tidak** di-push ke GitHub karena terlalu besar.

1. Download dari Google Drive (link dari pemilik repo)
2. Ekstrak dan taruh folder `master_dataset/` di root `fruit-ai/`
3. Struktur setelah selesai:

```
fruit-ai/
├── master_dataset/
│   ├── dataset_jenis_buah/         # variety (apples/banana/oranges)
│   ├── dataset_kematangan_buah/    # ripeness (overripe/ripe/unripe)
│   └── dataset_kesegaran_buah/     # freshness (fresh/unfresh)
├── models/                         # trained model files (.h5, .pkl)
├── notebooks/                      # additional notebooks
├── test_real_world/                # real-world test images
├── train_model1_variety.ipynb      # training notebook
├── train_model2_ripeness.ipynb     # training notebook
├── train_model3_freshness.ipynb    # training notebook
├── eda_all_check.ipynb             # EDA notebook
├── cm_combined.ipynb               # confusion matrix
└── test_inference.ipynb            # inference test
```

## Menjalankan Notebook

```bash
source .venv/bin/activate   # jika belum aktif
jupyter notebook
```

Urutan yang disarankan:

1. **`eda_all_check.ipynb`** — Eksplorasi dataset (lihat distribusi, sample gambar)
2. **`train_model1_variety.ipynb`** — Training model variety
3. **`train_model2_ripeness.ipynb`** — Training model ripeness
4. **`train_model3_freshness.ipynb`** — Training model freshness
5. **`cm_combined.ipynb`** — Generate confusion matrix gabungan
6. **`test_inference.ipynb`** — Uji inference dengan gambar dari `test_real_world/`

## Arsitektur Model (MobileNetV2)

```
Input (224x224x3)
    │
MobileNetV2 (pretrained ImageNet, frozen base)
    │
GlobalAveragePooling2D
    │
Dropout(0.3 — 0.5)        ← bervariasi tiap model
    │
Dense(128)                 ← hanya untuk ripeness & freshness
    │
Dense(num_classes, softmax) ← output
```

**Detail per model:**

| Model | Dropout | Dense 128 | Loss | Output |
|-------|---------|-----------|------|--------|
| Variety | 0.3 | ❌ | categorical_crossentropy | softmax (3) |
| Ripeness | 0.4 | ✅ | categorical_crossentropy | softmax (3) |
| Freshness | 0.5 | ✅ | binary_crossentropy | sigmoid (1) |

**Fine-tuning:** Model ripeness melakukan fine-tuning (unfreeze 20 layer terakhir, lr=1e-5) setelah training awal.

**Class weighting:** Diterapkan pada ripeness dan freshness untuk menangani ketidakseimbangan data.

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `ModuleNotFoundError: tensorflow` | Jalankan `pip install tensorflow` |
| Notebook error setelah restart kernel | Jalankan `python fix_notebook.py` |
| `master_dataset/` not found | Download dari Google Drive |
| GPU not detected | Pakai Apple Silicon / NVIDIA GPU, atau install `tensorflow-cpu` |
| RAM tidak cukup saat training | Kurangi `batch_size` di notebook (default: 32) |

## Referensi

- **FastAPI Inference API:** Branch `FAST_API_PROJECT`
- **Dataset:** Google Drive (minta link ke pemilik repo)
- **Laporan lengkap:** Branch `DOCS_PROJECT` → `docs/laporan/`
