function ExperimentsRevision

addpath 'C:\Users\aulke\bwSyncShare\Master\Masterarbeit\Code\experiments';
addpath 'C:\Us ers\aulke\bwSyncShare\Master\Masterarbeit\Code\optimization';
addpath 'C:\Users\aulke\bwSyncShare\Master\Masterarbeit\Code\lwr_model';
addpath 'C:\Users\aulke\bwSyncShare\Master\Masterarbeit\Code\lwr_model\internal';
addpath 'C:\Users\aulke\bwSyncShare\Master\Masterarbeit\Code\emission_model';
addpath 'C:\Users\aulke\bwSyncShare\Master\Masterarbeit\Code\emission_model\internal';
addpath 'C:\Users\aulke\bwSyncShare\Master\Masterarbeit\Code\dispersion_model';
addpath 'C:\Users\aulke\bwSyncShare\Master\Masterarbeit\Code\dispersion_model\internal';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% kappa = 0.1

kappa = 0.1
% Problem: min (J_diff, -J_flow)
[traffic, junctions, dispersion, emission, opts] ...
    = InitializeModels;
dispersion.kappa = kappa;

V_lower = 0.25 * ones(traffic.num_roads, 1);
V_upper = 2 * ones(traffic.num_roads, 1);

[V_FluxEco, J_FluxEco] = ParetoFrontFluxEco(traffic, junctions, emission, ...
    dispersion, opts, V_lower, V_upper);

save ResultsFluxEco_kappa01_review V_FluxEco J_FluxEco;
disp("kappa = " + num2str(kappa) + ": min(J_diff, -J_flow) finished")

%%
% Problem min (J_diff + J_queue, -J_flow)
[V_FluxEcoWithQueue, J_FluxEcoWithQueue] = ParetoFrontFluxEcoWithQueue(traffic, junctions, emission, ...
    dispersion, opts, V_lower, V_upper);

save ResultsFluxEcoWithQueue_kappa01_review V_FluxEcoWithQueue J_FluxEcoWithQueue;
disp("kappa = " + num2str(kappa) + ": min(J_diff + J_queue, -J_flow) finished")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% kappa = 1

clear all
kappa = 1

% Problem: min (J_diff, -J_flow)
[traffic, junctions, dispersion, emission, opts] ...
    = InitializeModels;
dispersion.kappa = kappa;

V_lower = 0.25 * ones(traffic.num_roads, 1);
V_upper = 2 * ones(traffic.num_roads, 1);

[V_FluxEco, J_FluxEco] = ParetoFrontFluxEco(traffic, junctions, emission, ...
    dispersion, opts, V_lower, V_upper);

save ResultsFluxEco_kappa1_review V_FluxEco J_FluxEco;
disp("kappa = " + num2str(kappa) + ": min(J_diff, -J_flow) finished")

% Problem min (J_diff + J_queue, -J_flow)
[V_FluxEcoWithQueue, J_FluxEcoWithQueue] = ParetoFrontFluxEcoWithQueue(traffic, junctions, emission, ...
    dispersion, opts, V_lower, V_upper);

save ResultsFluxEcoWithQueue_kappa1_review V_FluxEcoWithQueue J_FluxEcoWithQueue;
disp("kappa = " + num2str(kappa) + ": min(J_diff + J_queue, -J_flow) finished")


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% kappa = 0
% 
% clear all;
% kappa = 0
% 
% Problem: min (J_diff, -J_flow)
% [traffic, junctions, dispersion, emission, opts] ...
%     = InitializeModels;
% dispersion.kappa = kappa;
% 
% V_lower = 0.25 * ones(traffic.num_roads, 1);
% V_upper = 2 * ones(traffic.num_roads, 1);
% 
% [V_FluxEco, J_FluxEco] = ParetoFrontFluxEco(traffic, junctions, emission, ...
%     dispersion, opts, V_lower, V_upper);
% 
% save ResultsFluxEco_kappa0_review V_FluxEco J_FluxEco;
% disp("kappa = " + num2str(kappa) + ": min(J_diff, -J_flow) finished")
% 
% Problem min (J_diff + J_queue, -J_flow)
% [V_FluxEcoWithQueue, J_FluxEcoWithQueue] = ParetoFrontFluxEcoWithQueue(traffic, junctions, emission, ...
%     dispersion, opts, V_lower, V_upper);
% 
% save ResultsFluxEcoWithQueue_kappa0_review V_FluxEcoWithQueue J_FluxEcoWithQueue;
% disp("kappa = " + num2str(kappa) + ": min(J_diff + J_queue, -J_flow) finished")

end
