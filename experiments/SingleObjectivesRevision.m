function SingleObjectivesRevision

addpath 'C:\Users\aulke\bwSyncShare\Master\Masterarbeit\Code\experiments';
addpath 'C:\Users\aulke\bwSyncShare\Master\Masterarbeit\Code\optimization';
addpath 'C:\Users\aulke\bwSyncShare\Master\Masterarbeit\Code\lwr_model';
addpath 'C:\Users\aulke\bwSyncShare\Master\Masterarbeit\Code\lwr_model\internal';
addpath 'C:\Users\aulke\bwSyncShare\Master\Masterarbeit\Code\emission_model';
addpath 'C:\Users\aulke\bwSyncShare\Master\Masterarbeit\Code\emission_model\internal';
addpath 'C:\Users\aulke\bwSyncShare\Master\Masterarbeit\Code\dispersion_model';
addpath 'C:\Users\aulke\bwSyncShare\Master\Masterarbeit\Code\dispersion_model\internal';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% kappa = 0.05
clear all;
kappa = 0.05

[traffic, junctions, dispersion, emission, opts] ...
    = InitializeModels;
dispersion.kappa = kappa;

V_lower = 0.25 * ones(traffic.num_roads, 1);
V_upper = 2 * ones(traffic.num_roads, 1);

[J_eco, V_Eco, J_ecoqueue, V_ecoqueue, J_flow, V_flow] ...
    = IndividualOptimization(traffic, junctions, emission, ...
    dispersion, opts, V_lower, V_upper);

save ResultsSingelObjective_kappa005_review J_eco V_Eco J_ecoqueue V_ecoqueue J_flow V_flow;
disp("kappa = " + num2str(kappa) + ": single objectives finished")

%% kappa = 0.01
clear all;
kappa = 0.01

[traffic, junctions, dispersion, emission, opts] ...
    = InitializeModels;
dispersion.kappa = kappa;

V_lower = 0.25 * ones(traffic.num_roads, 1);
V_upper = 2 * ones(traffic.num_roads, 1);
dispersion.kappa = kappa;

[J_eco, V_Eco, J_ecoqueue, V_ecoqueue, J_flow, V_flow] ...
    = IndividualOptimization(traffic, junctions, emission, ...
    dispersion, opts, V_lower, V_upper);

save ResultsSingelObjective_kappa001_review J_eco V_Eco J_ecoqueue V_ecoqueue J_flow V_flow;
disp("kappa = " + num2str(kappa) + ": single objectives finished")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% kappa = 0
clear all;
kappa = 0

[traffic, junctions, dispersion, emission, opts] ...
    = InitializeModels;
dispersion.kappa = kappa;

V_lower = 0.25 * ones(traffic.num_roads, 1);
V_upper = 2 * ones(traffic.num_roads, 1);
dispersion.kappa = kappa;

[J_eco, V_Eco, J_ecoqueue, V_ecoqueue, J_flow, V_flow] ...
    = IndividualOptimization(traffic, junctions, emission, ...
    dispersion, opts, V_lower, V_upper);

save ResultsSingelObjective_kappa0_review J_eco V_Eco J_ecoqueue V_ecoqueue J_flow V_flow;
disp("kappa = " + num2str(kappa) + ": single objectives finished")

end
