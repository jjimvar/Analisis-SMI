*cd "C:\Users\Usuario\OneDrive\Escritorio\4to GANE\TFG\MCVL"
cd "C:\Users\Jjime\OneDrive\Escritorio\4to GANE\TFG\MCVL"
use "panel-individuos-empresas-2018.dta", clear

*******************************Configuración inicial****************************
********************************************************************************
*Eliminamos valores extremos salario
egen w99=pctile(s18), p(99.5) //Parte superior
egen w01=pctile(s18), p(00.5) //Parte inferior
keep if s18>w01 & s18<w99

*Generamos variable fundamental
gen smi19=900
gen afecta=0
replace afecta=1 if s18<smi19*1.0125

*Variables simples: Homgeneizacion frente a EPA
**Sexo
rename sexo hombre
replace hombre=0 if hombre==2

**Edad
rename edad edadempresa //Creemos que es la edad empresa
gen edad=year-anonac+1
gen edad5 =.
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
label define e5 1 "16 a 19 anos" 2 "20 a 24 anos" 3 "25 a 29 anos" 4 "30 a 34 anos" 5 "35 a 39 anos" 6 "40 a 44 anos" 7 "45 a 49 anos" 8 "50 a 54 anos" 9 "55 a 59 anos" 10 "60 a 64 anos"
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
label define pais 1 "Espana" 2 "UE-15" 3 "UE-27" 4 "Resto de Europa" 5 "Africa" 6 "America del Norte" 7 "Centroamerica y Sudamerica" 8 "Asia y Oceania"
label values paisnac pais

*Nivel educativo
gen educ=.
replace educ=1 if inlist(niveleduca, 10, 11)
replace educ=2 if inlist(niveleduca, 20, 21, 22)
replace educ=3 if niveleduca==30
replace educ=4 if niveleduca==31
replace educ=5 if inlist(niveleduca, 40, 42, 32, 41, 43, 47)
replace educ=6 if inlist(niveleduca, 44, 45, 46, 48)
label define nivelest 1 "Analfabeto" 2 "Primaria Incompleta" 3 "Primaria" 4 "Secundaria Inferior" 5 "Secundaria Superior" 6 "Terciaria"
label values educ nivelest

**Relacion laboral (meses)
gen anobaja2=anobaja
replace anobaja2=2018 if anobaja>2018
gen mesbaja2=mesbaja
replace mesbaja2=12 if anobaja>2018
gen relab=((anobaja2-anoalta)*12)+(mesbaja2-mesalta)

*Eliminamos valores atípicos
keep if edad5!=.
keep if paisnac!=.
keep if educ!=.

*Dividimos la base de datos
set seed 18563
gen byte train=(runiform()<=0.7)
label define tr 1 "Train" 0 "Test"
label values train tr

*Homogeneizamos variables utilizadas
**Edad
tab edad5, gen(ed)
global edad ed1 ed2 ed3 ed4 ed5 ed6 ed7 ed8 ed9
**Paisnac
tab paisnac, gen(pais)
global paisnac pais2 pais3 pais4 pais5 pais6 pais7 pais8
**Educación
tab educ, gen(ned)
global educ ned1 ned2 ned3 ned4 ned5

*******************************VALORES ESTIMADOS********************************
********************************************************************************
keep if train==0 //Trabajamos en la base de datos de prueba

*Cargamos los modelos
foreach mod in bic logit cv {
	foreach ef in ccaa prov{
		est use 2.`mod'`ef'.ster
		est store `mod'`ef'
		predict y`mod'`ef'
	}
}

