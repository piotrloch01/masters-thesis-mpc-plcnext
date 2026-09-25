# Sterowanie Predykcyjne (MPC) Kaskady Dwóch Zbiorników (MIMO 2x2)

> *English version of the documentation is available in [README.md](README.md).*

Repozytorium zawiera pełną implementację techniczną, modele symulacyjne oraz skrypty konfiguracyjne stworzone w ramach pracy magisterskiej. Projekt dotyczy projektowania, strojenia oraz ewaluacji zaawansowanego regulatora predykcyjnego (MPC) dla nieliniowego układu kaskady dwóch zbiorników z uwzględnieniem ograniczeń fizycznych i dynamiki elementów wykonawczych.

---

## Opis projektu

Głównym celem regulacji jest precyzyjna stabilizacja oraz śledzenie wartości zadanych poziomów cieczy ($h_1, h_2$) w kaskadzie dwóch zbiorników przy zachowaniu stabilności układu i pracy wewnątrz rygorystycznych ograniczeń fizycznych.

### Kluczowe cechy i wyzwania
- **Struktura MIMO $2 \times 2$:** Jednoczesne sterowanie wydajnością pompy ($MV_1$) oraz stopniem otwarcia elektrozaworu ($MV_2$) z pełną kompensacją sprzężeń skrośnych.
- **Nieliniowości fizyczne:** Jawne uwzględnienie nieliniowych równań bilansu masy, nasycenia pompy oraz strefy nieczułości/luzu zaworu ($\pm \Delta u / 2$).
- **Obsługa ograniczeń:** Twarde ograniczenia sygnałów wejściowych połączone z miękkimi ograniczeniami stanów oraz dynamiki zmian (narostów) z wykorzystaniem zmiennych swobodnych ECR (Equal Concern Relaxation), zapobiegające brakowi rozwiązań problemu QP przy niepomiarkowanych zakłóceniach.
- **Bezustaleniowość (Offset-Free Tracking):** Wykorzystanie całkujących modeli zakłóceń wyjściowych (`setoutdist`), zapewniające zerowy uchyb w stanie ustalonym w przypadku niedokładności modelu.

---

## Wymagania środowiskowe i Toolboxy

Projekt został opracowany i przetestowany w środowisku **MATLAB R2024a**.

### Wymagane Toolboxy:
- **MATLAB** (R2024a lub nowszy)
- **Simulink** – środowisko blokowe do symulacji układów dynamicznych.
- **Model Predictive Control Toolbox** – definicja obiektu MPC (`mpc`), dobór horyzontów predykcji i sterowania, macierzy wag oraz konfigurowanie modeli zakłóceń.
- **Control System Toolbox** – reprezentacja liniowego modelu w przestrzeni stanów (`ss`).
- **Optimization Toolbox** – silnik rozwiązywania zadania optymalizacji kwadratowej (QP) w czasie rzeczywistym.

---

## Struktura repozytorium

```text
├── models/
│   ├── two_tank_cascade_mpc.slx   # Główny model symulacyjny w Simulinku
│   ├── README.md                  # Dokumentacja modeli (angielski)
│   └── README_PL.md               # Dokumentacja modeli (polski)
├── scripts/
│   ├── setup_mpc.m                # Główny skrypt inicjalizujący parametry MPC
│   ├── README.md                  # Dokumentacja skryptów (angielski)
│   └── README_PL.md               # Dokumentacja skryptów (polski)
├── README_PL.md                   # Główna dokumentacja repozytorium (polski)
└── README.md                      # Główna dokumentacja repozytorium (angielski)
```

### Opis katalogów:
- **`scripts/`**: Zawiera skrypt `setup_mpc.m`, który definiuje dyskretne macierze przestrzeni stanów obiektu, ustawia horyzonty ($N_p = 75$, $N_c = 3$), wagi ($Q$, $R$), czynniki skalujące oraz zmienne swobodne ECR. Skrypt ten musi zostać uruchomiony przed włączeniem symulacji w Simulinku. Szczegółowy opis skryptów znajduje się w pliku [`scripts/README_PL.md`](scripts/README_PL.md) (lub [`scripts/README.md`](scripts/README.md)).
- **`models/`**: Zawiera kompletny schemat Simulinka łączący nieliniowy obiekt kaskady dwóch zbiorników, blok strefy nieczułości zaworu oraz blok regulatora MPC. Szczegółowy opis schematu blokowego znajduje się w pliku [`models/README_PL.md`](models/README_PL.md) (lub [`models/README.md`](models/README.md)).

---

## Szybki start

1. Sklonuj repozytorium:
   ```bash
   git clone [https://github.com/piotrloch01/two-tank-cascade-mpc.git](https://github.com/piotrloch01/two-tank-cascade-mpc.git)
   ```
2. Otwórz **MATLAB R2024a** i ustaw katalog projektu jako bieżący folder roboczy (`Workspace`).
3. Uruchom skrypt konfiguracyjny, aby załadować obiekt regulatora (`mpc_obj`) oraz wektor stanu (`xmpc`) do przestrzeni roboczej:
   ```matlab
   run('scripts/setup_mpc.m')
   ```
4. Otwórz i uruchom model symulacyjny:
   ```matlab
   open('models/two_tank_cascade_mpc.slx')
   ```

---

## Licencja

Projekt udostępniany na licencji **MIT License**. Szczegóły znajdują się w pliku `LICENSE`.
