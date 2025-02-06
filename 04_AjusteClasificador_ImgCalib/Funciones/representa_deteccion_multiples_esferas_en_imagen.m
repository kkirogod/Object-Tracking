function representa_deteccion_multiples_esferas_en_imagen(I, datosMultiplesEsferas)

    Ib_r1 = calcula_deteccion_multiples_esferas_en_imagen(I, datosMultiplesEsferas(:,1:4));
    Ib_r2 = calcula_deteccion_multiples_esferas_en_imagen(I, datosMultiplesEsferas(:,[1:3 5]));
    Ib_r12 = calcula_deteccion_multiples_esferas_en_imagen(I, datosMultiplesEsferas(:,[1:3 6]));
    
    Io_r1 = funcion_visualiza(I, Ib_r1, [0 255 0], 1, 0);
    Io_r2 = funcion_visualiza(I, Ib_r2, [0 255 0], 1, 0);
    Io_r12 = funcion_visualiza(I, Ib_r12, [0 255 0], 1, 0);
    
    subplot(2,2,1), imshow(I);
    title("Imagen Original");
    subplot(2,2,2), imshow(Io_r1);
    title("Radio 1");
    subplot(2,2,3), imshow(Io_r2);
    title("Radio 2");
    subplot(2,2,4), imshow(Io_r12);
    title("Radio 12");

end