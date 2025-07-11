# Análisis del Impacto del SMI 2019

## Descripción

Este proyecto tiene como objetivo cuantificar el efecto que tuvo la fuerte subida del Salario Mínimo Interprofesional (SMI) de 2019 sobre dos dimensiones laborales fundamentales en España:
- La probabilidad de participar en el mercado laboral.
- La probabilidad de estar empleado.

La subida salarial de 2019 representó un incremento del 22,3% en el umbral legal, elevando el SMI de 735,90 € a 900 € mensuales en 14 pagas. Este aumento constituye el mayor incremento interanual registrado en la historia reciente. Para analizar su impacto, se estimó la probabilidad de exposición a la medida mediante el método de regularización LASSO, integrando estos resultados en un diseño de dobles diferencias (DiD).

---

## Estructura del Proyecto

```
Analisis-SMI/
│
├── EPA/
│   ├── 1.EstDes.do
│   ├── 2.Reg.do
│   ├── 3.RegEdad.do
│   ├── 3.RegEduc.do
│   ├── 3.RegExtr.do
│   ├── 3.RegSexo.do
│   └── Readme.md
│
├── MCVL/
│   ├── ModeloPrediccion.ipynb
│   ├── MCVL18.dta
│   └── Readme.md
│
└── README.md
```

---

## Requisitos

- Python 3.13.5
- Jupyter Notebook
- Stata (para ejecutar archivos `.do`)
- Paquetes adicionales según se requiera en los notebooks

Instala los paquetes de Python necesarios ejecutando en una celda de Jupyter:

```python
%pip install pystata
```

---

## Uso

1. Clona este repositorio:
   ```bash
   git clone https://github.com/tu_usuario/Analisis-SMI.git
   ```
2. Abre el notebook `ModeloPredicción.ipynb` en la carpeta `MCVL` para reproducir los resultados de modelos predictivos.
3. Abre el notebook `ModeloDiD.ipynb` en la carpeta `EPA` para obtener los resultados en la actividad y empleo.

---

## Metodología

- **Estimación de exposición:** Se utiliza LASSO para estimar la probabilidad de exposición a la subida del SMI.
- **Diseño de evaluación:** Se emplea un diseño de dobles diferencias (DiD) para identificar el efecto causal sobre las variables de interés.

---

## Resultados

Incluye gráficos y tablas relevantes en la carpeta `MCVL`:
- `1.Salario.gph` y `1.Salario.png`: Visualizaciones del impacto salarial.
- `1.EstDes.xlsx`: Resultados estadísticos.

---

## Contacto

Para dudas o sugerencias, contacta a **jjimenezvargas907@gmail.com**.

---

## Licencia

Este proyecto se distribuye bajo la licencia MIT.