# AGENTS.md — PCD/APB/MTPP Fruit AI

## Project overview

Academic project ("TUBES") at Telkom University. Three parallel **MobileNetV2** models classify fruit images by **variety**, **ripeness**, and **freshness**.

**Pipeline**: Flutter → Laravel + PostgreSQL → FastAPI → (3 AI models in parallel) → JSON

This repo contains only the AI inference side (notebooks + trained models + dataset).

## Directory layout

```
├── master_dataset/
│   ├── dataset_jenis_buah/         # Model 1: variety (apples/banana/oranges)
│   ├── dataset_kematangan_buah/    # Model 2: ripeness (overripe/ripe/unripe)
│   └── dataset_kesegaran_buah/     # Model 3: freshness (fresh/unfresh)
├── models/
│   ├── model_variety_best.h5       # 97.48% val_acc
│   ├── model_ripeness_best.h5      # 92.67% val_acc
│   ├── model_ripeness_finetuned.h5 # 92.33% val_acc (fine-tuned variant)
│   ├── model_freshness_best.h5     # 97.92% val_acc
│   ├── class_indices_variety.json
│   ├── class_indices_ripeness.json
│   └── class_indices_freshness.json
├── train_model1_variety.ipynb      # training notebook: variety
├── train_model2_ripeness.ipynb     # training notebook: ripeness
├── train_model3_freshness.ipynb    # training notebook: freshness
├── test_inference.ipynb            # batch inference on test_real_world/ images
├── eda_all_check.ipynb             # full EDA across all 3 datasets
├── cm_combined.ipynb               # merges 3 confusion matrix PNGs side-by-side
├── fix_notebook.py                 # patches train_model1_variety.ipynb for kernel-restart safety
└── test_real_world/                # drop real-world test images here
```

## Python environment

- **Python 3.12.7** via `.venv/` (already exists, activate with `source .venv/bin/activate`)
- TF uses **Apple Metal (M2 GPU)** — automatically detected
- Key deps: `tensorflow`, `numpy`, `matplotlib`, `seaborn`, `scikit-learn`, `Pillow`

## Training quirks

- All 3 models use **MobileNetV2** (ImageNet pretrained, frozen base) with custom top layers
- `train_model2_ripeness.ipynb` has a **fine-tuning phase** (unfreezes last 20 layers, re-trains at lr=1e-5)
- **Class weighting** used in ripeness and freshness notebooks to handle imbalance
- Variety has `Dropout(0.3)`, ripeness has `Dropout(0.4) + Dense(128)`, freshness has `Dropout(0.5) + Dense(128)`
- Output: variety/ripeness use `categorical_crossentropy + softmax`; freshness uses `binary_crossentropy + sigmoid`

## If kernel is restarted

Run `fix_notebook.py` after re-cloning or if evaluation cells fail with missing variables.
It prepends reload code to the evaluation cells of `train_model1_variety.ipynb`.

## Inference benchmark (Apple M2)

- Variety: ~78 ms/pred (~12.9 FPS)
- Freshness: ~81 ms/pred (~12.4 FPS)

## Notebook assistant rules

See `notebooks/rules/Prompt Start.md` for the master prompt used when starting new AI sessions.
See `notebooks/rules/Prompt Log.md` for the daily memory log template.

## What's NOT in this repo

- FastAPI inference server code
- Laravel backend / PostgreSQL schema
- Flutter mobile app
