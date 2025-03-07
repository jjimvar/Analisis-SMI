*cd "C:\Users\Usuario\OneDrive\Escritorio\4to GANE\TFG\MCVL"
cd "C:\Users\Jjime\OneDrive\Escritorio\4to GANE\TFG\MCVL"
use "panel-individuos-empresas-2018.dta", clear

*******************************Configuración inicial****************************
********************************************************************************
*Eliminamos valores extremos salario
egen w99=pctile(s18), p(99.5) //Parte superior
egen w01=pctile(s18), p(00.5) //Parte inferior: SMI18=860
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

*Variable pais de procedencia
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

*Extranjero
gen extranjero=0
replace extranjero=1 if paisnac!=1

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

*Eliminamos valores atípicos
keep if edad5!=.
keep if paisnac!=.
keep if educ!=.

*Dividimos la base de datos
set seed 18563
gen byte train=(runiform()<=0.6)
label define tr 1 "Train" 0 "Test"
label values train tr

****************************ESTADÍSTICOS DESCRIPTIVOS***************************
********************************************************************************
*Variable Fundamental
qui histogram s18, xline(900) title("Distribución Salario") xtitle("€/mes") ytitle("Frecuencia Relativa")

graph save "1.Salario.gph", replace

**Distribución
qui sum afecta, detail
matrix afect=(r(min)\r(p25)\r(p50)\r(p75)\r(max)\r(mean)\r(sd)\r(N))

matrix rownames afect= "Min" "Cuartil 1" "Cuartil 2" "Cuartil 3" "Max" "Media" ///
	"Desv Est" "N Obs"

putexcel set 1.EstDes.xlsx, sheet(Afecta, replace) replace
putexcel A1=matrix(afect), names

*Variables continuas
**Afectados
foreach x in edad relab {
	qui sum `x' if afecta==1, detail
	matrix `x'1=(r(min)\r(p25)\r(p50)\r(p75)\r(max)\r(mean)\r(sd)\r(N))
}

**No Afectados
foreach x in edad relab {
	qui sum `x' if afecta==0, detail
	matrix `x'0=(r(min)\r(p25)\r(p50)\r(p75)\r(max)\r(mean)\r(sd)\r(N))
}

matrix continua=edad0,relab0,edad1,relab1
matrix rownames continua= "Min" "Cuartil 1" "Cuartil 2" "Cuartil 3" "Max" "Media" ///
	"Desv Est" "N Obs"
matrix colnames continua= "Edad" "Permanencia Empresa" "Edad" "Permanencia Empresa"
putexcel set 1.EstDes.xlsx, sheet(Est Continuas, replace) modify
putexcel A1=matrix(continua), names

*Variable categórica: Nivel educativo
**Tratado
qui tab educ if afecta==1
scalar N=r(N)
foreach n in 1 2 3 4 5 6 7{
	qui count if educ == `n' & afecta==1
	scalar sum`n'=r(N)
	scalar por`n' = r(N)/N*100	
}
matrix educ1= (sum1, por1\sum2, por2\sum3, por3\sum4, por4\sum5, por5\sum6, por6\sum7, por7\ N, 100)

**No tratado
qui tab educ if afecta==0
scalar N=r(N)
foreach n in 1 2 3 4 5 6 7{
	qui count if educ == `n'& afecta==0
	scalar sum`n'=r(N)
	scalar por`n' = r(N)/N*100	
}
matrix educ0= (sum1, por1\sum2, por2\sum3, por3\sum4, por4\sum5, por5\sum6, por6\sum7, por7\ N, 100)

matrix educ= educ0, educ1
matrix colname educ= "Obs" "Pct" "Obs" "Pct"
matrix rownames educ= "Analfabeto" "Primaria Incompleta" "Primaria" "Secundaria" "Bachillerato" "FP" "Terciaria" "Total"
putexcel set 1.EstDes.xlsx, sheet(N Educ, replace) modify
putexcel A1=matrix(educ), names

*Dummies
**Creamos valores
foreach y in hombre extranjero {
	foreach afect in 1 0 {
	qui tab `y' if afecta==`afect'
	scalar N`afect' = r(N)
	foreach n in 0 1 {
		qui count if `y' == `n' & afecta==`afect'
		scalar sum`n'`afect' = r(N)
		scalar por`n'`afect' = r(N)/N`afect'*100
		matrix `y'`afect'= (sum0`afect', por0`afect'\sum1`afect', por1`afect'\N`afect', 100)'
		matrix rowname `y'`afect'= "Obs" "Pct"
	}
}
}
**Exportamos resultados
***Hombre
matrix hombre=hombre0,hombre1
matrix colnames hombre=  "Mujer" "Hombre" "Total" "Mujer" "Hombre" "Total" 
putexcel set 1.EstDes.xlsx, sheet(Sexo, replace) modify
putexcel A1=matrix(hombre), names
***Extranjero
matrix extranjero=extranjero0, extranjero1
matrix colnames extranjero="No extranjero" "Extranjero" "Total" "No extranjero" "Extranjero" "Total"
putexcel set 1.EstDes.xlsx, sheet(Extranjero, replace) modify
putexcel A1=matrix(extranjero), names

