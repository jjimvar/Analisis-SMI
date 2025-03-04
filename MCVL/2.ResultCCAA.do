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
***Comunidad
gen comunidad = .
replace comunidad = 1 if inlist(prov, 1, 20, 48) // País Vasco
replace comunidad = 2 if inlist(prov, 2, 13, 16, 19, 45) // Castilla-La Mancha
replace comunidad = 3 if inlist(prov, 3, 12, 46) // Comunidad Valenciana
replace comunidad = 4 if inlist(prov, 4, 11, 14, 18, 21, 23, 29, 41) // Andalucía
replace comunidad = 5 if inlist(prov, 5, 9, 24, 34, 37, 40, 42, 47, 49) // Castilla y León
replace comunidad = 6 if inlist(prov, 6, 10) // Extremadura
replace comunidad = 7 if inlist(prov, 7) // Islas Baleares
replace comunidad = 8 if inlist(prov, 8, 17, 25, 43) // Cataluña
replace comunidad = 9 if inlist(prov, 15, 27, 32, 36) // Galicia
replace comunidad = 10 if inlist(prov, 28) // Comunidad de Madrid
replace comunidad = 11 if inlist(prov, 30) // Región de Murcia
replace comunidad = 12 if inlist(prov, 31) // Navarra
replace comunidad = 13 if inlist(prov, 33) // Asturias
replace comunidad = 14 if inlist(prov, 35, 38) // Canarias
replace comunidad = 15 if inlist(prov, 39) // Cantabria
replace comunidad = 16 if inlist(prov, 22, 44, 50) // Aragón
replace comunidad = 17 if inlist(prov, 26) // La Rioja
replace comunidad = 18 if inlist(prov, 51, 52) // Ceuta y Melilla

label define com 1 "Andalucia" 2 "Aragon" 3 "Principado de Asturias" 4 "Islas Baleares" 5 "Islas Canarias" 6 "Cantabria" 7 "Castilla y Leon" 8 "Castilla-La Mancha" 9 "Cataluna" 10 "Comunidad Valenciana" 11 "Extremadura" 12 "Galicia" 13 "Comunidad de Madrid" 14 "Region de Murcia" 15 "Navarra" 16 "Pais Vasco" 17 "La Rioja" 18 "Ceuta y Melilla"
label values comunidad com

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
est use logitccaa
predict ylogitccaa
qui sum ylogitccaa
scalar mean_ylogitccaa = r(mean)
scalar sd_ylogitccaa = r(sd)
scalar min_ylogitccaa = r(min)
scalar max_ylogitccaa = r(max)
scalar obs_ylogitccaa = r(N)
*Modelo2
est use cvccaa
predict ycvccaa
qui sum ycvccaa
scalar mean_ycvccaa = r(mean)
scalar sd_ycvccaa = r(sd)
scalar min_ycvccaa = r(min)
scalar max_ycvccaa = r(max)
scalar obs_ycvccaa = r(N)
*Modelo3
est use bicccaa
predict ybicccaa
qui sum ybicccaa
scalar mean_ybicccaa = r(mean)
scalar sd_ybicccaa = r(sd)
scalar min_ybicccaa = r(min)
scalar max_ybicccaa = r(max)
scalar obs_ybicccaa = r(N)

*Crear una matriz con los resultados
matrix pred = ( ///
    sd_afecta, sd_ylogitccaa, sd_ycvccaa ,sd_ybicccaa\ ///
    min_afecta, min_ylogitccaa, min_ycvccaa, min_ybicccaa\ ///
    max_afecta, max_ylogitccaa, max_ycvccaa, max_ybicccaa\ ///
    mean_afecta, mean_ylogitccaa, mean_ycvccaa, mean_ybicccaa\ ///
    obs_afecta, obs_ylogitccaa, obs_ycvccaa, obs_ybicccaa)
	
matrix colnames pred= "Prob[Afectado]" "Logit" "Lasso CV" "Lasso BIC" 
matrix rownames pred= "Std. Dev." "Min" "Max" "Mean" "Obs"

putexcel set 2.ResultadosCCAA.xlsx, sheet(Predicciones, replace) modify
putexcel A1=matrix(pred), nformat(number_d2) names

