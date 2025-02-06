% Función que recibe como entradas un punto P (vector columna) y una nube de
% puntos NP (cada columna un punto). La función devuelve un vector fila con las
% distancias de cada punto de la nube de puntos al punto P.

function vector_distancia = calcula_distancia_punto_a_nube_puntos(P, NP)

    numDatos = size(NP, 2);
    vector_distancia = zeros(1, numDatos);

    PAmp = repmat(P, 1, numDatos);
    vector_distancia = sqrt(sum((PAmp-NP).^2));

end