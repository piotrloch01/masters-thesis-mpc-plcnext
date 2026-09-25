## Architektura modelu w Simulinku

Model symulacyjny realizuje algorytm sterowania predykcyjnego z adaptacją (Adaptive MPC) dla nieliniowego układu dwóch połączonych zbiorników cieczy. Struktura opiera się na trzech głównych komponentach: nieliniowym modelu fizycznym, bloku linearyzacji on-line oraz regulatorze predykcyjnym.

### 1. Nieliniowy model obiektu (`obiekt regulacji`)
* **Zasada działania:** Blok zawiera funkcję MATLABa `model_obiektu` symulującą rzeczywistą dynamikę układu wielowymiarowego. Oblicza bilans objętościowy na podstawie nieliniowych wielomianów aproksymujących charakterystyki przepływów.
* **Wejścia:** Aktualne poziomy cieczy (`h1`, `h2`), sygnały sterujące (`u_p`, `y_v`) oraz czas symulacji (`t`).
* **Wyjścia:** Pochodne poziomów cieczy (`dh1`, `dh2`), które są następnie całkowane w czasie ciągłym przez bloki `1/s` w celu uzyskania bieżących wartości stanów.

### 2. Linearyzacja on-line (`linearyzacja modelu matematycznego`)
* **Zasada działania:** Funkcja `linearyzacja_modelu` analitycznie wylicza macierze Jacobiego dla aktualnego punktu pracy obiektu.
* **Dyskretyzacja:** Wyliczone macierze czasu ciągłego są dyskretyzowane metodą Eulera w przód z krokiem próbkowania Ts = 0.5 s.
* **Integracja z MPC:** Blok generuje kompletny zestaw macierzy przestrzeni stanów (`A`, `B`, `C`, `D`) oraz wektory wartości nominalnych (`U`, `Y`, `X`, `DX`), które są grupowane i przekazywane na wejście `model` regulatora Adaptive MPC.

### 3. Regulator Adaptive MPC i tory sygnałowe
* **Wejścia regulatora:** Blok przyjmuje sygnały wartości zadanych (z bloków Step), aktualnie zmierzone wartości regulowane (`h1`, `h2`) oraz zaktualizowany model liniowy z bloku linearyzacji.
* **Wyjścia i ograniczenia:** Wypracowany sygnał sterujący rozdziela się na sterowanie pompą (`u_p`) i zaworem (`u_v`). W torze zaworu zastosowano bloki nasycenia oraz ogranicznika szybkości zmian (Rate Limiter), co symuluje rzeczywistą bezwładność mechaniczną tego elementu.
* **Tryby pracy:** Model wyposażono w ręczny przełącznik (Manual Switch), który pozwala na przechodzenie między pracą w pętli zamkniętej (sterowanie z MPC) a pracą w pętli otwartej (stałe wysterowanie: pompa 65, zawór 70).
