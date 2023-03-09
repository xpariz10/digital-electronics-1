## Pre-Lab preparation

1. Write characteristic equations and complete truth tables for D, JK, T flip-flops where `q(n)` represents main output value before the clock edge and `q(n+1)` represents output value after the clock edge.

   ![Characteristic equations](images/eq_flip_flops.png)
   <!--
   https://editor.codecogs.com/

   \begin{align*}
   q_{n+1}^{D} =&~ d\\
   q_{n+1}^{T} =&~ t\cdot\overline{q_{n}} + \overline{t}\cdot q_{n}\\
   q_{n+1}^{JK} =&~ j\cdot\overline{q_{n}} + \overline{k}\cdot q_{n}\\
   \end{align*}

   -->
   
   **D-type FF**
   |             **clk**              | **d** | **q(n)** | **q(n+1)** | **Comments**                       |
   | :------------------------------: | :---: | :------: | :--------: | :--------------------------------- |
   | ![rising](Images/eq_uparrow.png) |   0   |    0     |     0      | `q(n+1)` has the same level as `d` |
   | ![rising](Images/eq_uparrow.png) |   0   |    1     |            |                                    |
   | ![rising](Images/eq_uparrow.png) |   1   |          |            |                                    |
   | ![rising](Images/eq_uparrow.png) |   1   |          |            |                                    |
   
   **JK-type FF**
   |             **clk**              | **j** | **k** | **q(n)** | **q(n+1)** | **Comments**          |
   | :------------------------------: | :---: | :---: | :------: | :--------: | :-------------------- |
   | ![rising](Images/eq_uparrow.png) |   0   |   0   |    0     |     0      | Output did not change |
   | ![rising](Images/eq_uparrow.png) |   0   |   0   |    1     |     1      | Output did not change |
   | ![rising](Images/eq_uparrow.png) |   0   |       |          |            |                       |
   | ![rising](Images/eq_uparrow.png) |   0   |       |          |            |                       |
   | ![rising](Images/eq_uparrow.png) |   1   |       |          |            |                       |
   | ![rising](Images/eq_uparrow.png) |   1   |       |          |            |                       |
   | ![rising](Images/eq_uparrow.png) |   1   |       |          |            |                       |
   | ![rising](Images/eq_uparrow.png) |   1   |       |          |            |                       |
   
   **T-type FF**
   |             **clk**              | **t** | **q(n)** | **q(n+1)** | **Comments**          |
   | :------------------------------: | :---: | :------: | :--------: | :-------------------- |
   | ![rising](Images/eq_uparrow.png) |   0   |    0     |     0      | Output did not change |
   | ![rising](Images/eq_uparrow.png) |   0   |    1     |            |                       |
   | ![rising](Images/eq_uparrow.png) |   1   |          |            |                       |
   | ![rising](Images/eq_uparrow.png) |   1   |          |            |                       |
