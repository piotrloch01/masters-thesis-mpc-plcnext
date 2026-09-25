# Model Predictive Control (MPC) of a Two-Tank Cascade System (2x2 MIMO)

> *Polska wersja dokumentacji dostępna jest w pliku [README_PL.md](README_PL.md).*

This repository contains the complete technical implementation, simulation models, and configuration scripts for a Master's Thesis focused on designing, tuning, and evaluating an advanced Model Predictive Controller (MPC) for a non-linear two-tank cascade system under physical constraints and actuator dynamics.

---

## Project Overview

The primary control objective is to precisely track liquid level setpoints ($h_1, h_2$) in a two-tank cascade system while maintaining overall system stability and operating within strict physical boundaries.

### Key Features & Control Challenges
- **$2 \times 2$ MIMO Architecture:** Simultaneous control of pump flow rate ($MV_1$) and motorized valve opening ($MV_2$) with full cross-coupling compensation.
- **Physical Non-linearities:** Explicit consideration of pump saturation, Torricelli's outflow law, and valve backlash/dead-band ($\pm \Delta u / 2$).
- **Constraint Handling:** Hard input bounds combined with soft state and rate constraints using Equal Concern Relaxation (ECR) slack variables to prevent QP solver infeasibility under unmeasured disturbances.
- **Offset-Free Tracking:** Integration of output disturbance models with integrators (`setoutdist`) ensuring zero steady-state error under model mismatch.

---

## Requirements & Toolboxes

This project was developed and verified in **MATLAB R2024a**.

### Required Toolboxes:
- **MATLAB** (R2024a or newer)
- **Simulink** – Block diagram environment for dynamic system simulation.
- **Model Predictive Control Toolbox** – MPC object definition (`mpc`), prediction/control horizon tuning, weight matrices, and disturbance model setup.
- **Control System Toolbox** – Linear state-space system representation (`ss`).
- **Optimization Toolbox** – Real-time Quadratic Programming (QP) solver engine.

---

## Repository Structure

```text
├── models/
│   ├── two_tank_cascade_mpc.slx   # Main Simulink simulation model
│   ├── README.md                  # Models documentation (English)
│   └── README_PL.md               # Models documentation (Polish)
├── scripts/
│   ├── setup_mpc.m                # Master initialization script for MPC parameters
│   ├── README.md                  # Scripts documentation (English)
│   └── README_PL.md               # Scripts documentation (Polish)
├── README_PL.md                   # Main repository documentation (Polish)
└── README.md                      # Main repository documentation (English)
```

### Directory Breakdown:
- **`scripts/`**: Contains `setup_mpc.m`, which defines discrete state-space plant matrices, sets horizons ($N_p = 75$, $N_c = 3$), weights ($Q$, $R$), scaling factors, and ECR slack variables. This script must be executed before launching the Simulink simulation. For detailed script descriptions, see [`scripts/README.md`](scripts/README.md) (or [`scripts/README_PL.md`](scripts/README_PL.md)).
- **`models/`**: Contains the full Simulink diagram integrating the non-linear two-tank cascade, valve dead-band block, and the MPC controller block. For block diagram details, see [`models/README.md`](models/README.md) (or [`models/README_PL.md`](models/README_PL.md)).

---

## Quick Start

1. Clone the repository:
   ```bash
   git clone [https://github.com/piotrloch01/two-tank-cascade-mpc.git](https://github.com/piotrloch01/two-tank-cascade-mpc.git)
   ```
2. Open **MATLAB R2024a** and set the project directory as your current workspace.
3. Run the configuration script to load the controller object (`mpc_obj`) and state vector (`xmpc`) into the Workspace:
   ```matlab
   run('scripts/setup_mpc.m')
   ```
4. Open and run the simulation model:
   ```matlab
   open('models/two_tank_cascade_mpc.slx')
   ```

---

## License

Distributed under the **MIT License**. See `LICENSE` for more information.
