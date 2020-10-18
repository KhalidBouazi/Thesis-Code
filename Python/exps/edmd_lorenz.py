# -*- coding: utf-8 -*-
"""
Created on Wed Sep 30 17:41:55 2020

@author: bouaz
"""

from utils import algorithms,simulations,plots,observables

# options
dt = 0.01
timesteps = 80000
psi = observables.monomials(2)

# simulate system
# lorenz, duffing, rössler, vanderpol, pendulum, doubletank, trippletank
t_train, X_train, t_test, X_test = simulations.simulate_system('vanderpol', dt, timesteps)

# run algorithm
edmd = algorithms.EDMD()
edmd.fit(X_train, dt, psi)

# show plots
plots.plot_con_eigs(edmd.omega)
plots.plot_disc_eigs(edmd.d)

plots.show_matrix_pattern(edmd.A)