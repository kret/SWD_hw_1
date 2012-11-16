$Title Tobacco
* Author: Andrzej Undziłło (s4694)

Sets
    tb    Tobaccos      / A, B, C, D /
    tk    Technologies  / T1, T2, T3 / ;

Table UnitProdCosts(tb, tk)  Unit production costs in zl per t
      T1     T2     T3
A   7600   7500   7300
B   8200   8000   7800
C   9600   9500   9200
D  10500  10400  10700 ;

Table TechEfficiency(tb, tk)  Technologies efficiency in t per h
   T1  T2  T3
A  53  52  49
B  51  49  44
C  52  45  47
D  42  44  40 ;

Parameters
    DemandFor(tb)  monthly demand for tobacco type in t
    /   A  30000
        B  20000
        C  12000
        D   8000  /
    PriceFor(tb)  price for tobacco type in zl per t
    /   A   77000
        B   81000
        C   99000
        D  105000  /
    MachineAvailability(tk)  monthly available machine time in h
    /   T1  672
        T2  600
        T3  480  / ;

Variables
  x(tb, tk)  production volume of tobacco type tb in technology tk
  p          total profit before tax ;

Positive variable x ;

Equations
  profit          monthly profit before tax - objective
  production(tk)  monthly production limits for technology tk
  demand(tb)      monthly demand for tobacco tb ;

profit         ..  p =E= sum(tb, sum(tk, x(tb, tk) * (PriceFor(tb) - UnitProdCosts(tb, tk)))) ;
production(tk) ..        sum(tb, x(tb, tk) / TechEfficiency(tb, tk)) =L= MachineAvailability(tk) ;
demand(tb)     ..        sum(tk, x(tb, tk)) =L= DemandFor(tb) ;

Model Tobacco / all / ;

* * * * * * * * * * * * * * * * * * * * *
* Configure sensitivity analysis options
*
$onecho > cplex.opt
  objrng x
  rhsrng production
  rhsrng demand
  rngrestart rng.gms
$offecho
* * * * * * * * * * * * * * * * * * * * *

Option LP=CPLEX ;
Tobacco.OptFile=1 ;
Solve Tobacco maximizing p using LP ;


* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* Magic spells to get programatic access to sensitivity analysis data
*
Set uplo / lo, up / ;
Parameter
  productionRNG(tk, uplo)
  demandRNG(tb, uplo)
  xRNG(tb, tk, uplo) ;

Execute 'gams rng.gms lo=%gams.lo% gdx=rng.gdx' ;
Abort$errorlevel 'Problems creating rng.gdx' ;
Execute_load 'rng.gdx' productionRNG, demandRNG, xRNG ;
*
* Magic spells END
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Parameter ProfitAfterTax  monthly net profit;
ProfitAfterTax = p.L * 0.11 * 0.85 ;



Parameter CostPercentage(tb, tk)  difference between given costs and maximal non-result-changing costs, in percents ;
CostPercentage(tb, tk) = (PriceFor(tb) - xRNG(tb, tk, 'lo')) / UnitProdCosts(tb, tk) * 100 - 100 ;

* Display results
Display x.L, ProfitAfterTax, CostPercentage ;
