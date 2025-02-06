function pos_outliers = funcion_detecta_outliers_clase_interes(X,Y,posClaseInteres)

    % ESTA MAL, SUSTITUIR POR LA DE MOODLE

    valores = unique(Y);
    XoI = X(Y==valores(posClaseInteres),:);

    XB = XoI(:,3);
        
    out = XB < 120;
        
    pos_outliers = find(out);
    
    pos_outliers = unique(sort(pos_outliers));

end