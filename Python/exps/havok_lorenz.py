# -*- coding: utf-8 -*-
"""
Created on Tue Oct  6 13:51:21 2020

@author: bouaz
"""

import numpy as np
from utils import algorithms,simulations,plots

# options
dt = 0.01
timesteps = 10000
delays = 500
#u = np.ones((2,timesteps+1))*0.01

# simulate system
# lorenz, duffing, rössler, vanderpol, pendulum, doubletank, trippletank
t_train, X_train, t_test, X_test = simulations.simulate_system('lorenz', dt, timesteps)
X_ = X_train[0,:]

# run algorithm
havok = algorithms.HAVOK()
havok.fit(X_, dt, delays=delays, trunc_mode='rank', s_thresh=20)

# show plots
#plots.compare_orig_delay_coords(X_train, havok.Vh_)

#plots.plot_singular_values(havok.s)

#plots.compare_orig_recon_timeseries(t_train, X_train, havok.Vh_)

#plots.plot_recon_timeseries(t_train, havok.Vh_, dims=[0,1,2])

#plots.plot_svd_modes(havok.U_)

plots.plot_Phi_modes(havok.Phi)


