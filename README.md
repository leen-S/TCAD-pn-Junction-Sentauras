# TCAD Simulation: PN Junction using Sentaurus

This repository contains a basic PN junction simulation using Synopsys Sentaurus TCAD. The junction is formed by doping silicon with **boron (p-type)** and **arsenic (n-type)**.

---

## 🧰 Tools Used
- **Sentaurus Workbench**
- **SDE** – for structure and doping
- **SDEVICE** – for electrical simulation
- **SimView / Sentaurus Visual** – for plotting
- **Python (optional)** – for post-processing data

---

## 📁 Directory Structure

| Folder        | Description |
|---------------|-------------|
| `input_files/`| Simulation input files (`.cmd`, `.des`) |
| `output/`     | `.tdr` output, logs, and plots |
| `scripts/`    | Optional scripts for extracting and plotting results |
| `screenshots/`| Screenshots from SimView or exported images |

---

## 💡 Simulation Details

- **Material**: Silicon
- **P-type Dopant**: Boron
- **N-type Dopant**: Arsenic
- **Structure**: 1D vertical PN junction

### 📈 Sample Results

- Built-in potential
- IV Characteristics
- Band diagram

![Band Diagram](screenshots/simview_potential.png)
![IV Curve](output/plots/iv_curve.png)

---

## 📜 License
[MIT](LICENSE)

---

## 🚀 Getting Started
To re-run the simulation:
```bash
sde -e mesh.des
sde -e doping.cmd
sdevice device.cmd
