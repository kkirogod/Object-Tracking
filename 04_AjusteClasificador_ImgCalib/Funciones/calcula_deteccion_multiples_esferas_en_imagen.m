% Recibe como entradas una imagen RGB(I) y un vector con 4 valores
% correspondientes al centro y radio de una esfera (centro_radio). La función
% devuelve una matriz lógica de las mismas dimensiones que la imagen, donde el
% '1' binario se corresponde con los píxeles de la imagen cuyos valores RGB que
% se sitúan en el interior de la esfera en cuestión.

function Ib = calcula_deteccion_multiples_esferas_en_imagen(I, centroides_radios)

    Ib = zeros(size(I,1), size(I,2));
    
    for i=1:size(centroides_radios, 1)

        Ib2 = calcula_deteccion_1esfera_en_imagen(I, centroides_radios(i, :));

        Ib = Ib | Ib2;

    end

end


%%
% Recibe como entradas una imagen RGB(I) y un vector con 4 valores
% correspondientes al centro y radio de una esfera (centro_radio). La función
% devuelve una matriz lógica de las mismas dimensiones que la imagen, donde el
% '1' binario se corresponde con los píxeles de la imagen cuyos valores RGB que
% se sitúan en el interior de la esfera en cuestión.

function Ib_deteccion_por_distancia = calcula_deteccion_1esfera_en_imagen(I, centro_radio)

    R = double(I(:,:,1));
    G = double(I(:,:,2));
    B = double(I(:,:,3));
    
    Rc = centro_radio(1);
    Gc = centro_radio(2);
    Bc = centro_radio(3);

    MatrizDist = sqrt((R-Rc).^2 + (G-Gc).^2 + (B-Bc).^2 );

    Radio = centro_radio(4);

    Ib_deteccion_por_distancia = MatrizDist < Radio;

end

