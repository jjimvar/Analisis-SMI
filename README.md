# 📈 Análisis del Impacto del SMI 2019
Este repositorio recoge el código necesario para analizar el efecto que tuvo la histórica subida del Salario Mínimo Interprofesional (SMI) en 2019 sobre dos dimensiones clave del mercado laboral español:

🔹 La probabilidad de participar en el mercado laboral.

🔹 La probabilidad de estar empleado.

En 2019, el SMI en España aumentó un 22,3 %, pasando de 735,90 € a 900 € mensuales en 14 pagas. Este incremento constituyó el mayor aumento interanual desde la recuperación democrática, generando un interés significativo en su análisis económico.

## 🧩 Estructura Metodológica
El análisis se divide en dos fases complementarias:

   1. **Modelo de exposición al SMI** (`MCVL`)
   Se entrena un modelo logístico predictivo (basado en técnicas de machine learning) usando microdatos de la MCVL para estimar la probabilidad de que cada individuo se vea afectado por la subida del SMI.
   2. **Estimación del efecto causal** (`EPA`)
   Se emplea un diseño de diferencias en diferencias (DiD) con datos de la EPA para cuantificar el impacto de la medida sobre la actividad y el empleo, utilizando el score de exposición como variable de tratamiento.

---
## 📌 Contenido del Directorio

```
Analisis-SMI/
│
├── MCVL/
│   ├── ModeloPrediccion.ipynb
│   ├── MCVL18.dta
│   └── Readme.md
├── EPA/
│   ├── ModeloDiD.ipynb
│   ├── EPA1819.dta
│   └── Readme.md
│
└── README.md
```

---

## 🔧 Requisitos

- Python >= 3.9 (recomendado: 3.13.5)
- Jupyter Notebook
- Stata (para ejecutar archivos `.do`)
- Paquetes adicionales según se requiera en los notebooks

Instala los paquetes de Python necesarios ejecutando en una celda de Jupyter:

```python
%pip install pystata
```
---

## 🚀 Uso

1. Clona este repositorio:
   ```bash
   git clone https://github.com/tu_usuario/Analisis-SMI.git
   ```

2. Preparar los datos:
   - Descomprime `MCVL18.zip` en la carpeta `MCVL`/
   - Descomprime `EPA1819.zip` en la carpeta `EPA`/

3. Ejecutar los notebooks:
   - Abre `MCVL/ModeloPrediccion.ipynb` para general el grado de exposición.
   - Luego abre `EPA/ModeloDiD.ipynb` para estimar el efecto de la medida.
---

## 📬 Contacto

- Autor: Jesús Jiménez Vargas
- Git hub: [@jjimvar](https://github.com/jjimvar)
- Correo: jjimenezvargas907@gmail.com
