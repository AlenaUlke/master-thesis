function DynamicPlot2dData(w, xx, yy, Nt, Nlwr, image_title, varargin)
if length(varargin) == 2
    w_min = varargin{1};
    w_max = varargin{2};
else
    w_min = min(min(min(w)));
    w_max = max(max(max(w)));
end

figure;
c = gray;
c = flipud(c);
colormap(c);
[X,Y] = meshgrid(xx, yy);

for k = 1:20:Nt+1
    Z = w(:,:,k);
    h = surf(Y, X, w(:,:,k),'EdgeColor','none'); 

    hold on;
    Z = w_max* ones(size(w(:,:,k)));
    plot3(X(Nlwr+1,1:2*Nlwr+2), Y(Nlwr+1,1:2*Nlwr+2), Z(Nlwr+1,1:2*Nlwr+2),'LineWidth',2,'Color','r')
    plot3(X(2*(Nlwr+1),Nlwr:3*Nlwr), Y(2*(Nlwr+1),Nlwr:3*Nlwr), Z(2*(Nlwr+1),Nlwr:3*Nlwr),'LineWidth',2,'Color','r')
    plot3(X(Nlwr+1:2*Nlwr+2,2*(Nlwr+1)), Y(Nlwr+1:2*Nlwr+2,2*(Nlwr+1)), Z(Nlwr+1:2*Nlwr+2,2*(Nlwr+1)),'LineWidth',2,'Color','r')
    plot3(X(Nlwr+1:2*Nlwr+2,(Nlwr+1)), Y(Nlwr+1:2*Nlwr+2,(Nlwr+1)), Z(Nlwr+1:2*Nlwr+2,(Nlwr+1)),'LineWidth',2,'Color','r')

    shading interp
    view(2)
    axis ([xx(1) xx(end) yy(1) yy(end) w_min w_max])
    colorbar; caxis([w_min w_max]);
    
    box on; grid on; 
    set(gca,'xtick',[], 'ytick',[])
    hold off;

%saveas(gcf, image_title + "-" + num2str(k) + ".jpg");

    drawnow; 
    refreshdata(h)
end
end