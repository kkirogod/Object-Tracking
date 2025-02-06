% Recibe como entradas el centro (centroide, vector con 3 valores) y radio de la
% esfera a representar. La función representa con plot3 la esfera de ese centro
% y radio.

function representa_esfera(centro, radio)
    
    [R,G,B] = sphere(40);

    Rc = centro(1);
    Gc = centro(2);
    Bc = centro(3);

    % Matrices de puntos de una esfera centrada en el origen de radio unidad
    x = radio*R(:)+Rc; y = radio*G(:)+Gc; z = radio*B(:)+Bc;

    %figure;
    plot3(x,y,z, '.g')

end

