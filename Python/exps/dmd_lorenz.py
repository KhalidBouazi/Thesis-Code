# -*- coding: utf-8 -*-
"""
Created on Wed Sep 30 17:41:55 2020

@author: bouaz
"""

from utils import algorithms,simulations,plots

# options
dt = 0.01
timesteps = 80000
delays = 128

# simulate system
# lorenz, duffing, rössler, vanderpol, pendulum, doubletank, trippletank
t_train, X_train, t_test, X_test = simulations.simulate_system('vanderpol', dt, timesteps)

# run algorithm
dmd = algorithms.DMD()
dmd.fit(X_train, dt, delays=delays, trunc_mode='rank', s_thresh=30) ###
X_pred = dmd.reconstruct(t_test)

# show plots
#plots.compare_orig_delay_coords(X_train, dmd.Vh_)

#plots.plot_singular_values(dmd.s)

#plots.plot_U_modes_on_phase(X_train, dmd.U, [0,1,2])

#plots.compare_orig_recon_timeseries(t_train, X_train, X_pred, overlay=True)

plots.plot_prediction(t_train, X_train, t_test, X_test, X_pred)

#plots.plot_mode_amplitudes(dmd.omega, dmd.b)

#plots.show_matrix_pattern(dmd.A_tilde)

#plots.plot_con_eigs(dmd.omega)
#plots.plot_disc_eigs(dmd.d)

plots.plot_Phi_modes(dmd.Phi)
