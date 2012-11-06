$Title Tobacco

Sets
    i    Tobaccos      / A, B, C, D /
    j    Technologies  / T1, T2, T3 /
    k    Props         / Demand, Price / ;

Table UnitProdCosts(i, j) Unit production costs in zl per t
      T1     T2     T3
A   7600   7500   7300
B   8200   8000   7800
C   9600   9500   9200
D  10500  10400  10700 ;

Table TechEfficiency(i, j) Technologies efficiency in t per h
   T1  T2  T3
A  53  52  49
B  51  49  44
C  52  45  47
D  42  44  40 ;

Parameters
    a(i)  monthly demand for tobacco type in t
    /   A  30000
        B  20000
        C  12000
        D   8000  /
    b(i)  price for tobacco type in zl per t
    /   A   77000
        B   81000
        C   99000
        D  105000  /
    c(j)  monthly available machine time in h
    /   T1  672
        T2  600
        T3  480  / ;

Variables
  x(i, j)  production volume of tobacco type i in technology j
  pro      total net profit

Positive variable x

Equations
  profit         monthly net profit
  production(j)  monthly production limits for technology j
  demand(i)      monthly demand for tobacco i ;

profit..  pro =E= sum(i, sum(j, x(i, j) * (b(i) - UnitProdCosts(i, j)))) * 0.11 * 0.85 ;
production(j)..  sum(i, x(i, j) / TechEfficiency(i, j)) =L= c(j) ;
demand(i)..  sum(j, x(i, j)) =L= a(i) ;

Model TobaccoSol /all/ ;
Solve TobaccoSol maximizing pro using LP ;
Display x.l, x.m, pro.l, pro.m ;
