# 📊 Modelo de Dobles Diferencias
La forma funcional del modelo en dobles diferencias es la siguiente:

`yᵢₜ = β₀ + β₁·Postₜ + β₂·Tratadoᵢ + β₃·(Postₜ·Tratadoᵢ) + β₄·Regᵢ + β₅·Xᵢ + εᵢₜ`

📌 Donde:
 - yᵢₜ representa la situación laboral del individuos i en el período t (activo/inactivo o empleado/desempleado);
 - Postₜ es una variable dicotómica que toma el valor 1 en el año posterior a la reforma (2019) y 0 en el año previo (2018);
 - Tratadoᵢ identifica si el individuo ha sido clasificado como potencialmente afectado por la reforma, según las probabilidades de exposición estimadas por los modelos LASSO;
 - Postₜ·Tratadoᵢ es la interacción clave del modelo y recoge el efecto diferencial de la reforma sobre el grupo tratado;
 - Regᵢ incluye controles por localización geográfica (provincias);
 - Xᵢ recoge variables sociodemográficas relevantes: género, nacionalidad, edad y nivel educativo;
 - εᵢₜ es el término de error aleatorio.
---
## 📈 Resultados Generados
El notebook principal produce los siguientes archivos de salida:
- `1.TenPar` Validación del supuesto de tendencias paralelas antes de la reforma.
- `2.RegAct.rtf` / `2.RegEmpl.rtf` Efecto estimado del SMI sobre la actividad y el empleo.
- `2.RegEdad.rtf`, `2.RegSexo.rtf` y `2.RegEduc.rtf` Análisis de heterogeneidad del efecto según grupo de edad, sexo y nivel educativo.
