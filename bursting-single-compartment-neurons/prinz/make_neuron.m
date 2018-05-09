function x =  make_neuron_liu()

% conversion from Prinz to phi
vol = 1; % this can be anything, doesn't matter
f = 14.96; % uM/nA
tau_Ca = 200;
F = 96485; % Faraday constant in SI units
phi = (2*f*F*vol)/tau_Ca;

x = xolotl;
x.add('AB','compartment','V',-65,'Ca',0.02,'Cm',10,'A',0.0628,'vol',vol,'phi',phi,'Ca_out',3000,'Ca_in',0.05,'tau_Ca',tau_Ca);
x.AB.add('liu/NaV','gbar',1000,'E',50);
x.AB.add('liu/CaT','gbar',25,'E',30);
x.AB.add('liu/CaS','gbar',60,'E',30);
x.AB.add('liu/ACurrent','gbar',500,'E',-80);
x.AB.add('liu/KCa','gbar',50,'E',-80);
x.AB.add('liu/Kd','gbar',1000,'E',-80);
x.AB.add('liu/HCurrent','gbar',.1,'E',-20);

x.t_end = 20e3;
x.dt = .1;
x.sim_dt = .1;