*DISTRIBUCIONES
foreach ef in ccaa prov {
	foreach mod in bic logit cv {
		histogram y`mod'`ef', xline(0.1089373) /// Probabilidad media de verse afectado
		title(Modelo `mod' con `ef') ///
		xtitle("Prob. verse afectado por subida") ///
		ytitle("Frecuencia Relativa")
		
		graph save 3.Pred`mod'`ef'.gph, replace
	}
}

**Guardamos resumen de los modelos
graph combine 3.Predlogitccaa.gph 3.Predbicccaa.gph 3.Predcvccaa.gph 3.Predlogitprov.gph 3.Predbicprov.gph 3.Predcvprov.gph, ///
	title({bf:GRÁFICO 3: VALORES PREDECIDOS})
graph export "3.PredResumen.png", as(png) replace

*VALORES PREDECIDOS
qui sum afecta
scalar mean_afecta = r(mean)
scalar sd_afecta = r(sd)
scalar min_afecta = r(min)
scalar max_afecta = r(max)
scalar obs_afecta = r(N)

*Modelos
foreach ef in ccaa prov {
	foreach mod in bic logit cv {
		qui sum y`mod'`ef'
		scalar mean_y`mod'`ef' = r(mean)
		scalar sd_y`mod'`ef' = r(sd)
		scalar min_y`mod'`ef' = r(min)
		scalar max_y`mod'`ef' = r(max)
		scalar obs_y`mod'`ef' = r(N)
	}
}

*Crear una matriz con los resultados
matrix pred = ( ///
    sd_afecta, sd_ybicccaa, sd_ylogitccaa, sd_ycvccaa, sd_ybicprov, sd_ylogitprov, sd_ycvprov\ /// 
    min_afecta, min_ybicccaa, min_ylogitccaa, min_ycvccaa, min_ybicprov, min_ylogitprov, min_ycvprov\ ///
    max_afecta, max_ybicccaa, max_ylogitccaa, max_ycvccaa, max_ybicprov, max_ylogitprov, max_ycvprov\ ///
    mean_afecta, mean_ybicccaa, mean_ylogitccaa, mean_ycvccaa, mean_ybicprov, mean_ylogitprov, mean_ycvprov\ ///
    obs_afecta, obs_ybicccaa, obs_ylogitccaa, obs_ycvccaa, obs_ybicprov, obs_ylogitprov, obs_ycvprov)
	
matrix colnames pred= "Observado" "Predicción BIC (CCAA)" "Predicción Logit (CCAA)" "Predicción CV (CCAA)" "Predicción BIC (Prov)" "Predicción Logit (Prov)" "Predicción CV (Prov)"
matrix rownames pred= "Std. Dev." "Min" "Max" "Mean" "Obs"

putexcel set 3.Resultados.xlsx, sheet(Predicciones, replace) replace
putexcel A1=matrix(pred), nformat(number_d2) names

*******************************MATRIZ DE CONFUSIÓN******************************
********************************************************************************
*EFECTOS FIJOS CCAA
foreach mod in bic logit cv{
	*Predicciones
	gen pafecta_`mod'ccaa = 0
    replace pafecta_`mod'ccaa = 1 if y`mod'ccaa >=0.11121377 //Hallado en 3.CutOffCCAA.do

    *Tabla
    count if afecta == 1 & pafecta_`mod'ccaa == 1
    scalar vp_`mod'ccaa = r(N) //Verdaderos positivos
    count if afecta == 0 & pafecta_`mod'ccaa == 1
    scalar fn_`mod'ccaa = r(N) // Falsos Negativos
    count if pafecta_`mod'ccaa == 1
    scalar tot_pred1`mod'ccaa = r(N) // Total Predecidos Positivos
    count if afecta == 1 & pafecta_`mod'ccaa == 0
    scalar fp_`mod'ccaa = r(N) // Falsos positivos
    count if afecta == 0 & pafecta_`mod'ccaa == 0
    scalar vn_`mod'ccaa = r(N) // Verdaderos Negativos
    count if pafecta_`mod'ccaa == 0
    scalar tot_pred0`mod'ccaa = r(N) // Total Predecidos Negativos
    count if afecta == 1
    scalar tot_obs1`mod'ccaa = r(N) // Total Afectados
    count if afecta == 0
    scalar tot_obs0`mod'ccaa = r(N) // Total no afectados
    scalar tot_`mod'ccaa = tot_obs1`mod'ccaa + tot_obs0`mod'ccaa // Total
    **Creamos Matriz
    matrix tabla`mod'ccaa = J(3, 3, .)
    matrix tabla`mod'ccaa = (vp_`mod'ccaa, fn_`mod'ccaa, tot_pred1`mod'ccaa \ ///
                         fp_`mod'ccaa, vn_`mod'ccaa, tot_pred0`mod'ccaa \ ///
                         tot_obs1`mod'ccaa, tot_obs0`mod'ccaa, tot_`mod'ccaa)

	**Titulos
	matrix colnames tabla`mod'ccaa = "Afectado Observado D" ///
	                                 "No afectado Observado ~D" ///
									 "Total Predecidos"
									 
    matrix rownames tabla`mod'ccaa = "Afectado Predecido +" ///
	                                 "No afectado Predecido -" ///
									 "Total Observados"
				
	*Porcentajes
    matrix pct`mod'ccaa = J(9, 1, .)
    matrix pct`mod'ccaa = (vp_`mod'ccaa / tot_obs1`mod'ccaa*100\ ///
                       vn_`mod'ccaa / tot_obs0`mod'ccaa*100\ ///
                       vp_`mod'ccaa / tot_pred1`mod'ccaa*100\ ///
                       vn_`mod'ccaa / tot_pred0`mod'ccaa*100\ ///
                       (vp_`mod'ccaa+ vn_`mod'ccaa) / tot_`mod'ccaa*100)
    **Titulos
	matrix colnames pct`mod'ccaa= `mod'ccaa 
    matrix rownames pct`mod'ccaa = "Sensib +/D" ///
                                "Espec -/~D" ///
                                "VPP D/+" ///
                                "VPN ~D/-" ///
                                "Correct_Clasif"
}

matrix confusion1ccaa=(pctbicccaa, pctlogitccaa,pctcvccaa)
putexcel set 3.Resultados.xlsx, sheet(PctConfusionCCAA, replace) modify
putexcel A1 = matrix(confusion1ccaa), nformat(number_d2) names
matrix confusion2ccaa=(tablabicccaa, tablalogitccaa,tablacvccaa)
putexcel set 3.Resultados.xlsx, sheet(TablaConfusionCCAA, replace) modify
putexcel A1 = matrix(confusion2ccaa), names

*EFECTOS FIJOS PROV
foreach mod in bic logit cv{
	*Predicciones
	gen pafecta_`mod'prov = 0
    replace pafecta_`mod'prov = 1 if y`mod'prov >=0.11121377 //Hallado en 3.CutOffprov.do

    *Tabla
    count if afecta == 1 & pafecta_`mod'prov == 1
    scalar vp_`mod'prov = r(N) //Verdaderos positivos
    count if afecta == 0 & pafecta_`mod'prov == 1
    scalar fn_`mod'prov = r(N) // Falsos Negativos
    count if pafecta_`mod'prov == 1
    scalar tot_pred1`mod'prov = r(N) // Total Predecidos Positivos
    count if afecta == 1 & pafecta_`mod'prov == 0
    scalar fp_`mod'prov = r(N) // Falsos positivos
    count if afecta == 0 & pafecta_`mod'prov == 0
    scalar vn_`mod'prov = r(N) // Verdaderos Negativos
    count if pafecta_`mod'prov == 0
    scalar tot_pred0`mod'prov = r(N) // Total Predecidos Negativos
    count if afecta == 1
    scalar tot_obs1`mod'prov = r(N) // Total Afectados
    count if afecta == 0
    scalar tot_obs0`mod'prov = r(N) // Total no afectados
    scalar tot_`mod'prov = tot_obs1`mod'prov + tot_obs0`mod'prov // Total
    **Creamos Matriz
    matrix tabla`mod'prov = J(3, 3, .)
    matrix tabla`mod'prov = (vp_`mod'prov, fn_`mod'prov, tot_pred1`mod'prov \ ///
                         fp_`mod'prov, vn_`mod'prov, tot_pred0`mod'prov \ ///
                         tot_obs1`mod'prov, tot_obs0`mod'prov, tot_`mod'prov)

	**Titulos
	matrix colnames tabla`mod'prov = "Afectado Observado D" ///
	                                 "No afectado Observado ~D" ///
									 "Total Predecidos"
									 
    matrix rownames tabla`mod'prov = "Afectado Predecido +" ///
	                                 "No afectado Predecido -" ///
									 "Total Observados"
				
	*Porcentajes
    matrix pct`mod'prov = J(9, 1, .)
    matrix pct`mod'prov = (vp_`mod'prov / tot_obs1`mod'prov*100\ ///
                       vn_`mod'prov / tot_obs0`mod'prov*100\ ///
                       vp_`mod'prov / tot_pred1`mod'prov*100\ ///
                       vn_`mod'prov / tot_pred0`mod'prov*100\ ///
                       (vp_`mod'prov+ vn_`mod'prov) / tot_`mod'prov*100)
    **Titulos
	matrix colnames pct`mod'prov= `mod'prov 
    matrix rownames pct`mod'prov = "Sensib +/D" ///
                                "Espec -/~D" ///
                                "VPP D/+" ///
                                "VPN ~D/-" ///
                                "Correct_Clasif"
}

matrix confusion1prov=(pctbicprov, pctlogitprov,pctcvprov)
putexcel set 3.Resultados.xlsx, sheet(PctConfusionProv, replace) modify
putexcel A1 = matrix(confusion1prov), nformat(number_d2) names
matrix confusion2prov=(tablabicprov, tablalogitprov,tablacvprov)
putexcel set 3.Resultados.xlsx, sheet(TablaConfusionProv, replace) modify
putexcel A1 = matrix(confusion2prov), names

*******************************LASSO GOF****************************************
********************************************************************************
*Resumen de los modelos:
lassogof bicccaa logitccaa cvccaa bicprov logitprov cvprov, over(train)
*Exportamos resultados
matrix lasogof=r(table)'
matrix colnames lasogof="Lasso BIC (CCAA)" "Logit (CCAA)" "Lasso CV (CCAA)" "Lasso BIC (Prov)" "Logit (Prov)" "Lasso CV (Prov)"
matrix rownames lasogof="Desviance" "Desv Ratio" "N Obs"

putexcel set 3.Resultados.xlsx, sheet(Lassogof, replace) modify
putexcel A1=matrix(lasogof), nformat(number_d2) names