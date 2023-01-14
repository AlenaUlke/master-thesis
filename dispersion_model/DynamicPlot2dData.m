function DynamicPlot2dData(w, xx, yy, Nt, plot_title, varargin)
if length(varargin) == 2
    w_min = varargin{1};
    w_max = varargin{2};
else
    w_min = min(min(min(w)));
    w_max = max(max(max(w)));
end

figure;
[X,Y] = meshgrid(xx, yy);
for k = 1:Nt+1
    h = surf(Y, X, w(:,:,k),'EdgeColor','none'); 
    shading interp
    view(2)
    axis ([xx(1) xx(end) yy(1) yy(end) w_min w_max])
    colorbar; caxis([w_min w_max]);
    title(plot_title); %['time (\itt) = ',num2str((k-1)*dt)]})
    xlabel('x \rightarrow')
    ylabel('y {\rightarrow}')
    zlabel('value of adjoint')
    drawnow; 
    refreshdata(h)
end
end