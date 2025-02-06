function representa_deteccion_esferas_finales_conectividad_imagen_calib(imagenesEntrenamiento, datosMultiplesEsferas, numPixMin)
       
    for i=1:size(imagenesEntrenamiento, 4)
    
        I = imagenesEntrenamiento(:,:,:,i);
        figure, subplot(2,2,1), imshow(I), title(['Imagen ' num2str(i)]);
        
        representa_deteccion_esferas_finales_conectividad_en_imagen(I, datosMultiplesEsferas, numPixMin)

        pause

    end

end