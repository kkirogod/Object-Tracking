function Io = funcion_visualiza(I, Ib, color, flagRepresenta, varargin)

    [nF, nC, numComp] = size(I);

    if(numComp==1)
        R = I;
        G = I;
        B = I;

    else
        R = I(:, :, 1);
        G = I(:, :, 2);
        B = I(:, :, 3);


    end

    R(Ib) = color(1);
    G(Ib) = color(2);
    B(Ib) = color(3);

    Io = cat(3, R,G,B);

    if nargin==4 & flagRepresenta
        figure, imshow(Io);
    end

end