*******************************MATRIZ DE CONFUSIÓN******************************
********************************************************************************
*Modelo1
gen pafecta_logitccaa=0
replace pafecta_logitccaa=1 if ylogitccaa>=0.2025
**Verdaderos Positivos y Falsos Positivos
count if afecta==1 & pafecta_logitccaa==1
scalar vp_logitccaa=r(N)
count if afecta==1
scalar tp_logitccaa=r(N)
scalar sens_logitccaa=(vp_logitccaa/tp_logitccaa)*100
scalar falpos_logitccaa=100-sens_logitccaa
**Verdaderos Negativos y Falsos Negativos
count if afecta==0 & pafecta_logitccaa==0
scalar vn_logitccaa=r(N)
count if afecta==0
scalar tn_logitccaa=r(N)
scalar espe_logitccaa=(vn_logitccaa/tn_logitccaa)*100
scalar falneg_logitccaa=100-espe_logitccaa
**Clasificados correctamente
scalar correct_logitccaa=(vp_logitccaa+vn_logitccaa)/(tp_logitccaa+tn_logitccaa)*100

*Modelo2
gen pafecta_cvccaa=0
replace pafecta_cvccaa=1 if ycvccaa>=0.2025
**Verdaderos Positivos y Falsos Positivos
count if afecta==1 & pafecta_cvccaa==1
scalar vp_cvccaa=r(N)
count if afecta==1
scalar tp_cvccaa=r(N)
scalar sens_cvccaa=(vp_cvccaa/tp_cvccaa)*100
scalar falpos_cvccaa=100-sens_cvccaa
**Verdaderos Negativos y Falsos Negativos
count if afecta==0 & pafecta_cvccaa==0
scalar vn_cvccaa=r(N)
count if afecta==0
scalar tn_cvccaa=r(N)
scalar espe_cvccaa=(vn_cvccaa/tn_cvccaa)*100
scalar falneg_cvccaa=100-espe_cvccaa
**Clasificados correctamente
scalar correct_cvccaa=(vp_cvccaa+vn_cvccaa)/(tp_cvccaa+tn_cvccaa)*100

*Modelo3
gen pafecta_bicccaa=0
replace pafecta_bicccaa=1 if ybicccaa>=0.2025
**Verdaderos Positivos y Falsos Positivos
count if afecta==1 & pafecta_bicccaa==1
scalar vp_bicccaa=r(N)
count if afecta==1
scalar tp_bicccaa=r(N)
scalar sens_bicccaa=(vp_bicccaa/tp_bicccaa)*100
scalar falpos_bicccaa=100-sens_bicccaa
**Verdaderos Negativos y Falsos Negativos
count if afecta==0 & pafecta_bicccaa==0
scalar vn_bicccaa=r(N)
count if afecta==0
scalar tn_bicccaa=r(N)
scalar espe_bicccaa=(vn_bicccaa/tn_bicccaa)*100
scalar falneg_bicccaa=100-espe_bicccaa
**Clasificados correctamente
scalar correct_bicccaa=(vp_bicccaa+vn_bicccaa)/(tp_bicccaa+tn_bicccaa)*100

**Guardamos los resultados
matrix confusion = ( ///
    sens_logitccaa, sens_cvccaa, sens_bicccaa\ ///
    falpos_logitccaa, falpos_cvccaa, falpos_bicccaa\ ///
    espe_logitccaa, espe_cvccaa, espe_bicccaa\ ///
    falneg_logitccaa, falneg_cvccaa, falneg_bicccaa\ ///
    correct_logitccaa, correct_cvccaa, correct_bicccaa)

matrix colnames confusion= "Logit" "Lasso CV" "Lasso BIC"
matrix rownames confusion= "Sensibilidad [Verdaderos positivos]" "Falsos Positivos" "Especificidad [Verdaderos negativos]" "Falsos Negativos" "Clasificado Correctamente"
	
putexcel set 2.ResultadosCCAA.xlsx, sheet(Confusion, replace) modify
putexcel A1=matrix(confusion), nformat(number_d2) names
restore

*******************************LASSO GOF****************************************
********************************************************************************
*Resumen de los modelos:
est use logitccaa.ster
est store logitccaa
est use cvccaa.ster
est store cvccaa
est use bicccaa.ster
est store bicccaa
lassogof logitccaa cvccaa bicccaa, over(train)
*Exportamos resultados
matrix result=r(table)
matrix lassogof = (result[1,1..3] \ result[3,1..3] \ result[5,1..3])'
matrix colnames lassogof="Logit" "Lasso CV" "Lasso BIC"
matrix rownames lassogof="Desviance" "Desv Ratio" "N Obs"

putexcel set 2.ResultadosCCAA.xlsx, sheet(Lassogof, replace) modify
putexcel A1=matrix(lassogof), nformat(number_d2) names