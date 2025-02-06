function [idx, centroides] = funcion_kmeans(X, K)

    numDatos = size(X, 1);

    indSemillas = randsample(1:numDatos, K);

    C_ini = X(indSemillas, :);

    idx_ini = funcion_calcula_agrupacion(X, C_ini);

    hayCambio = true;

    while hayCambio

        centroides = funcion_calcula_centroides(X, idx_ini);
        idx = funcion_calcula_agrupacion(X, centroides);
        
        var = funcion_compara_matrices(idx_ini, idx);

        hayCambio = not(var);

        if(hayCambio)
            idx_ini = idx;
        end

    end

end



function idx = funcion_calcula_agrupacion(X, centroides)

    numDatos = size(X, 1);
    numAgrup = size(centroides, 1);

    idx = zeros(numDatos, 1);

    matrizD = zeros(numAgrup, numDatos);

    NP = X';

    for i=1:numAgrup

        punto = centroides(i,:)';
        matrizD(i,:) = calcula_distancia_punto_a_nube_puntos(punto, NP);

    end

    for i=1:numDatos

        v = matrizD(:,i);

        [vmin, ind] = min(v);

        idx(i) = ind;

    end

end



function centroides = funcion_calcula_centroides(X, idx)

    numAgrup = max(idx);
    numDim = size(X,2);
    centroides = zeros(numAgrup, numDim);

    for i=1:numAgrup

        X_i = X(idx == i, :);
        centroides(i,:) = mean(X_i);

    end

end