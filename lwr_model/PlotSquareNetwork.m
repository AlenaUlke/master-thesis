function PlotSquareNetwork(p, tt, xx, problem)
% pl0tting the density
pmax = max(problem.pmax);
figure;
pp = cell(problem.num_roads, 1);

subplot(2,3,4)
hold on;
pp{1} = plot(xx,p(1,:,1));
outflow{1} = plot(xx(end), p(1,end,1), 'r.', 'MarkerSize', 15);
hold off;
ylim([0 pmax]); xlim([0 problem.L]);

subplot(2,3,1)
hold on;
pp{2} = plot(xx,p(2,:,1));
inflow{2} = plot(xx(1), p(2,1,1), 'r.', 'MarkerSize', 15);
outflow{2} = plot(xx(end), p(2,end,1), 'g.', 'MarkerSize', 15);
hold off;
ylim([0 pmax]); xlim([0 problem.L]);
title("Density");

subplot(2,3,5)
hold on;
pp{3} = plot(xx,p(3,:,1));
inflow{3} = plot(xx(1), p(3,1,1), 'r.', 'MarkerSize', 15);
outflow{3} = plot(xx(end), p(3,end,1), 'k.', 'MarkerSize', 15);
hold off;
ylim([0 pmax]); xlim([0 problem.L]);

subplot(2,3,6)
hold on;
pp{4} = plot(xx,p(4,:,1));
inflow{4} = plot(xx(1), p(4,1,1), 'k.', 'MarkerSize', 15);
outflow{4} = plot(xx(end), p(4,end,1), 'b.', 'MarkerSize', 15);
hold off;
ylim([0 pmax]); xlim([0 problem.L]);

subplot(2,3,2)
hold on;
pp{5} = plot(xx,p(5,:,1));
inflow{5} = plot(xx(1), p(5,1,1), 'g.', 'MarkerSize', 15);
outflow{5} = plot(xx(end), p(5,end,1), 'b.', 'MarkerSize', 15);
hold off;
ylim([0 pmax]); xlim([0 problem.L]);

subplot(2,3,3)
hold on;
pp{6} = plot(xx,p(6,:,1));
inflow{6} = plot(xx(1), p(6,1,1), 'b.', 'LineWidth', 2, 'MarkerSize', 15);
hold off;
ylim([0 pmax]); xlim([0 problem.L]);

for j = 1:length(tt)
    for i = 1:problem.num_roads
        pp{i}.YData = p(i,:,j);

        if i ~= 1
            inflow{i}.YData = p(i,1,j);
        end

        if i ~= 6
            outflow{i}.YData = p(i,end,j);
        end
    end
    pause(0.1);
    drawnow();
end

end

% % plotting the flux
%     qmax = fun.Q{1}(problem.pc(1));
%     for i = 2:problem.num_roads
%         qmax = max( qmax,  fun.Q{i}(problem.pc(i)) );
%     end
% 
%     figure;
%     qq = cell(problem.num_roads, 1);
%     subplot(2,3,4)
%     hold on;
%     qq{1} = plot(xx, fun.Q{1}(p(1,:,1)));
%     outflow{1} = plot(xx(end), fun.Q{1}(p(1,end,1)), 'r.', 'MarkerSize', 15);
%     hold off;
%     ylim([0 qmax]); xlim([0 problem.L]);
% 
%     subplot(2,3,1)
%     hold on;
%     qq{2} = plot(xx,fun.Q{2}(p(2,:,1)));
%     inflow{2} = plot(xx(1), fun.Q{2}(p(2,1,1)), 'r.', 'MarkerSize', 15);
%     outflow{2} = plot(xx(end), fun.Q{2}(p(2,end,1)), 'g.', 'MarkerSize', 15);
%     hold off;
%     ylim([0 qmax]); xlim([0 problem.L]);
%     title("Flux");
% 
%     subplot(2,3,5)
%     hold on;
%     qq{3} = plot(xx,fun.Q{3}(p(3,:,1)));
%     inflow{3} = plot(xx(1), fun.Q{3}(p(3,1,1)), 'r.', 'MarkerSize', 15);
%     outflow{3} = plot(xx(end), fun.Q{3}(p(3,end,1)), 'k.', 'MarkerSize', 15);
%     hold off;
%     ylim([0 qmax]); xlim([0 problem.L]);
% 
%     subplot(2,3,6)
%     hold on;
%     qq{4} = plot(xx, fun.Q{4}(p(4,:,1)));
%     inflow{4} = plot(xx(1), fun.Q{4}(p(4,1,1)), 'k.', 'MarkerSize', 15);
%     outflow{4} = plot(xx(end), fun.Q{4}(p(4,end,1)), 'b.', 'MarkerSize', 15);
%     hold off;
%     ylim([0 qmax]); xlim([0 problem.L]);
% 
%     subplot(2,3,2)
%     hold on;
%     qq{5} = plot(xx, fun.Q{5}(p(5,:,1)));
%     inflow{5} = plot(xx(1), fun.Q{5}(p(5,1,1)), 'g.', 'MarkerSize', 15);
%     outflow{5} = plot(xx(end), fun.Q{5}(p(5,end,1)), 'b.', 'MarkerSize', 15);
%     hold off;
%     ylim([0 qmax]); xlim([0 problem.L]);
% 
%     subplot(2,3,3)
%     hold on;
%     qq{6} = plot(xx, fun.Q{6}(p(6,:,1)));
%     inflow{6} = plot(xx(1), fun.Q{6}(p(6,1,1)), 'b.', 'MarkerSize', 15);
%     hold off;
%     ylim([0 qmax]); xlim([0 problem.L]);
% 
%     for j = 1:length(tt)
%         for i = 1:problem.num_roads
%             qq{i}.YData = fun.Q{i}(p(i,:,j));
% 
%             if i ~= 1
%                 inflow{i}.YData = fun.Q{i}(p(i,1,j));
%             end
% 
%             if i ~= 6
%                 outflow{i}.YData = fun.Q{i}(p(i,end,j));
%             end
% 
%         end
%         pause(0.1);
%         drawnow();
%     end

