% this function makes a "realistic" multi-compartment
% model neuron 
% the gemoetry is a cable, and parameters are somewhat
% epxerimentally constrained 

function x = make_realistic_neuron()

axial_resitivity = 1e-3; % MOhm mm; 

% geometry is a cylinder
r_neurite = .01; % default value
L_neurite = .35*5; % mm, from Otopalik et al
r_soma = .025;
L_soma = .05; % mm, Jason's guesstimates
phi = 1;

shell_thickness = .01; % 10 micrometres

x = xolotl;
x.skip_hash = true;
	% make 3 neurons
	x.add('Soma','compartment','radius',r_soma,'len',L_soma,'phi',phi,'Ca_out',3000,'Ca_in',0.05,'tree_idx',0,'shell_thickness',shell_thickness);
	x.add('Neurite','compartment','radius',r_neurite,'len',L_neurite,'phi',phi,'Ca_out',3000,'Ca_in',0.05,'shell_thickness',shell_thickness);

	prefix = 'prinz-approx/';
	channels = {'ACurrent','CaS','CaT','HCurrent','KCa','Kd','NaV'};
	g =           [500;     100;   25 ;   1;      10;   1e3;  1500];
	E =           [-80;      30;   30;   -20;     -80;   -80;  50 ];

	compartments = x.find('compartment');
	for i = 1:length(channels)
		for j = 1:length(compartments)
			x.(compartments{j}).add([prefix channels{i}],'gbar',g(i),'E',E(i));

		end
	end

	x.Soma.NaV.gbar = 0;

	x.slice('Neurite',4);

	comp_names = x.find('compartment');
	start_axon = 2;
	for i = 1:start_axon
		x.(comp_names{i}).NaV.gbar = 0;
	end

	x.connect('Neurite','Soma');

x.skip_hash = false; x.sha1hash;


x.dt = .1;
x.sim_dt = .1;
x.t_end = 5e3;


% x.integrate;
% [V,Ca] = x.integrate;

% figure('outerposition',[300 300 1200 900],'PaperUnits','points','PaperSize',[1200 900]); hold on
% subplot(2,1,1); hold on
% time = 1e-3*(1:length(V))*x.dt;
% plot(time,V(:,end-1),'k')
% set(gca,'YLim',[-80 40])
% title('Axial resitivity = 1 k Ohm mm')
% ylabel('V_{terminal} (mV)')
% subplot(2,1,2); hold on
% plot(time,V(:,end),'k')
% set(gca,'YLim',[-80 40])
% xlabel('Time (s)')
% ylabel('V_{soma} (mV)')

% prettyFig('plw',1.5);
