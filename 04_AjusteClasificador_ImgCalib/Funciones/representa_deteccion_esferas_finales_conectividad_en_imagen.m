function representa_deteccion_esferas_finales_conectividad_en_imagen(I, datosMultiplesEsferas, numPixMin)

    centroides = datosMultiplesEsferas(:, 1:3);
    radios = datosMultiplesEsferas(:, 4:6);
    
    for j=1:3

        centro_radio = [centroides, radios(:, j)];
        
        Ib = calcula_deteccion_multiples_esferas_en_imagen(I, centro_radio);
        [IEtiq, N] = bwlabel(Ib);

        if(N>0)
            Ib = bwareaopen(Ib, numPixMin);
        end

        Ir = funcion_visualiza(I, Ib, [0 255 0], false);
        subplot(2,2,j+1), imshow(Ir), title(['Radio ' num2str(j)]);
    end

end

