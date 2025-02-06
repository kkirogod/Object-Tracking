function representa_datos_color_seguimiento_fondo(X, Y)

    figure;
    plot3(X(Y==1, 1), X(Y==1, 2), X(Y==1, 3), '.r');
    hold on;
    plot3(X(Y==0, 1), X(Y==0, 2), X(Y==0, 3), '.b');
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