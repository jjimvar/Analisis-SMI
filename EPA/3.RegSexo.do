*cd "C:\Users\Usuario\OneDrive\Escritorio\4to GANE\TFG\EPA"
cd "C:\Users\Jjime\OneDrive\Escritorio\4to GANE\TFG\EPA"
use "EPA1819.dta", clear

****************************0. Configuración inicial****************************
********************************************************************************
**Período de la encuesta
***Año
gen anoenc=.
replace anoenc=0 if ciclo>=182 & ciclo<=185
replace anoenc=1 if ciclo>=186 & ciclo<=189
label define ae 0 "2018" 1 "2019"
label values anoenc ae

***Trimestre
gen trenc=ciclo
label define tr 182 "2018T1" 183 "2018T2" 184 "2018T3" 185 "2018T4" ///
                         186 "2019T1" 187 "2019T2" 188 "2019T3" 189 "2019T4"
label values trenc tr

**Sexo
rename sexo1 hombre
replace hombre=0 if hombre==6
label define sx 1 "Hombre" 0 "Mujer"
label values hombre sx

**Edad
rename edad5 edad
drop if edad<=10
drop if edad>=65
gen edad5 = .
replace edad5 = 1 if edad == 16
replace edad5 = 2 if edad == 20
replace edad5 = 3 if edad == 25
replace edad5 = 4 if edad == 30
replace edad5 = 5 if edad == 35
replace edad5 = 6 if edad == 40
replace edad5 = 7 if edad == 45
replace edad5 = 8 if edad == 50
replace edad5 = 9 if edad == 55
replace edad5 = 10 if edad == 60 
label define e5 1 "16 a 19 anos" 2 "20 a 24 anos" 3 "25 a 29 anos" 4 "30 a 34 anos" 5 "35 a 39 anos" 6 "40 a 44 anos" 7 "45 a 49 anos" 8 "50 a 54 anos" 9 "55 a 59 anos" 10 "60 a 64 anos"
label values edad5 e5

**Provincia
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
gen paisnac = 1
replace paisnac = 2 if regna1==115
replace paisnac = 3 if inlist(regna1, 125, 127)
replace paisnac = 4 if inlist(regna1, 128, 100)
replace paisnac = 5 if inlist(regna1, 200)
replace paisnac = 6 if inlist(regna1, 300)
replace paisnac = 7 if inlist(regna1, 310, 350)
replace paisnac = 8 if inlist(regna1, 400, 410, 420, 500)
label define pais 1 "Espana" 2 "UE-15" 3 "UE-27" 4 "Resto de Europa" 5 "Africa" 6 "America del Norte" 7 "Centroamerica y Sudamerica" 8 "Asia y Oceania"
label values paisnac pais

**Extranjero
gen extranjero=0
replace extranjero=1 if paisnac!=1 

**Nivel educativo
gen educ=.
replace educ=1 if nforma == "AN"
replace educ=2 if nforma == "P1"
replace educ=3 if nforma == "P2"
replace educ=4 if nforma == "S1"
replace educ=5 if nforma == "SG" | nforma == "SP"
replace educ=6 if nforma == "SU"
label define nivelest  1 "Analfabeto" 2 "Primaria Incompleta" 3 "Primaria" 4 "Secundaria Inferior" 5 "Secundaria Superior" 6 "Terciaria"
label values educ nivelest

**Tiempo en meses en la empresa
rename dcom relab
replace relab=0  if aoi>=5

**Participación en el mercado laboral
***Actividad
gen activo=.
replace activo=1 if aoi<=6
replace activo=0 if aoi>=7
***Empleo
gen empleado=.
replace empleado=1 if inlist(aoi, 3, 4)
replace empleado=0 if inlist(aoi, 5, 6)
***Variable ampliada
gen tipotrab=aoi
label define tt 3 "Ocupados Subempleados" 4 "Resto Ocupados" 5 "Parados sin exp." 6 "Parados con exp." 7 "Inactivos desanimados" 8 "Inactivos pontenciales act." 9 "Resto Inactivos"
label values tipotrab tt

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

*****************************FILTRACIÓN INICIAL*********************************
*Filtramos valores pequeños
est use 2.cvprov.ster
predict ycvprov
qui sum ycvprov, detail
scalar p5cvprov'=r(p5)

*cd "C:\Users\Usuario\OneDrive\Escritorio\4to GANE\TFG\EPA"
cd "C:\Users\Jjime\OneDrive\Escritorio\4to GANE\TFG\EPA"
use "EPA1819.dta", clear

****************************0. Configuración inicial****************************
********************************************************************************
**Período de la encuesta
***Año
gen anoenc=.
replace anoenc=0 if ciclo>=182 & ciclo<=185
replace anoenc=1 if ciclo>=186 & ciclo<=189
label define ae 0 "2018" 1 "2019"
label values anoenc ae

***Trimestre
gen trenc=ciclo
label define tr 182 "2018T1" 183 "2018T2" 184 "2018T3" 185 "2018T4" ///
                         186 "2019T1" 187 "2019T2" 188 "2019T3" 189 "2019T4"
label values trenc tr

