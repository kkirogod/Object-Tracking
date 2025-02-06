%% 2. GENERACIÓN DE CONJUNTO DE DATOS

%% 2.1 - EXTRACCIÓN DE DATOS DEL COLOR OBJETO DE SEGUIMIENTO Y OTROS COLORES DEL FONDO DE LA ESCENA

%%
%  2.1.1 - Para cada imagen de calibración que contiene el objeto, seleccionar una región de píxeles
%  con el color de seguimiento. Almacenar los valores R, G y B de todos los píxeles seleccionados.
%  Para ello, utilizar una matriz Matlab DatosColor, con 4 campos: identificador de la imagen,
%  valores R, G y B.

clear
addpath("01_GenereacionMaterial/MaterialGenerado/");

load("ImagenesEntrenamiento.mat");

%{
for i=1:12
    disp("Pulsa una tecla para mostrar la imagen " + i + "...");
    pause;
    imshow(imagenesEntrenamiento(:,:,:,i));
end
%}

%{
I = imagenesEntrenamiento(:,:,:,1);
ROI = roipoly(I);
R = I(:,:,1);
RI = R .* uint8(ROI);
imshow(RI);
%}

numImagenesColor = 11;
datosColor = [];

for i=1:numImagenesColor
    I = imagenesEntrenamiento(:,:,:,i);

    R = I(:,:,1);
    G = I(:,:,2);
    B = I(:,:,3);

    ROI = roipoly(I);
    numPix = sum(ROI(:)); % numero de pixeles de interes

    datosColor = [datosColor; i*ones(numPix,1), R(ROI), G(ROI), B(ROI)];

    %{
    RI = R .* uint8(ROI);
    GI = G .* uint8(ROI);
    BI = B .* uint8(ROI);

    % sacamos los valores medios R G B
    VMR = sum(RI(:))/numPix; 
    VMG = sum(GI(:))/numPix;
    VMB = sum(BI(:))/numPix;

    datosColor = [datosColor; i, VMR, VMG, VMB];
    %}
end

save('./02_Extraer_Representar_Datos/VariablesGeneradas/DatosColor.mat', "datosColor")

%%
%  2.1.2 - De la misma forma, seleccionar regiones de píxeles representativas del fondo de la
%  escena, que no sean del color de seguimiento (para ello es posible utilizar la imagen de fondo o
%  las mismas imágenes que tienen el objeto, siempre que se seleccionen regiones donde no esté
%  el objeto). Almacenar los valores R, G y B de todos los píxeles seleccionados. Para ello, utilizar
%  una matriz Matlab DatosFondo, con 4 campos: identificador de la región, valores R, G y B.

datosFondo = [];

for i=2:numImagenesColor+1
    I = imagenesEntrenamiento(:,:,:,i);

    R = I(:,:,1);
    G = I(:,:,2);
    B = I(:,:,3);

    ROI = roipoly(I);
    numPix = sum(ROI(:)); % numero de pixeles de interes

    datosFondo = [datosFondo; i*ones(numPix,1), R(ROI), G(ROI), B(ROI)];

    %{
    RI = R .* uint8(ROI);
    GI = G .* uint8(ROI);
    BI = B .* uint8(ROI);

    % sacamos los valores medios R G B
    VMR = sum(RI(:))/numPix; 
    VMG = sum(GI(:))/numPix;
    VMB = sum(BI(:))/numPix;

    datosFondo = [datosFondo; i, VMR, VMG, VMB];
    %}
end

save('./02_Extraer_Representar_Datos/VariablesGeneradas/DatosFondo.mat', "datosFondo")

%%
%{ 
2.1.3 - Generación de un primer conjunto de datos X e Y:

        - X: matriz de tantas filas como muestras de píxeles haya en DatosColor y DatosFondo
        y tres columnas (valores de R, G y B). Es decir, se genera concatenando verticalmente
        la información RGB de DatosColor y DatosFondo.

        - Y: vector columna con dos posibles valores: 0 y 1. El valor 0 se asignará a aquellas filas
        de X que se correspondan con muestras del fondo; el 1 es el valor de codificación que
        se utilizará para indicar que la fila de datos de X pertenece a la clase de píxeles del color
        de seguimiento.
%}

X = [datosColor(:,2:4); datosFondo(:,2:4)];

numDatosColor = size(datosColor, 1);
numDatosFondo = size(datosFondo, 1);

Y = [ones(numDatosColor, 1); zeros(numDatosFondo, 1)];

save('./02_Extraer_Representar_Datos/VariablesGeneradas/DatosX.mat', "X")
save('./02_Extraer_Representar_Datos/VariablesGeneradas/DatosY.mat', "Y")


%% 2.2 - REPRESENTACIÓN DE LOS DATOS DEL COLOR OBJETO DE SEGUIMIENTO Y OTROS COLORES DEL FONDO DE LA ESCENA

%%
%  2.2.1 - Representar en el espacio RGB, con un rango de variación 0-255 en los tres ejes, todos
%  los valores RGB de los píxeles del color de seguimiento y del fondo de la escena. En la
%  representación, utilizar distintos colores para distinguir las dos clases consideradas: color de
%  seguimiento, color/es de fondo.

clear
addpath("02_Extraer_Representar_Datos/Funciones/");
addpath("02_Extraer_Representar_Datos/VariablesGeneradas/");
load("DatosColor.mat");
load("DatosFondo.mat");
load("DatosX.mat");
load("DatosY.mat");

representa_datos_color_seguimiento_fondo(X, Y);


%% 2.3 - ELIMINACIÓN DE VALORES ATÍPICOS EN LOS DATOS DEL COLOR DE SEGUIMIENTO

%%
%  2.3.1 - Eliminar valores atípicos o outliers en las muestras de X correspondientes a los píxeles
%  del color de seguimiento. Para ello, se eliminará una instancia completa de esta clase de salida
%  (color de seguimiento) si el valor de cualquiera de sus atributos está fuera de su rango "normal"
%  de variación. Este rango se definirá para cada atributo como [Q1-1.5*RI, Q3+1.5*(Q3-Q1],
%  donde Q1 y Q3 son el primer y tercer cuartil de sus valores (ver figura).

%  2.3.2 - Generar el conjunto de datos final X e Y, sin outliers en la clase del color de seguimiento
%  (las instancias anómalas eliminadas de X también han de eliminarse en Y)

% Clase del color de seguimiento
posClaseInteres = 2;

pos_outliers = funcion_detecta_outliers_clase_interes(X,Y,posClaseInteres);

X(pos_outliers, :) = [];
Y(pos_outliers) = [];


%  2.3.3 - Representar en el espacio RGB todos los valores RGB de los píxeles del color de
%  seguimiento y del fondo de la escena del conjunto de datos final, distinguiendo las muestras del
%  color de seguimiento y las del fondo de la escena. 

representa_datos_color_seguimiento_fondo(X, Y);

save('./02_Extraer_Representar_Datos/VariablesGeneradas/DatosX.mat', "X")
save('./02_Extraer_Representar_Datos/VariablesGeneradas/DatosY.mat', "Y")
