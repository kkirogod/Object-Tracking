clear
addpath("Funciones/");
addpath("VariablesRequeridas/");
% addpath("04_AjusteClasificador_ImgCalib/Funciones/");
load("parametros_clasificador.mat");

%% Marcar los píxeles de la detección en un determinado color, en lugar de los centroides

video = VideoReader("VariablesRequeridas/Video.avi");

videoSalida = VideoWriter("VideoSalida_Pixeles.avi");
videoSalida.FrameRate = video.FrameRate;

open(videoSalida)

while hasFrame(video)

    I = readFrame(video);

    %  Detectar aquellos píxeles cuyo color se considere que sea del color del seguimiento
    Ib = calcula_deteccion_multiples_esferas_en_imagen(I, datosMultiplesEsferas);

    % Eliminar las componentes conexas más pequeñas.
    [IEtiq, N] = bwlabel(Ib);
    
    if(N>0)
        Ib = bwareaopen(Ib, numPixMin);
    end

    IFinal = funcion_visualiza(I, Ib, [0 255 0], false);
    % imshow(IFinal)
    % pause(1/video.FrameRate)

    writeVideo(videoSalida, IFinal);

end

close(videoSalida)


%% Marcar el centroide de los objetos presentes (caja 3x3 de un color que la distinga).

video = VideoReader("VariablesRequeridas/Video.avi");

videoSalida = VideoWriter("VideoSalida_Centroides.avi");
videoSalida.FrameRate = video.FrameRate;

open(videoSalida)

while hasFrame(video)

    I = readFrame(video);

    %  Detectar aquellos píxeles cuyo color se considere que sea del color del seguimiento
    Ib = calcula_deteccion_multiples_esferas_en_imagen(I, datosMultiplesEsferas);

    % Eliminar las componentes conexas más pequeñas.
    [IEtiq, N] = bwlabel(Ib);

    if(N>0)
        Ib = bwareaopen(Ib, numPixMin);
    end

    stats = regionprops(Ib,'centroid');
    centroids = cat(1,stats.Centroid);

    centroids = uint8(centroids);

    if(not(isempty(centroids)))

        for i=1:size(centroids,1)

            I(centroids(i,2)-1:centroids(i,2)+1, centroids(i,1)-1:centroids(i,1)+1, 1) = 0;
            I(centroids(i,2)-1:centroids(i,2)+1, centroids(i,1)-1:centroids(i,1)+1, 2) = 0;
            I(centroids(i,2)-1:centroids(i,2)+1, centroids(i,1)-1:centroids(i,1)+1, 3) = 255;

        end

    end

    % imshow(I)

    % pause(1/video.FrameRate)

    writeVideo(videoSalida, I);

end

close(videoSalida)


%% Marcar el centroide del objeto mayor (caja 3x3 de un color que la distinga).

video = VideoReader("VariablesRequeridas/Video.avi");

videoSalida = VideoWriter("VideoSalida_CentroideObjMayor.avi");
videoSalida.FrameRate = video.FrameRate;

open(videoSalida)

while hasFrame(video)

    I = readFrame(video);

    %  Detectar aquellos píxeles cuyo color se considere que sea del color del seguimiento
    Ib = calcula_deteccion_multiples_esferas_en_imagen(I, datosMultiplesEsferas);

    % Eliminar las componentes conexas más pequeñas.
    [IEtiq, N] = bwlabel(Ib);

    if(N>0)

        for i=1:N
    
            IBAux = IEtiq == i;
            numPix = sum(IBAux(:));
            Ib = bwareaopen(Ib, numPix);
    
        end
    
    end

    stats = regionprops(Ib,'centroid');
    centroids = cat(1,stats.Centroid);

    centroids = uint8(centroids);

    if(not(isempty(centroids)))

        I(centroids(2)-1:centroids(2)+1, centroids(1)-1:centroids(1)+1, 1) = 0;
        I(centroids(2)-1:centroids(2)+1, centroids(1)-1:centroids(1)+1, 2) = 0;
        I(centroids(2)-1:centroids(2)+1, centroids(1)-1:centroids(1)+1, 3) = 255;

    end

    % imshow(I)

    % pause(1/video.FrameRate)

    writeVideo(videoSalida, I);

end

close(videoSalida)


