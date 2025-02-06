%% 1. GENERACIÓN DE MATERIAL

%%
%  1.1 - Secuencia de video para evaluar el funcionamiento del algoritmo de seguimiento:
%  generar un archivo de video con el objeto de estudio moviéndose por una determinada
%  región del espacio.

% ALMACENAR LA SECUENCIA DE VIDEO PROCESADA EN UN ARCHIVO AVI
clear
video=videoinput('winvideo',3,'YUY2_320x240'); %
video.ReturnedColorSpace = 'rgb';
video.TriggerRepeat=inf; % disparos continuados
% Se debe trabajar entorno a 10 fps
fpsMaximoWebCam = 30; % Decidir los fps de trabajo de la WebCam
video.FrameGrabInterval=3;
fpsTrabajoWebCam = round(fpsMaximoWebCam/video.FrameGrabInterval);
set(video, 'LoggingMode', 'memory')

%preview(video)

% Crear objeto archivo avi
% aviobj = VideoWriter('Ejemplo.avi', 'Uncompressed AVI');
aviobj = VideoWriter('Video.avi');
aviobj.FrameRate = fpsTrabajoWebCam;
duracionGrabacion = 15; % duracion en segundos
numFramesGrabacion = duracionGrabacion*aviobj.FrameRate;
open(aviobj)
start(video)
for i=1:numFramesGrabacion
I=getdata(video,1); % captura un frame guardado en memoria.
% imshow(255-I)
writeVideo(aviobj,I);
end
stop(video)
close(aviobj);

%%
%  1.2 - Imágenes de calibración: capturar varias imágenes con el objeto situado en distintas
%  posiciones representativas de la región del espacio que queramos monitorizar, así como
%  una imagen representativa del fondo de la escena (sin el objeto, en la situación más
%  parecida a las imágenes que se hicieron con el objeto).


numImagenes = 12;
imagenesEntrenamiento = zeros(240, 320, 3, numImagenes, 'uint8');

preview(video);

for i=1:numImagenes
    disp("Pulsa una tecla para sacar la captura " + i + "...");
    pause;
    I = getsnapshot(video);
    imagenesEntrenamiento(:,:,:,i) = I;
end

save('./01_GenereacionMaterial/MaterialGenerado/ImagenesEntrenamiento.mat', "imagenesEntrenamiento")