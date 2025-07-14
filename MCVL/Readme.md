# 📊 Modelo de Predicción de Exposición al SMI
La forma funcional del modelo logístico entrenado es la siguiente:

`Prob(Afectadoᵢ = 1 | Xᵢ) = exp(β₀ + ∑ₖ βₖ·Xᵢₖ + ∑ⱼ ∑ₖ γⱼₖ·Xᵢⱼ·Xᵢₖ) / [1 + exp(β₀ + ∑ₖ βₖ·Xᵢₖ + ∑ⱼ ∑ₖ γⱼₖ·Xᵢⱼ·Xᵢₖ)]`

📌 Donde:
    - βₖ captura el efecto individual de la variable Xᵢₖ, 
	- γⱼₖ representa el efecto de la interacción entre Xᵢⱼ y Xᵢₖ con j<k,
	- y la doble suma ∑ⱼ ∑ₖ ,garantiza que se incluyan todas las combinaciones únicas y ordenadas sin repeticiones.

## 🔢 Variables utilizadas
El modelo se ha entrenado sobre K = 6 variables categóricas clave:
	- Homᵢ: dummy para el sexo masculino,
	- Edadᵢ: variable categórica por tramos de 5 años,
	- Paisnacᵢ: país de nacimiento,
	- Educᵢ: nivel educativo alcanzado,
	- Regᵢ: localización geográfica (provincia o comunidad autónoma),
	- Relabᵢ: antigüedad en la empresa, en meses.

---
## Resultados Generados
El notebook principal produce los siguientes archivos de salida:
- `1.EstDes.xlsx` Estadísticos descriptivos comparando las bases MCVL y EPA
- `2.cvprov.ster` Modelo entrenado con mayor verosimilitud (formato de Stata)
- `3.Resultados.xlsx` Tabla resumen con métricas de rendimiento del modelo
- `3.CutOffOpt.png` Visualización del punto óptimo de corte para clasificación del tratamiento