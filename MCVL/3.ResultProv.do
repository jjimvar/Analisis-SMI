cd "C:\Users\Usuario\OneDrive\Escritorio\4to GANE\TFG\MCVL"
*cd "C:\Users\Jjime\OneDrive\Escritorio\4to GANE\TFG\MCVL"
use "panel-individuos-empresas-2018.dta", clear

*******************************Configuración inicial****************************
********************************************************************************
drop maxcotmesl mincotmesl mincotmesg1 mincotmesg2 mincotmesg3 causabaja actividadcuentav ccc2_empresa ccc1_empresa edadempresa1 edadempresa2
rename mwageamest s18

*Reconfiguracion valores smi
replace smi18=smi18/12
replace smi19=smi19/12
*Eliminamos valores extranos
egen w99=pctile(mwageames), p(01)
keep if mwageames>w99

*Generamos variable fundamental
gen afecta=0
replace afecta=1 if s18<smi19*1.025


*Variables simples: Homgeneizacion frente a EPA
**Sexo
rename sexo hombre
replace hombre=0 if hombre==2

**Edad
rename edad edadempresa //Creemos que es la edad empresa
gen edad=year-anonac+1
gen edad5 = .
replace edad5 = 1 if edad >= 16 & edad <= 19
replace edad5 = 2 if edad >= 20 & edad <= 24
replace edad5 = 3 if edad >= 25 & edad <= 29
replace edad5 = 4 if edad >= 30 & edad <= 34
replace edad5 = 5 if edad >= 35 & edad <= 39
replace edad5 = 6 if edad >= 40 & edad <= 44
replace edad5 = 7 if edad >= 45 & edad <= 49
replace edad5 = 8 if edad >= 50 & edad <= 54
replace edad5 = 9 if edad >= 55 & edad <= 59
replace edad5 = 10 if edad >= 60 & edad <= 64
replace edad5 = 11 if edad >= 65
label define e5 1 "16 a 19 anos" 2 "20 a 24 anos" 3 "25 a 29 anos" 4 "30 a 34 anos" 5 "35 a 39 anos" 6 "40 a 44 anos" 7 "45 a 49 anos" 8 "50 a 54 anos" 9 "55 a 59 anos" 10 "60 a 64 anos" 11 "65 o mas anos"
label values edad5 e5

**Zona geográfica
***Provincia
gen prov=provcuentacot2
label define prov_lbl 1 "Araba/Álava" 2 "Albacete" 3 "Alicante/Alacant" 4 "Almería" 5 "Ávila" ///
    6 "Badajoz" 7 "Balears, Illes" 8 "Barcelona" 9 "Burgos" 10 "Cáceres" 11 "Cádiz" 12 "Castellón /Castelló" ///
    13 "Ciudad Real" 14 "Córdoba" 15 "Coruña, A" 16 "Cuenca" 17 "Girona" 18 "Granada" 19 "Guadalajara" ///
    20 "Gipuzkoa" 21 "Huelva" 22 "Huesca" 23 "Jaén" 24 "León" 25 "Lleida" 26 "Rioja, La" 27 "Lugo" ///
    28 "Madrid" 29 "Málaga" 30 "Murcia" 31 "Navarra" 32 "Ourense" 33 "Asturias" 34 "Palencia" ///
    35 "Palmas, Las" 36 "Pontevedra" 37 "Salamanca" 38 "Santa Cruz de Tenerife" 39 "Cantabria" 40 "Segovia" ///
    41 "Sevilla" 42 "Soria" 43 "Tarragona" 44 "Teruel" 45 "Toledo" 46 "Valencia/València" 47 "Valladolid" ///
    48 "Bizkaia" 49 "Zamora" 50 "Zaragoza" 51 "Ceuta" 52 "Melilla"

label values prov prov_lbl

**Variable pais de procedencia
gen paisnac = .
replace paisnac = 1 if paisnacim == 0
replace paisnac = 2 if inlist(paisnacim, 1, 10, 11, 15, 16, 19)
replace paisnac = 3 if inlist(paisnacim, 4, 14, 17, 20)
replace paisnac = 4 if inlist(paisnacim, 18, 21)
replace paisnac = 5 if inlist(paisnacim, 12, 23)
replace paisnac = 6 if paisnacim == 25
replace paisnac = 7 if inlist(paisnacim, 3, 6, 7, 8, 9, 13, 22, 26, 27)
replace paisnac = 8 if inlist(paisnacim, 5, 24)
label define pais 1 "Espana" 2 "UE-15" 3 "UE-27" 4 "Resto de Europa" 5 "africa" 6 "America del Norte" 7 "Centroamerica y Sudamerica" 8 "Asia y Oceania"
label values paisnac pais

