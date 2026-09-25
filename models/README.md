## Simulink Model Architecture

The simulation model implements an Adaptive Model Predictive Control (MPC) algorithm for a nonlinear two-tank system. The structure consists of three main components: the nonlinear plant model, the online linearization block, and the predictive controller.

### 1. Nonlinear Plant Model (`obiekt regulacji`)
* **Operation:** Contains a MATLAB Function `model_obiektu` simulating the real MIMO system dynamics. It calculates the volume balance based on nonlinear polynomial approximations for pump flow, valve flow, and gravity outflow.
* **Inputs:** Current liquid levels (`h1`, `h2`), control signals from the controller (`u_p`, `y_v`), and simulation time (`t`).
* **Outputs:** Liquid level derivatives (`dh1`, `dh2`), which are integrated in continuous time by `1/s` blocks to obtain current state values.

### 2. Online Linearization (`linearyzacja modelu matematycznego`)
* **Operation:** The `linearyzacja_modelu` function analytically calculates continuous-time Jacobian matrices for the current operating point.
* **Discretization:** The calculated continuous-time matrices are discretized using the forward Euler method with a sampling time of Ts = 0.5 s.
* **MPC Integration:** The block generates state-space matrices (`A`, `B`, `C`, `D`) and nominal operating point vectors (`U`, `Y`, `X`, `DX`), which are grouped and fed into the `model` port of the Adaptive MPC controller.

### 3. Adaptive MPC and Signal Routing
* **Controller Inputs:** The block receives setpoint references (from Step blocks), currently measured variables (`h1`, `h2`), and the updated linear model.
* **Outputs and Constraints:** The manipulated variable signal is split into pump control (`u_p`) and valve control (`u_v`). The valve control path includes saturation and rate limiter blocks to simulate the mechanical inertia of the actuator.
* **Operating Modes:** The model features a Manual Switch allowing transitions between closed-loop operation (MPC control) and open-loop operation (constant pump input at 65, valve at 70).
