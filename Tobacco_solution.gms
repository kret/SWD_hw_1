$Title Tobacco

Sets
    tb    Tobaccos      / A, B, C, D /
    tk    Technologies  / T1, T2, T3 / ;

Table UnitProdCosts(tb, tk) Unit production costs in zl per t
      T1     T2     T3
A   7600   7500   7300
B   8200   8000   7800
C   9600   9500   9200
D  10500  10400  10700 ;

Table TechEfficiency(tb, tk) Technologies efficiency in t per h
   T1  T2  T3
A  53  52  49
B  51  49  44
C  52  45  47
D  42  44  40 ;

Parameters
    Dem(tb)  monthly demand for tobacco type in t
    /   A  30000
        B  20000
        C  12000
        D   8000  /
    Pri(tb)  price for tobacco type in zl per t
    /   A   77000
        B   81000
        C   99000
        D  105000  /
    Ava(tk)  monthly available machine time in h
    /   T1  672
        T2  600
        T3  480  / ;

Variables
  x(tb, tk)  production volume of tobacco type tb in technology tk
  p          total net profit ;

Positive variable x ;

Equations
  profit          monthly net profit
  production(tk)  monthly production limits for technology tk
  demand(tb)      monthly demand for tobacco tb ;

profit ..  p =E= sum(tb, sum(tk, x(tb, tk) * (Pri(tb) - UnitProdCosts(tb, tk)))) * 0.11 * 0.85 ;
production(tk) ..  sum(tb, x(tb, tk) / TechEfficiency(tb, tk)) =L= Ava(tk) ;
demand(tb) ..  sum(tk, x(tb, tk)) =L= Dem(tb) ;

Model Tobacco /all/ ;
Solve Tobacco maximizing p using LP ;
Display x.L, x.M, p.L, p.M ;
