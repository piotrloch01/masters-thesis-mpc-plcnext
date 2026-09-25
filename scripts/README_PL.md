# Dokumentacja Skryptów Konfiguracyjnych

> Angielska wersja dokumentacji skryptów dostępna jest w pliku [README.md](README.md).

Katalog ten zawiera główny skrypt inicjalizujący `setup_mpc.m`, którego zadaniem jest skonstruowanie, skonfigurowanie i sparametryzowanie obiektu regulatora predykcyjnego (`mpc_obj`) oraz jego stanu (`xmpc`) w przestrzeni roboczej programu MATLAB przed uruchomieniem symulacji w Simulinku.

---

## Szczegółowy opis skryptu `setup_mpc.m`

Skrypt realizuje następującą sekwencję konfiguracji:

1. **Definicja parametrów fizycznych i czasowych**
   - Ustawienie okresu próbkowania $T_s = 0.5\text{ s}$.
   - Zdefiniowanie geometrii zbiorników ($H_{\max} = 0.382\text{ m}$, powierzchnia przekroju $A_t = 0.0222\text{ m}^2$).

2. **Model obiektu w przestrzeni stanów**
   - Wczytanie zdyskretyzowanych macierzy stanów ($A_d, B_d, C_d, D_d$).
   - Stworzenie dyskretnego obiektu LTI: `plant_d = ss(Ad, Bd, Cd, Dd, Ts)`.

3. **Inicjalizacja i skalowanie regulatora MPC**
   - Utworzenie obiektu `mpc_obj = mpc(plant_d, Ts)`.
   - Zdefiniowanie czynników skalujących (`ScaleFactor`) na podstawie zakresu operacyjnego zmiennych regulowanych (OV) i sterujących (MV) w celu poprawy uwarunkowania numerycznego solvera QP.

4. **Konfiguracja ograniczeń i miękkich granic (ECR)**
   - **Sygnały wyjściowe ($OV_1, OV_2$):** Ograniczenie poziomów w zakresie od 15% do 90% wysokości maksymalnej $H_{\max}$ z łagodnymi zmiennymi swobodnymi ECR (`MinECR = 0.02`, `MaxECR = 0.02`), gwarantującymi wykonalność optymalizacji QP w obecności zakłóceń.
   - **Sygnały sterujące ($MV_1, MV_2$):** Twarde ograniczenia fizyczne pompy ($40 \le u_p \le 90$) oraz zaworu ($30 \le u_v \le 100$).
   - **Szybkości zmian sterowań:** Ograniczenie narostów sygnałów sterujących ($\Delta u_p, \Delta u_v$) wraz z tolerancjami ECR w celu uwzględnienia bezwładności elementów wykonawczych.

5. **Horyzonty i wagi funkcji celu**
   - **Horyzont predykcji ($N_p$):** 75 kroków ($37.5\text{ s}$).
   - **Horyzont sterowania ($N_c$):** 3 kroki ($1.5\text{ s}$).
   - **Wagi:** $Q_{OV} = [0.4, 0.6]$ (wyższy priorytet śledzenia poziomu $h_2$), $R_{\Delta u} = [5, 5]$ (tłumienie gwałtownych ruchów elementów wykonawczych), $R_u = [0, 0]$.

6. **Eliminacja uchybu i stan początkowy**
   - Dołączenie całkujących modeli zakłóceń wyjściowych poleceniem `setoutdist(mpc_obj, 'Integrators')`, zapewniające zerowy uchyb w stanie ustalonym.
   - Utworzenie wektora stanu `xmpc` i ustawienie początkowych poziomów ($0.5 H_{\max}$) oraz początkowych wartości sterowań ($MV_1 = 65, MV_2 = 70$).

---

## Podsumowanie parametrów regulatora

| Parametr | Identyfikator w kodzie | Wartość / Ustawienie | Opis |
| :--- | :--- | :--- | :--- |
| **Okres próbkowania** | `Ts` | $0.5\text{ s}$ | Czas dyskretyzacji i pracy regulatora |
| **Zakres poziomów** | `OV(1)`, `OV(2)` | $[0.0573, 0.3438]\text{ m}$ | Od 15% do 90% wysokości $H_{\max}$ |
| **Zakres pompy ($MV_1$)** | `MV(1)` | 40% - 90% | Twarde ograniczenie zakresu pracy |
| **Zakres zaworu ($MV_2$)** | `MV(2)` | 30% - 100% | Twarde ograniczenie zakresu pracy |
| **Horyzonty** | `PredictionHorizon`, `ControlHorizon` | $N_p = 75, N_c = 3$ | Okna predykcji i sterowania |
| **Wagi wyjść** | `Weights.OutputVariables` | $[0.4, 0.6]$ | Priorytet śledzenia wartości zadanej $h_1$ oraz $h_2$ |
| **Wagi narostów** | `Weights.ManipulatedVariablesRate` | $[5, 5]$ | Kara za dynamikę zmian sygnałów sterujących |
| **Model zakłóceń** | `setoutdist` | `'Integrators'` | Integratory na wyjściach eliminujące uchyb |

---

## Uruchomienie

Przed włączeniem symulacji w Simulinku skrypt należy wykonać z poziomu okna poleceń programu MATLAB:

```matlab
run('scripts/setup_mpc.m')
```