*Nivel educativo
gen educ=.
replace educ=1 if inlist(niveleduca, 10, 11)
replace educ=2 if inlist(niveleduca, 20, 21, 22)
replace educ=3 if niveleduca==30
replace educ=4 if niveleduca==31
replace educ=5 if inlist(niveleduca, 40, 42)
replace educ=6 if inlist(niveleduca, 32, 41, 43, 47)
replace educ=7 if inlist(niveleduca, 44, 45, 46, 48)
label define nivelest 1 "Analfabeto" 2 "Primaria Incompleta" 3 "Primaria" 4 "Secundaria" 5 "Bachillerato" 6 "FP" 7 "Terciaria"
label values educ nivelest

**Relacion laboral (meses)
gen anobaja2=anobaja
replace anobaja2=2018 if anobaja>2018
gen mesbaja2=mesbaja
replace mesbaja2=12 if anobaja>2018
gen relab=((anobaja2-anoalta)*12)+(mesbaja2-mesalta)

*Variable continua cuadrática
gen relabsq=relab^2

*Eliminamos valores atípicos
keep if educ!=.
keep if comunidad!=.
keep if paisnac!=.

*Dividimos la base de datos
set seed 203
gen byte train=(runiform()<=0.6)
label define tr 1 "Train" 0 "Test"
label values train tr

*******************************VALORES ESTIMADOS********************************
********************************************************************************
preserve
keep if train==0 ///Trabajamos en la base de datos test: FUENTE DEL ML

*Valores Observados
qui sum afecta
scalar mean_afecta = r(mean)
scalar sd_afecta = r(sd)
scalar min_afecta = r(min)
scalar max_afecta = r(max)
scalar obs_afecta = r(N)
*Modelo1
est use logitprov
predict ylogitprov
qui sum ylogitprov
scalar mean_ylogitprov = r(mean)
scalar sd_ylogitprov = r(sd)
scalar min_ylogitprov = r(min)
scalar max_ylogitprov = r(max)
scalar obs_ylogitprov = r(N)
*Modelo2
est use cvprov
predict ycvprov
qui sum ycvprov
scalar mean_ycvprov = r(mean)
scalar sd_ycvprov = r(sd)
scalar min_ycvprov = r(min)
scalar max_ycvprov = r(max)
scalar obs_ycvprov = r(N)
*Modelo3
est use bicprov
predict ybicprov
qui sum ybicprov
scalar mean_ybicprov = r(mean)
scalar sd_ybicprov = r(sd)
scalar min_ybicprov = r(min)
scalar max_ybiprov = r(max)
scalar obs_ybiprov = r(N)

*Crear una matriz con los resultados
matrix pred = ( ///
    sd_afecta, sd_ylogitprov, sd_ycvprov ,sd_ybicprov\ ///
    min_afecta, min_ylogitprov, min_ycvprov, min_ybicprov\ ///
    max_afecta, max_ylogitprov, max_ycvprov, max_ybicprov\ ///
    mean_afecta, mean_ylogitprov, mean_ycvprov, mean_ybicprov\ ///
    obs_afecta, obs_ylogitprov, obs_ycvprov, obs_ybicprov)
	
matrix colnames pred= "Prob[Afectado]" "Logit" "Lasso CV" "Lasso BIC" 
matrix rownames pred= "Std. Dev." "Min" "Max" "Mean" "Obs"

putexcel set ResultadosProv.xlsx, sheet(Predicciones, replace) modify
putexcel A1=matrix(pred), nformat(number_d2) names

