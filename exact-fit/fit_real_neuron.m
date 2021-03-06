
load('isolated_PD')
V0 = V;
T = 1e3;
V = filtfilt(ones(T,1),T,V);
V = V(1:9e4);
V0 = V0(1:9e4);
dV = [NaN; diff(V)];
dV0 = [NaN; diff(V0)];




% first just fit the slow wave
x = make_bursting_soma;


p = procrustes('particleswarm');
p.x = x;

p.parameter_names = {'CellBody.ACurrent.gbar', 'CellBody.CaS.gbar', 'CellBody.CaT.gbar', 'CellBody.HCurrent.gbar', 'CellBody.KCa.gbar' , 'CellBody.Kd.gbar' , 'CellBody.Leak.gbar' ,'CellBody.Ca'};

p.data.slow_wave = V;

M = length(p.parameter_names);

seed = x.get(p.parameter_names);


% neuron conductances
%      A   CaS  CaT   H    KCa  Kd    Leak  Ca    
ub = [1e3  600  200  10   2e3   1e3   10    3e3 ];
lb = [0    0    0    0    0     0     0     0.05];



p.lb = lb;
p.ub = ub;

p.sim_func = @slow_wave_cost_func;

load('../bursting-soma/bursting_soma_dalek.local.mat')

i = 1;

p.seed = [all_g(:,i); .05];



return




figure('outerposition',[300 300 1200 600],'PaperUnits','points','PaperSize',[1200 600]); hold on

subplot(1,2,1); hold on
plot(V0,'k')
plot(V,'r')
set(gca,'XLim',[1e3 2e4])
subplot(1,2,2); hold on
plot(V,dV)


N = xolotl.findNSpikes(V,-30);
spiketimes = xolotl.findNSpikeTimes(V,N,-30);



x = make2C;


p = procrustes('particleswarm');
p.x = x;

p.data.LeMassonMatrix = procrustes.V2matrix(V,[-80 50],[-20 30]);
p.data.V = V;
p.data.spiketimes = spiketimes;

p.parameter_names = [x.find('Neurite*gbar'); x.find('CellBody*gbar'); 'Neurite.tau_Ca'; 'Neurite.Ca'; 'synapses(1).resistivity'; 'temperature'];

M = length(p.parameter_names);

%         A    CaS  CaT   H    KCa    Kd   Leak      NaV 
g_ub =  [500  60   100    .1    100   2e3   1        0];
g_lb =  [10   10   10     .001  10    100   1e-3     0];

% neuron conductances

p.ub = [g_ub g_ub(1:end-1) 200 3e3 .01   30];
p.lb = [g_lb g_lb(1:end-1) 20  .05 .0001 -10] ;


p.seed = rand(M,1).*p.ub(:); % random seed

p.sim_func = @exact_fit_cost_func;
p.options.MaxTime = 300;




