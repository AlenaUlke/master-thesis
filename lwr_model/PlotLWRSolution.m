function PlotLWRSolution(p, tt, xx, problem, type)
switch type
    case "single"
        figure;
        pp = cell(problem.num_roads, 1);
        subplot(1,1,1)
        pp{1} = plot(xx,p(1,:,1)); %rho{1}(:,1));
        ylim([0 problem.pmax]); xlim([0 problem.L]);
        title("Density");    

        for j = 1:length(tt)
            for i = 1:problem.num_roads
                pp{i}.YData = p(i,:,j);
            end
            pause(0.1);
            drawnow();
        end
    case "1to1"
        figure;
        pp = cell(problem.num_roads, 1);
        subplot(1,2,1)
        pp{1} = plot(xx,p(1,:,1)); %rho{1}(:,1));
        ylim([0 max(problem.pmax)]); xlim([0 problem.L]);
        title("Density");

        subplot(1,2,2)
        pp{2} = plot(xx,p(2,:,1));
        ylim([0 max(problem.pmax)]); xlim([0 problem.L])

        for j = 1:length(tt)
            for i = 1:problem.num_roads
                pp{i}.YData = p(i,:,j);
            end
            pause(0.1);
            drawnow();
        end
    case "2to1"
        figure;
        pp = cell(problem.num_roads, 1);
        subplot(2,2,1)
        pp{1} = plot(xx,p(1,:,1));
        ylim([0 max(problem.pmax)]); xlim([0 problem.L]);
        title("Density");

        subplot(2,2,3)
        pp{2} = plot(xx,p(2,:,1));
        ylim([0 max(problem.pmax)]); xlim([0 problem.L])

        subplot(2,2,4)
        pp{3} = plot(xx,p(3,:,1));
        ylim([0 max(problem.pmax)]); xlim([0 problem.L])

        for j = 1:length(tt)
            for i = 1:problem.num_roads
                pp{i}.YData = p(i,:,j);
            end
            pause(0.1);
            drawnow();
        end

    case "1to2"
        figure;
        pp = cell(problem.num_roads, 1);
        subplot(2,2,1)
        pp{1} = plot(xx,p(1,:,1));
        ylim([0 max(problem.pmax)]); xlim([0 problem.L]);
        title("Density");

        subplot(2,2,2)
        pp{2} = plot(xx,p(2,:,1));
        ylim([0 max(problem.pmax)]); xlim([0 problem.L])

        subplot(2,2,4)
        pp{3} = plot(xx,p(3,:,1));
        ylim([0 max(problem.pmax)]); xlim([0 problem.L])

        for j = 1:length(tt)
            for i = 1:problem.num_roads
                pp{i}.YData = p(i,:,j);
            end
            pause(0.1);
            drawnow();
        end

    otherwise
        error("Type '" + type + "' is not an option!");
end

end