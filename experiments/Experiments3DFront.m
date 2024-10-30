function Experiments3DFront

addpath 'C:\Users\aulke\bwSyncShare\Master\Masterarbeit\Code\experiments';
addpath 'C:\Users\aulke\bwSyncShare\Master\Masterarbeit\Code\optimization';
addpath 'C:\Users\aulke\bwSyncShare\Master\Masterarbeit\Code\lwr_model';
addpath 'C:\Users\aulke\bwSyncShare\Master\Masterarbeit\Code\lwr_model\internal';
addpath 'C:\Users\aulke\bwSyncShare\Master\Masterarbeit\Code\emission_model';
addpath 'C:\Users\aulke\bwSyncShare\Master\Masterarbeit\Code\emission_model\internal';
addpath 'C:\Users\aulke\bwSyncShare\Master\Masterarbeit\Code\dispersion_model';
addpath 'C:\Users\aulke\bwSyncShare\Master\Masterarbeit\Code\dispersion_model\internal';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% kappa = 0

kappa = 0
% Problem: min (-J_flow, J_diff, J_queue)
[traffic, junctions, dispersion, emission, opts] ...
    = InitializeModels;
dispersion.kappa = kappa;

V_lower = 0.25 * ones(traffic.num_roads, 1);
V_upper = 2 * ones(traffic.num_roads, 1);

[V_3D, J_3D] = ParetoFrontFlowDiffQueue(traffic, junctions, emission, ...
    dispersion, opts, V_lower, V_upper);

save Results3D_Pareto_review V_3D J_3D;
disp("kappa = " + num2str(kappa) + ": min(-J_flow, J_diff, J_queue) finished")

%%
% single objectives Problem min (J_diff + J_queue, -J_flow)
% [V_Queue, J_Queue] = MinimizeQueue(traffic, junctions, ...
%     emission, opts, V_lower, V_upper);
% 
% save Results3D_Pareto_single_review V_Queue J_Queue;
% disp("kappa = " + num2str(kappa) + ": min J_queue finished")
% 

end
