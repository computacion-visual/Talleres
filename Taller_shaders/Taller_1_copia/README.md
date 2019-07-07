# Taller de análisis de imágenes por software

## Propósito

Introducir el análisis de imágenes/video en el lenguaje de [Processing](https://processing.org/).

## Tareas

Implementar las siguientes operaciones de análisis para imágenes/video:

* Conversión a escala de grises.
* Aplicación de algunas [máscaras de convolución](https://en.wikipedia.org/wiki/Kernel_(image_processing)).
* (solo para imágenes) Despliegue del histograma.
* (solo para imágenes) Segmentación de la imagen a partir del histograma.
* (solo para video) Medición de la [eficiencia computacional](https://processing.org/reference/frameRate.html) para las operaciones realizadas.

Emplear dos [canvas](https://processing.org/reference/PGraphics.html), uno para desplegar la imagen/video original y el otro para el resultado del análisis.

## Discusión

Las tareas a realizar, anteriormente mencionadas, fueron aplicadas a 3 imágenes y un video, que el usuario puede cambiar por medio de 4 botones correspondientes a cada uno de los elementos.

**Escala de grises.** Para esta actividad se realizó la conversión de cada pixel a su correspondiente valor en la escala de grises y además, se aplicaron otros 3 estándares (CCIR 601, BT. 709 y SMPTE 240M) que difieren en la luminancia rgb() que es aplicada a cada uno de estos. Como resultado se obtuvo la modificación de la imagen/video original en un nuevo canvas.

**Máscaras de convolución.** Se definieron las máscaras de convolución: *Sharpen*, *Edge Detection*, *Box Blur* y *Gaussian Blur*. Como resultado se obtuvo la modificación de la imagen/video original en un nuevo canvas.

**Histograma.** Se realizó el histograma de grises, rojos, verdes y azules de cada una de la imagen seleccionada. Dicho histograma es mostrado sobre la imagen modificada (segundo canvas) y puede varias dependiendo de los filtros que sean aplicados a la imagen original.

**Segmentación.** Para la segmentación se definió un rango inicial dentro de la imagen modificada, donde el usuario podrá ir variando este rango con las flechas de *arriba* y *abajo*. De esta manera, en el segundo canvas se mostrarán los pixeles de la imagen que se encuentran en la segmentación establecida junto con el histograma de brillantez.

**Medición de eficiencia computacional.** Cuando la opción *Video* es seleccionada, se mostrará el video original en el primer canvas y el modificado en el segundo canvas, allí el usuario podrá seleccionar alguna de las máscaras o filtros que desea aplicar sobre este y el valor de la eficiencia computacional (FPS).

## Entrega

* Hacer [fork](https://help.github.com/articles/fork-a-repo/) de la plantilla. Plazo: 28/4/19 a las 24h.
* (todos los integrantes) Presentar el trabajo presencialmente en la siguiente sesión de taller.
