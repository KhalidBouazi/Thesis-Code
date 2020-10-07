# -*- coding: utf-8 -*-
"""
Created on Wed Sep 30 17:41:55 2020

@author: bouaz
"""

from utls import algorithms,simulations,plots

# options
dt = 0.001
timesteps = 100000
delays = 128

# simulate system
# lorenz, duffing, rössler, vanderpol
time_series = simulations.simulate_system('vanderpol',dt=dt, timesteps=timesteps)
t_train = time_series['t_train']
X_train = time_series['X_train']
t_test = time_series['t_test']
X_test = time_series['X_test']

# run algorithm
dmd = algorithms.DMD()
dmd.fit(X_train, dt, delays=delays, trunc_mode='rank', s_thresh=24)
X_pred = dmd.reconstruct(t_test)
Vh = dmd.Vh_

# show plots
#plots.compare_orig_delay_coords(X_train, Vh)

#plots.plot_norm_singular_values(dmd.s)

#plots.compare_orig_recon_timeseries(t_train, X_train, X_pred, overlay=True)

#plots.plot_prediction(t_train, X_train[0,:], t_test, X_test[0,:], X_pred[0,:])

plots.plot_mode_amplitudes(dmd.omega, dmd.b)