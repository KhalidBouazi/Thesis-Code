# -*- coding: utf-8 -*-
"""
Created on Wed Sep 30 17:41:55 2020

@author: bouaz
"""

from utls import algorithms,simulations,plots

# options
dt = 0.001
timesteps = 100000
delays = 100

# simulate system
# lorenz, duffing_oscillator, rössler, vanderpol_oscillator
time_series = simulations.simulate_system('lorenz',dt=dt, timesteps=timesteps)
t = time_series['t']
X = time_series['X']

# run algorithm
dmd = algorithms.DMD()
dmd.fit(X, dt, delays=delays, trunc_mode='rank', s_thresh=5)
Xr = dmd.reconstruct(t)
Vh = dmd.Vh_

# show plots
plots.compare_orig_delay_coords(X, Vh)

plots.plot_norm_singular_values(dmd.s)

plots.compare_orig_recon_timeseries(t, X, Xr)
