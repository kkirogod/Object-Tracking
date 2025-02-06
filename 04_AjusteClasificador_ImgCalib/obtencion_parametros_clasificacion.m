clear
addpath("02_Extraer_Representar_Datos/Funciones/");
addpath("02_Extraer_Representar_Datos/VariablesGeneradas/");
addpath("03_DisegnoClasificador/Funciones/");
addpath("03_DisegnoClasificador/VariablesGeneradas/");
addpath("01_GenereacionMaterial/MaterialGenerado/");
addpath("04_AjusteClasificador_ImgCalib/Funciones/");
load("Datos_multiples_esferas.mat");
load("ImagenesEntrenamiento.mat");
load("DatosX.mat");
load("DatosY.mat");

%% Seleccionamos el valor (numPixMin) de area minima -> obj en posicion mas alejada

numPixMin = 999999;

for i=1:(size(imagenesEntrenamiento,4)-1)

    I = imagenesEntrenamiento(:,:,:,i);

    ROI = roipoly(I);
    numPix = sum(ROI(:)); % numero de pixeles de interes

    if(numPix < numPixMin && numPix ~= 0)
        numPixMin = numPix;
    end

end


%% Representar multiples esferas
centroides = datosMultiplesEsferas(:, 1:3);
radios = datosMultiplesEsferas(:, 4:6);

for i=1:size(radios,2)
    representa_datos_color_seguimiento_fondo(X ,Y);
    hold on, representa_multiples_esferas_espacio_ccas(centroides, radios(:, i)), hold off; 
end


%% Representar cada imagen con los diferentes radios de las multiples esferas

representa_deteccion_esferas_imagen_calib(imagenesEntrenamiento(:,:,:,1:end-1), datosMultiplesEsferas);


%% Representar cada imagen con los diferentes radios de las multiples esferas
%  y eliminando las agrupaciones mas pequeñas respecto al area minima

representa_deteccion_esferas_finales_conectividad_imagen_calib(imagenesEntrenamiento(:,:,:,1:end-1), datosMultiplesEsferas, numPixMin);

% Me quedo con el radio que quiero
datosMultiplesEsferas(:, 4:5) = [];

% Este valor de Umbral de Conectivivdad es el que mejor funciona
numPixMin = 30;

save("04_AjusteClasificador_ImgCalib/VariablesGeneradas/parametros_clasificador.mat", "datosMultiplesEsferas", "numPixMin");