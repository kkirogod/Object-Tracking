%{
    1.- Calcula centroide de la nube de puntos del color de seguimiento: Rc,Gc,Bc
    2.- Calcula los vectores distancias entre el centroide anterior y cada uno de
        los puntos de XColor y XFondo:
        - Por una parte los valores de distancia entre el centroide y las muestras
        del color del objeto dadas por XColor
        - Por otra, los valores de distancia entre el centroide y las muestras de
        fondo dadas por XFondo.
    3.- Calcular r1 y r2 a partir de los vectores distancia anteriores (ver
        apartado de la práctica 3.1)
    4.- Calcular el radio de compromiso r12
    5.- Devolver datosEsfera = [Rc, Gc, Bc, r1, r2, r12] (vector fila)
%}

function datosEsfera = calcula_datos_esfera(XColor, XFondo)
    
    % 1.
    centroideColor = mean(XColor);
    Rc = centroideColor(1);
    Gc = centroideColor(2);
    Bc = centroideColor(3);
    
    % 2. 3.
    P = centroideColor';
    NPC = XColor';
    
    vector_distancia_color = calcula_distancia_punto_a_nube_puntos(P, NPC);
    
    r1 = max(vector_distancia_color);
    
    NPF = XFondo';
    
    vector_distancia_fondo = calcula_distancia_punto_a_nube_puntos(P, NPF);
    
    r2 = min(vector_distancia_fondo);

    % 4.
    r12 = (r1 + r2) / 2;

    % 5.
    datosEsfera = [Rc, Gc, Bc, r1, r2, r12];

end

