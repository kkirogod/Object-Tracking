function representa_deteccion_esferas_imagen_calib(imagenesEntrenamiento, datosMultiplesEsferas)

    for i=1:size(imagenesEntrenamiento,4)

        I = imagenesEntrenamiento(:,:,:,i);
        
        representa_deteccion_multiples_esferas_en_imagen(I, datosMultiplesEsferas)
    
        pause;

    end

end