**Sexo
rename sexo1 hombre
replace hombre=0 if hombre==6
label define sx 1 "Hombre" 0 "Mujer"
label values hombre sx

**Edad
rename edad5 edad
drop if edad<=10
drop if edad>=65
gen edad5 = .
replace edad5 = 1 if edad == 16
replace edad5 = 2 if edad == 20
replace edad5 = 3 if edad == 25
replace edad5 = 4 if edad == 30
replace edad5 = 5 if edad == 35
replace edad5 = 6 if edad == 40
replace edad5 = 7 if edad == 45
replace edad5 = 8 if edad == 50
replace edad5 = 9 if edad == 55
replace edad5 = 10 if edad == 60 
label define e5 1 "16 a 19 anos" 2 "20 a 24 anos" 3 "25 a 29 anos" 4 "30 a 34 anos" 5 "35 a 39 anos" 6 "40 a 44 anos" 7 "45 a 49 anos" 8 "50 a 54 anos" 9 "55 a 59 anos" 10 "60 a 64 anos"
label values edad5 e5

**Provincia
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
gen paisnac = 1
replace paisnac = 2 if regna1==115
replace paisnac = 3 if inlist(regna1, 125, 127)
replace paisnac = 4 if inlist(regna1, 128, 100)
replace paisnac = 5 if inlist(regna1, 200)
replace paisnac = 6 if inlist(regna1, 300)
replace paisnac = 7 if inlist(regna1, 310, 350)
replace paisnac = 8 if inlist(regna1, 400, 410, 420, 500)
label define pais 1 "Espana" 2 "UE-15" 3 "UE-27" 4 "Resto de Europa" 5 "Africa" 6 "America del Norte" 7 "Centroamerica y Sudamerica" 8 "Asia y Oceania"
label values paisnac pais

**Extranjero
gen extranjero=0
replace extranjero=1 if paisnac!=1 

**Nivel educativo
gen educ=.
replace educ=1 if nforma == "AN"
replace educ=2 if nforma == "P1"
replace educ=3 if nforma == "P2"
replace educ=4 if nforma == "S1"
replace educ=5 if nforma == "SG" | nforma == "SP"
replace educ=6 if nforma == "SU"
label define nivelest  1 "Analfabeto" 2 "Primaria Incompleta" 3 "Primaria" 4 "Secundaria Inferior" 5 "Secundaria Superior" 6 "Terciaria"
label values educ nivelest

**Tiempo en meses en la empresa
rename dcom relab
replace relab=0  if aoi>=5

**Participación en el mercado laboral
***Actividad
gen activo=.
replace activo=1 if aoi<=6
replace activo=0 if aoi>=7
***Empleo
gen empleado=.
replace empleado=1 if inlist(aoi, 3, 4)
replace empleado=0 if inlist(aoi, 5, 6)
***Variable ampliada
gen tipotrab=aoi
label define tt 3 "Ocupados Subempleados" 4 "Resto Ocupados" 5 "Parados sin exp." 6 "Parados con exp." 7 "Inactivos desanimados" 8 "Inactivos pontenciales act." 9 "Resto Inactivos"
label values tipotrab tt

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

********************************CARGA MODELO************************************
est use 2.cvprov.ster
predict ycvprov
qui sum ycvprov, detail
scalar p5cvprov=r(p5)

******************************* Estimaciones ***********************************
********************************************************************************

*Variables fundamentales
gen tratado=.
gen did=.


foreach n in 0 1 {
	preserve
	*Filtramos la muestra por sexo
	keep if hombre==`n'
	*Afectado por la reforma
	replace tratado=.
	replace tratado=1 if ycvprov>=0.150863595
	replace tratado=0 if ycvprov<0.130863595 & ycvprov>p5cvprov
	**Afectado por año
	replace did=.
	replace did=tratado*anoenc
	**Creamos la global
	global a anoenc tratado did i.prov
	global b extranjero i.edad5 i.educ

	**Estimamos para actividad
	qui reg activo $a $b if activo!=. & tratado!=., robust
	estadd local FE "(Prov)"
	estadd local Xi "(Si)"
	qui sum activo
	estadd scalar Promedio=r(mean)*100
	estadd scalar R2=e(r2)
	estadd scalar Nobs=e(N)
	est store act`n'

	**Estimamos para empleo
	qui reg empleado $a $b if activo!=. & tratado!=., robust
	estadd local FE "(Prov)"
	estadd local Xi "(Si)"
	qui sum empleado
	estadd scalar Promedio=r(mean)*100
	estadd scalar R2=e(r2)
	estadd scalar Nobs=e(N)
	est store empl`n'
	restore
}

***********************************Resultados***********************************
*Actividad
esttab act0 act1 empl0 empl1 using 3.RegEduc.rtf, keep(anoenc tratado did) ///
	title("Regresión: Resultado sexo") ///
	mtitles("Mujeres" "Hombres" "Mujeres" "Hombres") ///
	s(FE Xi Promedio R2 Nobs) ///
	coeflabels(anoenc "Diferencia" tratado "Tratado" did "DiD") ///
	star(* 0.1 ** 0.05 *** 0.01) replace