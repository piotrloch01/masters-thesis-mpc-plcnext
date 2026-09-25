# Configuration Scripts Documentation

> Polish version of the scripts documentation is available in [README_PL.md](README_PL.md).

This folder contains the core initialization script `setup_mpc.m`, which builds, configures, and parameterizes the Model Predictive Controller (`mpc_obj`) and its state object (`xmpc`) in the MATLAB Workspace prior to running the Simulink simulation.

---

## Script Overview: `setup_mpc.m`

The script executes the following setup pipeline:

1. **Physical & System Parameters Definition**
   - Sets the sampling time $T_s = 0.5\text{ s}$.
   - Defines tank geometry parameters ($H_{\max} = 0.382\text{ m}$, cross-sectional area $A_t = 0.0222\text{ m}^2$).

2. **Linear State-Space Plant Model Setup**
   - Loads the discretized state-space matrices ($A_d, B_d, C_d, D_d$).
   - Instantiates a discrete-time LTI system object: `plant_d = ss(Ad, Bd, Cd, Dd, Ts)`.

3. **MPC Controller Object Generation & Scaling**
   - Instantiates `mpc_obj = mpc(plant_d, Ts)`.
   - Defines range-based `ScaleFactor` for both Manipulated Variables (MVs) and Output Variables (OVs) to improve QP solver numerical conditioning.

4. **Constraint Engineering & Soft Bounds (ECR)**
   - **Outputs ($OV_1, OV_2$):** Sets level bounds between 15% and 90% of total tank height $H_{\max}$ with soft Equal Concern Relaxation (`MinECR = 0.02`, `MaxECR = 0.02`) to ensure QP feasibility under disturbances.
   - **Inputs ($MV_1, MV_2$):** Hard physical bounds for Pump ($40 \le u_p \le 90$) and Valve ($30 \le u_v \le 100$).
   - **Rate Constraints:** Bounds input slew rates ($\Delta u_p, \Delta u_v$) with ECR relaxation variables to model realistic actuator dynamics.

5. **Horizons & Optimization Weights**
   - **Prediction Horizon ($N_p$):** 75 steps ($37.5\text{ s}$).
   - **Control Horizon ($N_c$):** 3 steps ($1.5\text{ s}$).
   - **Weights:** $Q_{OV} = [0.4, 0.6]$ (higher priority on $h_2$), $R_{\Delta u} = [5, 5]$ (actuator movement suppression), $R_u = [0, 0]$.

6. **Offset-Free Tracking & State Vector Initialization**
   - Configures output disturbance integrators using `setoutdist(mpc_obj, 'Integrators')` to guarantee zero steady-state error.
   - Initializes the state vector `xmpc` with initial tank levels ($0.5 H_{\max}$) and initial actuator values ($MV_1 = 65, MV_2 = 70$).

---

## Summary Table of Controller Configuration

| Parameter | Identifier in Code | Value / Settings | Description |
| :--- | :--- | :--- | :--- |
| **Sampling Time** | `Ts` | $0.5\text{ s}$ | Controller execution period |
| **Tank Heights Range** | `OV(1)`, `OV(2)` | $[0.0573, 0.3438]\text{ m}$ | 15% - 90% of $H_{\max}$ |
| **Pump Range ($MV_1$)** | `MV(1)` | 40% - 90% | Hard operational bounds |
| **Valve Range ($MV_2$)** | `MV(2)` | 30% - 100% | Hard operational bounds |
| **Horizons** | `PredictionHorizon`, `ControlHorizon` | $N_p = 75, N_c = 3$ | Prediction / Control windows |
| **Output Weights** | `Weights.OutputVariables` | $[0.4, 0.6]$ | Penalty on $h_1$ and $h_2$ tracking errors |
| **Rate Weights** | `Weights.ManipulatedVariablesRate` | $[5, 5]$ | Penalty on actuator rate of change |
| **Disturbance Model** | `setoutdist` | `'Integrators'` | Integrators on outputs for offset elimination |

---

## Usage

Run the script from the MATLAB Command Window before launching the main Simulink model:

```matlab
run('scripts/setup_mpc.m')
```