*******************************MATRIZ DE CONFUSIÓN******************************
********************************************************************************
*Modelo1
gen pafecta_logitprov=0
replace pafecta_logitprov=1 if ylogitprov>=0.2025
**Verdaderos Positivos y Falsos Positivos
count if afecta==1 & pafecta_logitprov==1
scalar vp_logitprov=r(N)
count if afecta==1
scalar tp_logitprov=r(N)
scalar sens_logitprov=(vp_logitprov/tp_logitprov)*100
scalar falpos_logitprov=100-sens_logitprov
**Verdaderos Negativos y Falsos Negativos
count if afecta==0 & pafecta_logitprov==0
scalar vn_logitprov=r(N)
count if afecta==0
scalar tn_logitprov=r(N)
scalar espe_logitprov=(vn_logitprov/tn_logitprov)*100
scalar falneg_logitprov=100-espe_logitprov
**Clasificados correctamente
scalar correct_logitprov=(vp_logitprov+vn_logitprov)/(tp_logitprov+tn_logitprov)*100

*Modelo2
gen pafecta_cvprov=0
replace pafecta_cvprov=1 if ycvprov>=0.2025
**Verdaderos Positivos y Falsos Positivos
count if afecta==1 & pafecta_cvprov==1
scalar vp_cvprov=r(N)
count if afecta==1
scalar tp_cvprov=r(N)
scalar sens_cvprov=(vp_cvprov/tp_cvprov)*100
scalar falpos_cvprov=100-sens_cvprov
**Verdaderos Negativos y Falsos Negativos
count if afecta==0 & pafecta_cvprov==0
scalar vn_cvprov=r(N)
count if afecta==0
scalar tn_cvprov=r(N)
scalar espe_cvprov=(vn_cvprov/tn_cvprov)*100
scalar falneg_cvprov=100-espe_cvprov
**Clasificados correctamente
scalar correct_cvprov=(vp_cvprov+vn_cvprov)/(tp_cvprov+tn_cvprov)*100

*Modelo3
gen pafecta_bicprov=0
replace pafecta_bicprov=1 if ybicprov>=0.2025
**Verdaderos Positivos y Falsos Positivos
count if afecta==1 & pafecta_bicprov==1
scalar vp_bicprov=r(N)
count if afecta==1
scalar tp_bicprov=r(N)
scalar sens_bicprov=(vp_bicprov/tp_bicprov)*100
scalar falpos_bicprov=100-sens_bicprov
**Verdaderos Negativos y Falsos Negativos
count if afecta==0 & pafecta_bicprov==0
scalar vn_bicprov=r(N)
count if afecta==0
scalar tn_bicprov=r(N)
scalar espe_bicprov=(vn_bicprov/tn_bicprov)*100
scalar falneg_bicprov=100-espe_bicprov
**Clasificados correctamente
scalar correct_bicprov=(vp_bicprov+vn_bicprov)/(tp_bicprov+tn_bicprov)*100

**Guardamos los resultados
matrix confusion = ( ///
    sens_logitprov, sens_cvprov, sens_bicprov\ ///
    falpos_logitprov, falpos_cvprov, falpos_bicprov\ ///
    espe_logitprov, espe_cvprov, espe_bicprov\ ///
    falneg_logitprov, falneg_cvprov, falneg_bicprov\ ///
    correct_logitprov, correct_cvprov, correct_bicprov)

matrix colnames confusion= "Logit" "Lasso CV" "Lasso BIC"
matrix rownames confusion= "Sensibilidad [Verdaderos positivos]" "Falsos Positivos" "Especificidad [Verdaderos negativos]" "Falsos Negativos" "Clasificado Correctamente"
	
putexcel set ResultadosProv.xlsx, sheet(Confusion, replace) modify
putexcel A1=matrix(confusion), nformat(number_d2) names
restore

*******************************LASSO GOF****************************************
********************************************************************************
*Resumen de los modelos:
est use logitprov.ster
est store logitprov
est use cvprov.ster
est store cvprov
est use bicprov.ster
est store bicprov
lassogof logitprov cvprov bicprov, over(train)
*Exportamos resultados
matrix result=r(table)
matrix lassogof = (result[1,1..3] \ result[3,1..3] \ result[5,1..3])'
matrix colnames lassogof="Logit" "Lasso CV" "Lasso BIC"
matrix rownames lassogof="Desviance" "Desv Ratio" "N Obs"

putexcel set ResultadosProv.xlsx, sheet(Lassogof, replace) modify
putexcel A1=matrix(lassogof), nformat(number_d2) names