# Model Predictive Control (MPC) of a Two-Tank Cascade System (2x2 MIMO)

Projekt / Praca magisterska dotycząca projektowania, syntezy i weryfikacji symulacyjnej zaawansowanego regulatora predykcyjnego (MPC) dla nieliniowego obiektu kaskady dwóch zbiorników z uwzględnieniem ograniczeń fizycznych oraz dynamiki elementów wykonawczych.

---

## O projekcie

Głównym celem układu regulacji jest precyzyjna stabilizacja oraz śledzenie wartości zadanej poziomów cieczy ($h_1, h_2$) w kaskadzie zbiorników. 

**Kluczowe wyzwania i cechy układu:**
- **Struktura MIMO $2 \times 2$:** Jednoczesna kontrola wydajności pompy ($MV_1$) oraz stopnia otwarcia elektrozaworu ($MV_2$) z uwzględnieniem sprzężeń skrośnych.
- **Nieliniowości fizyczne:** Uwzględnienie ograniczeń nasycenia pompy, strefy nieczułości zaworu (luz $\pm \Delta u / 2$) oraz równań przepływu Torricellego.
- **Bezpieczeństwo i wykonalność:** Zastosowanie miękkich ograniczeń z zmiennymi swobodnymi ($ECR$) zapobiegających brakowi rozwiązań zadania optymalizacji kwadratowej (QP solver infeasibility).
- **Bezustaleniowość:** Wykorzystanie wbudowanych całkowników zakłóceń wyjściowych zapewniających zerowy uchyb w stanie ustalonym.

---

## Wymagania środowiskowe i Toolboxy

Projekt został stworzony i przetestowany w środowisku **MATLAB R2024a**.

### Wymagane Toolboxy:
- **MATLAB** (R2024a)
- **Simulink** – środowisko do uruchamiania schematu blokowego symulacji.
- **Model Predictive Control Toolbox** – synteza obiektu regulatora (`mpc`), konfigurowanie horyzontów predykcji/sterowania, wag oraz estymatorów.
- **Control System Toolbox** – reprezentacja zlinearyzowanego obiektu w przestrzeni stanów (`ss`).
- **Optimization Toolbox** – wykorzystywany wewnętrznie przez regulator MPC do rozwiązywania zadania optymalizacji kwadratowej (QP) w czasie rzeczywistym.

---

## Struktura repozytorium

├── models/
│   └── two_tank_cascade_mpc.slx   # Główny model symulacyjny w Simulinku
├── scripts/
│   ├── setup_mpc.m                # Skrypt inicjalizujący parametry i regulator MPC
│   └── README.md                  # Szczegółowy opis działania skryptów
└── README.md                      # Główna dokumentacja projektu
