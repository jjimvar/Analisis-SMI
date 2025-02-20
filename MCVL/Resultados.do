*cd "C:\Users\Usuario\OneDrive\Escritorio\4to GANE\TFG\MCVL"
cd "C:\Users\Jjime\OneDrive\Escritorio\4to GANE\TFG\MCVL"
use "panel-individuos-empresas-2018.dta", clear

****************************0. Configuración inicial****************************
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

***************************1. Generacion de variables***************************
********************************************************************************
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

*Variables iteradas
global xiter1 (i.hombre i.edad5 i.comunidad i.paisnac i.educ)#(i.hombre i.edad5 i.comunidad i.paisnac i.educ) //Variables binarias
global xiter2 relab relabsq c.relab#(i.hombre i.edad5 i.comunidad i.paisnac i.educ) //Variables continuas

*Eliminamos valores atípicos
keep if educ!=.
keep if comunidad!=.
keep if paisnac!=.

*Dividimos la base de datos
set seed 203
gen train=(runiform()<=0.2)
label define tr 1 "Train" 0 "Test"
label values train tr

****************************ESTADÍSTICOS DESCRIPTIVOS***************************
********************************************************************************
*Variables continuas
foreach x in edad relab {
	qui sum `x', detail
	matrix `x'=(r(min)\r(p25)\r(p50)\r(p75)\r(max)\r(mean)\r(sd)\r(N))
}
matrix continua= edad,relab
matrix rownames continua= "Min" "Cuartil 1" "Cuartil 2" "Cuartil 3" "Max" "Media" ///
	"Desv Est" "N Obs"
matrix colnames continua= "Edad" "Permanencia Empresa"
putexcel set Resultados.xlsx, sheet(Est Continuas, replace) replace
putexcel A1=matrix(continua), names

*Variables categóricas
**Dummies
foreach y in afecta hombre {
	qui tab `y'
	scalar N = r(N)
	foreach n in 0 1 {
		qui count if `y' == `n'
		scalar sum`n' = r(N)
		scalar por`n' = r(N)/N*100
	}
	matrix `y'= (sum0, por0\sum1, por1\N, 100)
	matrix colname `y'= "Obs" "Pct"
}
matrix rowname afecta= "No Afectado" "Afectado" "Total"
matrix rowname hombre= "Mujer" "Hombre" "Total"

**Comunidad
qui tab comunidad
scalar N=r(N)
foreach n in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 {
	qui count if comunidad == `n'
	scalar sum`n'=r(N)
	scalar por`n' = r(N)/N*100	
}
matrix comunidad= (sum1, por1\sum2, por2\sum3, por3\sum4, por4\sum5, por5\sum6, por6\sum7, por7\sum8, por8\sum9, por9\sum10, por10\sum11, por11\sum12, por12\sum13, por13\sum14, por14\sum15, por15\sum16, por16\sum17, por17\sum18, por18\N, 100)
matrix colname comunidad= "Obs" "Pct"
matrix rownames comunidad= "Andalucia" "Aragon" "Principado de Asturias" "Islas Baleares" "Islas Canarias" "Cantabria" "Castilla y Leon" "Castilla-La Mancha" "Cataluna" "Comunidad Valenciana" "Extremadura" "Galicia" "Comunidad de Madrid" "Region de Murcia" "Navarra" "Pais Vasco" "La Rioja" "Ceuta y Melilla"

**Pais Nacimiento
qui tab paisnac
scalar N=r(N)
foreach n in 1 2 3 4 5 6 7 8 {
	qui count if paisnac == `n'
	scalar sum`n'=r(N)
	scalar por`n' = r(N)/N*100	
}
matrix paisnac= (sum1, por1\sum2, por2\sum3, por3\sum4, por4\sum5, por5\sum6, por6\sum7, por7\sum8, por8\ N, 100)
matrix colname paisnac= "Obs" "Pct"
matrix rownames paisnac= "Espana" "UE-15" "UE-27" "Resto de Europa" "africa" "America del Norte" "Centroamerica y Sudamerica" "Asia y Oceania"

