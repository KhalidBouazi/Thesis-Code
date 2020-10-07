# -*- coding: utf-8 -*-
"""
Created on Tue Oct  6 13:51:21 2020

@author: bouaz
"""

from utls import algorithms,simulations,plots

# options
dt = 0.001
timesteps = 100000
delays = 100

# simulate system
# lorenz, duffing, rössler, vanderpol, pendulum
time_series = simulations.simulate_system('lorenz', dt=dt, timesteps=timesteps)
t_train = time_series['t_train']
X_train = time_series['X_train']
t_test = time_series['t_test']
X_test = time_series['X_test']
X_ = X_train[0,:]

# run algorithm
havok = algorithms.HAVOK()
havok.fit(X_, dt, delays=delays, trunc_mode='rank', s_thresh=15)
Vh = havok.Vh_

# show plots
#plots.compare_orig_delay_coords(X_train, Vh)

#plots.plot_norm_singular_values(havok.s)

#plots.compare_orig_recon_timeseries(t_train, X_train, Vh)

#plots.plot_recon_timeseries(t_train, Vh, dims=[0,1,2])

