clear
addpath("02_Extraer_Representar_Datos/Funciones/");
addpath("02_Extraer_Representar_Datos/VariablesGeneradas/");
addpath("03_DisegnoClasificador/Funciones/");
addpath("03_DisegnoClasificador/VariablesGeneradas/");
addpath("01_GenereacionMaterial/MaterialGenerado/");
load("ImagenesEntrenamiento.mat");
load("DatosX.mat");
load("DatosY.mat");

XColor = double(X(Y==1,:));

XFondo = double(X(Y==0,:));

%% PRUEBA FUNCIÓN 1

centroideColor = mean(XColor);

P = centroideColor';
NP = XColor';

vector_distancia = calcula_distancia_punto_a_nube_puntos(P, NP);

radio = max(vector_distancia);

%% PRUEBA FUNCIÓN 2

datosEsfera = calcula_datos_esfera(XColor, XFondo);

%% PRUEBA FUNCIÓN 3

representa_esfera(centroideColor, datosEsfera(4)); % r1
figure;
representa_esfera(centroideColor, datosEsfera(5)); % r2
figure;
representa_esfera(centroideColor, datosEsfera(6)); % r12

%% PRUEBA FUNCIÓN 4

load("ImagenesEntrenamiento.mat");

I = imagenesEntrenamiento(:,:,:,6);

Ib_r1 = calcula_deteccion_1esfera_en_imagen(I, datosEsfera(:,1:4));
Ib_r2 = calcula_deteccion_1esfera_en_imagen(I, datosEsfera(:,[1:3 5]));
Ib_r12 = calcula_deteccion_1esfera_en_imagen(I, datosEsfera(:,[1:3 6]));

Io_r1 = funcion_visualiza(I, Ib_r1, [0 255 0], 1, 0);
Io_r2 = funcion_visualiza(I, Ib_r2, [0 255 0], 1, 0);
Io_r12 = funcion_visualiza(I, Ib_r12, [0 255 0], 1, 0);

subplot(2,2,1), imshow(I);
subplot(2,2,2), imshow(Io_r1);
subplot(2,2,3), imshow(Io_r2);
subplot(2,2,4), imshow(Io_r12);

%%
% Generar y representar en el espacio de características, junto con los datos
% x-y, las esferas con los tres criterios de radio (una ventana tipo figure por
% esfera)

clear
load("DatosX.mat");
load("DatosY.mat");
load("Datos_esferas.mat");

centroideColor = datosEsfera(1:3);

representa_datos_color_seguimiento_fondo(X, Y);
representa_esfera(centroideColor, datosEsfera(4)); % r1

representa_datos_color_seguimiento_fondo(X, Y);
representa_esfera(centroideColor, datosEsfera(5)); % r2

representa_datos_color_seguimiento_fondo(X, Y);
representa_esfera(centroideColor, datosEsfera(6)); % r12


%%
% Aplicación y visualización de resultados del clasificador basado en una
% esfera sobre las imágenes de calibración. Por cada imagen de calibración se
% debe generar una ventana tipo figure con cuatro gráficas (subplot de dos filas
% y dos columnas de gráficas):

%   • Primera gráfica: imagen de color de calibración original
%   • Segunda gráfica: imagen anterior donde se visualizan en un color los
%   píxeles que se detectan como del color de seguimiento utilizando el
%   radio del primer criterio: r1 (se detectan todos los píxeles del color).
%   Para ello utiliza la función_visualiza
%   • Tercera y cuarta gráfica: igual para los radios r2 (no detecta ruido)
%   y r12 (radio de compromiso).

for i=1:(size(imagenesEntrenamiento,4)-1)

    I = imagenesEntrenamiento(:,:,:,i);
    
    Ib_r1 = calcula_deteccion_1esfera_en_imagen(I, datosEsfera(:,1:4));
    Ib_r2 = calcula_deteccion_1esfera_en_imagen(I, datosEsfera(:,[1:3 5]));
    Ib_r12 = calcula_deteccion_1esfera_en_imagen(I, datosEsfera(:,[1:3 6]));
    
    Io_r1 = funcion_visualiza(I, Ib_r1, [0 255 0], 1, 0);
    Io_r2 = funcion_visualiza(I, Ib_r2, [0 255 0], 1, 0);
    Io_r12 = funcion_visualiza(I, Ib_r12, [0 255 0], 1, 0);
    
    subplot(2,2,1), imshow(I);
    subplot(2,2,2), imshow(Io_r1);
    subplot(2,2,3), imshow(Io_r2);
    subplot(2,2,4), imshow(Io_r12);

    pause;

end


%% CALCULAMOS LOS DATOS DE MULTIPLES ESFERAS

K = 4;
XColor = double(X(Y==1,:));
[idx, centroides] = funcion_kmeans(XColor, K);
unique(idx)

% representa_datos_color_seguimiento_fondo(X, Y, idx);

XFondo = double(X(Y==0,:));

X1 = XColor(idx==1, :);
datosEsfera1 = calcula_datos_esfera(X1, XFondo);

X2 = XColor(idx==2, :);
datosEsfera2 = calcula_datos_esfera(X2, XFondo);

X3 = XColor(idx==3, :);
datosEsfera3 = calcula_datos_esfera(X3, XFondo);

X4 = XColor(idx==4, :);
datosEsfera4 = calcula_datos_esfera(X4, XFondo);

datosMultiplesEsferas = [datosEsfera1; datosEsfera2; datosEsfera3; datosEsfera4];

save('./03_DisegnoClasificador/VariablesGeneradas/Datos_multiples_esferas.mat', "datosMultiplesEsferas")


% comprobamos que ha ido todo bien

representa_datos_color_seguimiento_fondo_idx(X, Y, idx);

for i=1:K

    centroideColor = datosMultiplesEsferas(i, 1:3);

    representa_esfera(centroideColor, datosMultiplesEsferas(i, 4)); % r1

end


representa_datos_color_seguimiento_fondo_idx(X, Y, idx);

for i=1:K

    centroideColor = datosMultiplesEsferas(i, 1:3);

    representa_esfera(centroideColor, datosMultiplesEsferas(i, 5)); % r2

end


representa_datos_color_seguimiento_fondo_idx(X, Y, idx);

for i=1:K

    centroideColor = datosMultiplesEsferas(i, 1:3);

    representa_esfera(centroideColor, datosMultiplesEsferas(i, 6)); % r12

end