%% 
% Marcar el centroide del objeto mayor de la detección dada por color según
% clasificador basado en esferas y movimiento (se considera un píxel en
% movimiento si la diferencia de intensidad en valor absoluto entre el valor del
% píxel en el frame actual y el anterior supera un umbral). En este caso, no utilizar
% la eliminación de componentes conectadas que no tengan un número mínimo de píxeles.

umbral = 50;

video = VideoReader("VariablesRequeridas/Video.avi");

videoSalida = VideoWriter("VideoSalida_CentroideObjMayorMov.avi");
videoSalida.FrameRate = video.FrameRate;

open(videoSalida)

FrameAnterior = readFrame(video);

while hasFrame(video)

    FrameActual = readFrame(video);

    Dif = imabsdiff(FrameActual,FrameAnterior);
    Dif_significativa = Dif > umbral;

    Ib_dif = Dif_significativa(:,:,1) | Dif_significativa(:,:,2) | Dif_significativa(:,:,3);

    I = funcion_visualiza(FrameAnterior, Ib_dif, [0 255 0], false);

    %  Detectar aquellos píxeles cuyo color se considere que sea del color del seguimiento
    Ib = calcula_deteccion_multiples_esferas_en_imagen(I, datosMultiplesEsferas);

    % Me quedo sólo con el area mayor
    [IEtiq, N] = bwlabel(Ib);

    if(N>0)

        for i=1:N
    
            IBAux = IEtiq == i;
            numPix = sum(IBAux(:));
            Ib = bwareaopen(Ib, numPix);
    
        end
    
    end

    % Saco el centroide del objeto
    stats = regionprops(Ib,'centroid');
    centroids = cat(1,stats.Centroid);

    centroids = uint8(centroids);

    if(not(isempty(centroids)))

        I(centroids(2)-1:centroids(2)+1, centroids(1)-1:centroids(1)+1, 1) = 0;
        I(centroids(2)-1:centroids(2)+1, centroids(1)-1:centroids(1)+1, 2) = 0;
        I(centroids(2)-1:centroids(2)+1, centroids(1)-1:centroids(1)+1, 3) = 255;

    end

    % imshow(I)

    % pause(1/video.FrameRate)

    FrameAnterior = FrameActual;

    writeVideo(videoSalida, I);

end

close(videoSalida)

%% Variante del anterior, marcando de otro color el movimiento del objeto

umbral = 50;

video = VideoReader("VariablesRequeridas/Video.avi");

videoSalida = VideoWriter("VideoSalida_CentroideObjMayorMov2.avi");
videoSalida.FrameRate = video.FrameRate;

open(videoSalida)

FrameAnterior = readFrame(video);

Ib_ant = zeros(size(FrameAnterior));

while hasFrame(video)

    FrameActual = readFrame(video);

    Dif = imabsdiff(FrameActual,FrameAnterior);
    Dif_significativa = Dif > umbral;

    Ib_dif = Dif_significativa(:,:,1) | Dif_significativa(:,:,2) | Dif_significativa(:,:,3);

    I = funcion_visualiza(FrameAnterior, Ib_dif, [0 255 0], false);

    %  Detectar aquellos píxeles cuyo color se considere que sea del color del seguimiento
    Ib = calcula_deteccion_multiples_esferas_en_imagen(I, datosMultiplesEsferas);

    % Me quedo sólo con el area mayor
    [IEtiq, N] = bwlabel(Ib);

    if(N>0)

        for i=1:N
    
            IBAux = IEtiq == i;
            numPix = sum(IBAux(:));
            Ib = bwareaopen(Ib, numPix);
    
        end
    
    end

    Ib_dif_obj = Ib_dif & Ib_ant;
    I = funcion_visualiza(I, Ib_dif_obj, [255 0 255], false);

    % Saco el centroide del objeto
    stats = regionprops(Ib,'centroid');
    centroids = cat(1,stats.Centroid);

    centroids = uint8(centroids);

    if(not(isempty(centroids)))

        I(centroids(2)-1:centroids(2)+1, centroids(1)-1:centroids(1)+1, 1) = 0;
        I(centroids(2)-1:centroids(2)+1, centroids(1)-1:centroids(1)+1, 2) = 0;
        I(centroids(2)-1:centroids(2)+1, centroids(1)-1:centroids(1)+1, 3) = 255;

    end

    % imshow(I)

    % pause(1/video.FrameRate)

    FrameAnterior = FrameActual;
    Ib_ant = Ib;

    writeVideo(videoSalida, I);

end

close(videoSalida)