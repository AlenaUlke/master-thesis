function SolveSingleObjectiveProblems
% add internal code to matlab path
addpath './optimization';
addpath './lwr_model';
addpath './lwr_model/internal';
addpath './emission_model';
addpath './emission_model/internal';
addpath './dispersion_model';
addpath './dispersion_model/internal';


[traffic, junctions, dispersion, emission, opts] ...
    = InitializeModels;

V_lower = 0.25 * ones(traffic.num_roads, 1);
V_upper = 2 * ones(traffic.num_roads, 1);

[J_eco, V_Eco, J_ecoqueue, V_ecoqueue, J_flow, V_flow] ...
    = IndividualOptimization(traffic, junctions, emission, ...
    dispersion, opts, V_lower, V_upper);

save "ResultsFluxEco" J_eco V_Eco J_ecoqueue V_ecoqueue J_flow V_flow;

end