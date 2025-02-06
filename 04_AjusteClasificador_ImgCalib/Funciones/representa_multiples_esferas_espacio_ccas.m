function representa_multiples_esferas_espacio_ccas(centroides, radios)

    for i=1:size(centroides, 1)

        centroideColor = centroides(i, :);
    
        representa_esfera(centroideColor, radios(i));

    end

end