**Nivel educativo
qui tab educ
scalar N=r(N)
foreach n in 1 2 3 4 5 6 7{
	qui count if educ == `n'
	scalar sum`n'=r(N)
	scalar por`n' = r(N)/N*100	
}
matrix educ= (sum1, por1\sum2, por2\sum3, por3\sum4, por4\sum5, por5\sum6, por6\sum7, por7\ N, 100)
matrix colname educ= "Obs" "Pct"
matrix rownames educ= "Analfabeto" "Primaria Incompleta" "Primaria" "Secundaria" "Bachillerato" "FP" "Terciaria"

*Exportamos resultados
foreach z in afecta hombre comunidad paisnac educ {
	putexcel set Resultados.xlsx, sheet(`z', replace) modify
	putexcel A1=matrix(`z'), names
}



*******************************VALORES ESTIMADOS********************************
********************************************************************************
preserve
keep if train==1

*Valores Observados
qui sum afecta
scalar mean_afecta = round(r(mean), 0.001)
scalar sd_afecta = round(r(sd), 0.001)
scalar min_afecta = round(r(min), 0.001)
scalar max_afecta = round(r(max), 0.001)
scalar obs_afecta = r(N)
*Modelo1
est use plugin
predict yplugin
qui sum yplugin
scalar mean_yplugin = round(r(mean), 0.001)
scalar sd_yplugin = round(r(sd), 0.001)
scalar min_yplugin = round(r(min), 0.001)
scalar max_yplugin = round(r(max), 0.001)
scalar obs_yplugin = r(N)
*Modelo2
est use logitccaa
predict ylogitccaa
qui sum ylogitccaa
scalar mean_ylogitccaa = round(r(mean), 0.001)
scalar sd_ylogitccaa = round(r(sd), 0.001)
scalar min_ylogitccaa = round(r(min), 0.001)
scalar max_ylogitccaa = round(r(max), 0.001)
scalar obs_ylogitccaa = r(N)
*Modelo3
est use logitprov
predict ylogitprov
qui sum ylogitprov
scalar mean_ylogitprov = round(r(mean), 0.001)
scalar sd_ylogitprov = round(r(sd), 0.001)
scalar min_ylogitprov = round(r(min), 0.001)
scalar max_ylogitprov = round(r(max), 0.001)
scalar obs_ylogitprov = r(N)
*Modelo4
est use cv_linear
predict ycvlinear
qui sum ycvlinear
scalar mean_ycvlinear = round(r(mean), 0.001)
scalar sd_ycvlinear = round(r(sd), 0.001)
scalar min_ycvlinear = round(r(min), 0.001)
scalar max_ycvlinear = round(r(max), 0.001)
scalar obs_ycvlinear = r(N)
*Modelo5
est use sol1
predict ysol1
qui sum ysol1
scalar mean_ysol1 = round(r(mean), 0.001)
scalar sd_ysol1 = round(r(sd), 0.001)
scalar min_ysol1 = round(r(min), 0.001)
scalar max_ysol1 = round(r(max), 0.001)
scalar obs_ysol1 = r(N)

*Crear una matriz con los resultados
matrix pred = ( ///
    sd_afecta, sd_yplugin, sd_ylogitccaa, sd_ylogitprov, sd_ycvlinear, sd_ysol1\ ///
    min_afecta, min_yplugin, min_ylogitccaa, min_ylogitprov, min_ycvlinear, min_ysol1\ ///
    max_afecta, max_yplugin, max_ylogitccaa, max_ylogitprov, max_ycvlinear, max_ysol1\ ///
    mean_afecta, mean_yplugin, mean_ylogitccaa, mean_ylogitprov, mean_ycvlinear, mean_ysol1\ ///
    obs_afecta, obs_yplugin, obs_ylogitccaa, obs_ylogitprov, obs_ycvlinear, obs_ysol1)
	
matrix colnames pred= "Prob[Afectado]" "Plugin" "Logit(CCAA)" "Logit(Prov)" "Lasso Lineal" "Lasso BIC"
matrix rownames pred= "Std. Dev." "Min" "Max" "Mean" "Obs"

putexcel set Resultados.xlsx, sheet(Predicciones, replace) modify
putexcel A1=matrix(pred), names

*******************************MATRIZ DE CONFUSIÓN******************************
********************************************************************************

*Modelo1
gen pafecta_plugin=0
replace pafecta_plugin=1 if yplugin>=0.22
**Verdaderos Positivos y Falsos Positivos
count if afecta==1 & pafecta_plugin==1
scalar vp_plugin=r(N)
count if afecta==1
scalar tp_plugin=r(N)
scalar sens_plugin=(vp_plugin/tp_plugin)*100
scalar falpos_plugin=100-sens_plugin
**Verdaderos Negativos y Falsos Negativos
count if afecta==0 & pafecta_plugin==0
scalar vn_plugin=r(N)
count if afecta==0
scalar tn_plugin=r(N)
scalar espe_plugin=(vn_plugin/tn_plugin)*100
scalar falneg_plugin=100-espe_plugin
**Clasificados correctamente
scalar correct_plugin=(vp_plugin+vn_plugin)/(tp_plugin+tn_plugin)*100

*Modelo2
gen pafecta_logitccaa=0
replace pafecta_logitccaa=1 if ylogitccaa>=0.22
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

*Modelo3
gen pafecta_logitprov=0
replace pafecta_logitprov=1 if ylogitprov>=0.22
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

*Modelo4
gen pafecta_cvlinear=0
replace pafecta_cvlinear=1 if ycvlinear>=0.22
**Verdaderos Positivos y Falsos Positivos
count if afecta==1 & pafecta_cvlinear==1
scalar vp_cvlinear=r(N)
count if afecta==1
scalar tp_cvlinear=r(N)
scalar sens_cvlinear=(vp_cvlinear/tp_cvlinear)*100
scalar falpos_cvlinear=100-sens_cvlinear
**Verdaderos Negativos y Falsos Negativos
count if afecta==0 & pafecta_cvlinear==0
scalar vn_cvlinear=r(N)
count if afecta==0
scalar tn_cvlinear=r(N)
scalar espe_cvlinear=(vn_cvlinear/tn_cvlinear)*100
scalar falneg_cvlinear=100-espe_cvlinear
**Clasificados correctamente
scalar correct_cvlinear=(vp_cvlinear+vn_cvlinear)/(tp_cvlinear+tn_cvlinear)*100

*Modelo5
gen pafecta_sol1=0
replace pafecta_sol1=1 if ysol1>=0.22
**Verdaderos Positivos y Falsos Positivos
count if afecta==1 & pafecta_sol1==1
scalar vp_sol1=r(N)
count if afecta==1
scalar tp_sol1=r(N)
scalar sens_sol1=(vp_sol1/tp_sol1)*100
scalar falpos_sol1=100-sens_sol1
**Verdaderos Negativos y Falsos Negativos
count if afecta==0 & pafecta_sol1==0
scalar vn_sol1=r(N)
count if afecta==0
scalar tn_sol1=r(N)
scalar espe_sol1=(vn_sol1/tn_sol1)*100
scalar falneg_sol1=100-espe_sol1
**Clasificados correctamente
scalar correct_sol1=(vp_sol1+vn_sol1)/(tp_sol1+tn_sol1)*100

**Guardamos los resultados
matrix confusion = ( ///
    sens_plugin, sens_logitccaa, sens_logitprov, sens_cvlinear, sens_sol1\ ///
    falpos_plugin, falpos_logitccaa, falpos_logitprov, falpos_cvlinear, falpos_sol1\ ///
    espe_plugin, espe_logitccaa, espe_logitprov, espe_cvlinear, espe_sol1\ ///
    falneg_plugin, falneg_logitccaa, falneg_logitprov, falneg_cvlinear, falneg_sol1\ ///
    correct_plugin, correct_logitccaa, correct_logitprov, correct_cvlinear, correct_sol1)

matrix colnames confusion= "Plugin" "Logit(CCAA)" "Logit(Prov)" "Lasso Lineal" "Lasso BIC"
matrix rownames confusion= "Sensibilidad [Verdaderos positivos]" "Falsos Positivos" "Especificidad [Verdaderos negativos]" "Falsos Negativos" "Clasificado Correctamente"
	
putexcel set Resultados.xlsx, sheet(Confusion, replace) modify
putexcel A1=matrix(confusion), nformat(number_d2) names
restore

*******************************MATRIZ DE CONFUSIÓN******************************
********************************************************************************
*Resumen de los modelos:
estimates use plugin.ster
estimates store plugin
estimates use logitccaa.ster
estimates store logitccaa
estimates use logitprov.ster
estimates store logitprov
estimates use sol1.ster
estimates store lassobic
lassogof plugin logitccaa logitprov lassobic, over(train)
*Exportamos resultados
matrix result=r(table)
matrix lassogof = (result[1,1..3] \ result[3,1..3] \ result[5,1..3]\ result[7,1..3])'
matrix colnames lassogof="Plugin" "Logit(CCAA)" "Logit(Prov)" "Lasso BIC"
matrix rownames lassogof="Desviance" "Desv Ratio" "N Obs"

putexcel set Resultados.xlsx, sheet(Lassogof, replace) modify
putexcel A1=matrix(lassogof), nformat(number_d2) names