% if diagonal
%     subplot(3,3,7)
%     hold on;
%     pp{1} = plot(xx,p(1,:,1));
%     outflow{1} = plot(xx(end), p(1,end,1), 'r.', 'MarkerSize', 15);
%     hold off;
%     ylim([0 pmax]); xlim([0 problem.L]);
% 
%     subplot(3,3,4)
%     hold on;
%     pp{2} = plot(xx,p(2,:,1));
%     inflow{2} = plot(xx(1), p(2,1,1), 'r.', 'MarkerSize', 15);
%     outflow{2} = plot(xx(end), p(2,end,1), 'g.', 'MarkerSize', 15);
%     hold off;
%     ylim([0 pmax]); xlim([0 problem.L]);
%     title("Density");
% 
%     subplot(3,3,8)
%     hold on;
%     pp{3} = plot(xx,p(3,:,1));
%     inflow{3} = plot(xx(1), p(3,1,1), 'r.', 'MarkerSize', 15);
%     outflow{3} = plot(xx(end), p(3,end,1), 'k.', 'MarkerSize', 15);
%     hold off;
%     ylim([0 pmax]); xlim([0 problem.L]);
% 
%     subplot(3,3,6)
%     hold on;
%     pp{4} = plot(xx,p(4,:,1));
%     inflow{4} = plot(xx(1), p(4,1,1), 'k.', 'MarkerSize', 15);
%     outflow{4} = plot(xx(end), p(4,end,1), 'b.', 'MarkerSize', 15);
%     hold off;
%     ylim([0 pmax]); xlim([0 problem.L]);
% 
%     subplot(3,3,2)
%     hold on;
%     pp{5} = plot(xx,p(5,:,1));
%     inflow{5} = plot(xx(1), p(5,1,1), 'g.', 'MarkerSize', 15);
%     outflow{5} = plot(xx(end), p(5,end,1), 'b.', 'MarkerSize', 15);
%     hold off;
%     ylim([0 pmax]); xlim([0 problem.L]);
% 
%     subplot(3,3,3)
%     hold on;
%     pp{6} = plot(xx,p(6,:,1));
%     inflow{6} = plot(xx(1), p(6,1,1), 'b.', 'LineWidth', 2, 'MarkerSize', 15);
%     hold off;
%     ylim([0 pmax]); xlim([0 problem.L]);
% 
%     subplot(3,3,5)
%     hold on;
%     pp{7} = plot(xx,p(7,:,1));
%     inflow{7} = plot(xx(1), p(7,1,1), 'g.', 'LineWidth', 2, 'MarkerSize', 15);
%     outflow{7} = plot(xx(end), p(7,end,1), 'k.', 'MarkerSize', 15);
%     hold off;
%     ylim([0 pmax]); xlim([0 problem.L]);
% 
%     for j = 1:length(tt)
%         for i = 1:problem.num_roads
%             pp{i}.YData = p(i,:,j);
% 
%             if i ~= 1
%                 inflow{i}.YData = p(i,1,j);
%             end
% 
%             if i ~= 6
%                 outflow{i}.YData = p(i,end,j);
%             end
%         end
%         pause(0.1);
%         drawnow();
%     end
% 
%     % plotting the flux
%     qmax = fun.Q{1}(problem.pc(1));
%     for i = 2:problem.num_roads
%         qmax = max(qmax, fun.Q{i}(problem.pc(i)));
%     end
% 
%     figure;
%     qq = cell(problem.num_roads, 1);
%     subplot(3,3,7)
%     hold on;
%     qq{1} = plot(xx, fun.Q{1}(p(1,:,1)));
%     outflow{1} = plot(xx(end), fun.Q{1}(p(1,end,1)), 'r.', 'MarkerSize', 15);
%     hold off;
%     ylim([0 qmax]); xlim([0 problem.L]);
% 
%     subplot(3,3,4)
%     hold on;
%     qq{2} = plot(xx,fun.Q{2}(p(2,:,1)));
%     inflow{2} = plot(xx(1), fun.Q{2}(p(2,1,1)), 'r.', 'MarkerSize', 15);
%     outflow{2} = plot(xx(end), fun.Q{2}(p(2,end,1)), 'g.', 'MarkerSize', 15);
%     hold off;
%     ylim([0 qmax]); xlim([0 problem.L]);
%     title("Flux");
% 
%     subplot(3,3,8)
%     hold on;
%     qq{3} = plot(xx,fun.Q{3}(p(3,:,1)));
%     inflow{3} = plot(xx(1), fun.Q{3}(p(3,1,1)), 'r.', 'MarkerSize', 15);
%     outflow{3} = plot(xx(end), fun.Q{3}(p(3,end,1)), 'k.', 'MarkerSize', 15);
%     hold off;
%     ylim([0 qmax]); xlim([0 problem.L]);
% 
%     subplot(3,3,6)
%     hold on;
%     qq{4} = plot(xx, fun.Q{4}(p(4,:,1)));
%     inflow{4} = plot(xx(1), fun.Q{4}(p(4,1,1)), 'k.', 'MarkerSize', 15);
%     outflow{4} = plot(xx(end), fun.Q{4}(p(4,end,1)), 'b.', 'MarkerSize', 15);
%     hold off;
%     ylim([0 qmax]); xlim([0 problem.L]);
% 
%     subplot(3,3,2)
%     hold on;
%     qq{5} = plot(xx, fun.Q{5}(p(5,:,1)));
%     inflow{5} = plot(xx(1), fun.Q{5}(p(5,1,1)), 'g.', 'MarkerSize', 15);
%     outflow{5} = plot(xx(end), fun.Q{5}(p(5,end,1)), 'b.', 'MarkerSize', 15);
%     hold off;
%     ylim([0 qmax]); xlim([0 problem.L]);
% 
%     subplot(3,3,3)
%     hold on;
%     qq{6} = plot(xx, fun.Q{6}(p(6,:,1)));
%     inflow{6} = plot(xx(1), fun.Q{6}(p(6,1,1)), 'b.', 'MarkerSize', 15);
%     hold off;
%     ylim([0 qmax]); xlim([0 problem.L]);
% 
%     subplot(3,3,5)
%     hold on;
%     qq{7} = plot(xx, fun.Q{7}(p(7,:,1)));
%     inflow{7} = plot(xx(1), fun.Q{7}(p(7,1,1)), 'g.', 'LineWidth', 2, 'MarkerSize', 15);
%     outflow{7} = plot(xx(end), fun.Q{7}(p(7,end,1)), 'k.', 'MarkerSize', 15);
%     hold off;
%     ylim([0 qmax]); xlim([0 problem.L]);
% 
%     for j = 1:length(tt)
%         for i = 1:problem.num_roads
%             qq{i}.YData = fun.Q{i}(p(i,:,j));
% 
%             if i ~= 1
%                 inflow{i}.YData = fun.Q{i}(p(i,1,j));
%             end
% 
%             if i ~= 6
%                 outflow{i}.YData = fun.Q{i}(p(i,end,j));
%             end
%         end
%         pause(0.1);
%         drawnow();
%     end