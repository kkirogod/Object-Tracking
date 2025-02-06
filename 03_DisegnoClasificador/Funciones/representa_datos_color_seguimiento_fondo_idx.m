function representa_datos_color_seguimiento_fondo(X, Y, idx)

    XColor = double(X(Y==1,:));

    X1 = XColor(idx==1, :);
    X2 = XColor(idx==2, :);
    X3 = XColor(idx==3, :);
    X4 = XColor(idx==4, :);

    figure;

    plot3(X1(:, 1), X1(:, 2), X1(:, 3), '.r');
    hold on;

    plot3(X2(:, 1), X2(:, 2), X2(:, 3), '.g');
    hold on;

    plot3(X3(:, 1), X3(:, 2), X3(:, 3), '.y');
    hold on;

    plot3(X4(:, 1), X4(:, 2), X4(:, 3), '.b');
    hold on;

    plot3(X(Y==0, 1), X(Y==0, 2), X(Y==0, 3), '.k');
    %hold on;
    %plot3(X(pos_outliers, 1), X(pos_outliers, 2), X(pos_outliers, 3), '.y');
    xlabel('Rojo');
    ylabel('Verde');
    zlabel('Azul');
    title('Representación en el espacio RGB');
    legend('Color de seguimiento', 'Fondo');
    grid on;
    %hold off;

end