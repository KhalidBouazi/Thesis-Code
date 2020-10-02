# -*- coding: utf-8 -*-
"""
Created on Wed Sep 30 17:41:55 2020

@author: bouaz
"""

import numpy as np
import matplotlib.pyplot as plt
from utls import algorithms,simulations

dt = 0.001
timesteps = 100000

time_series = simulations.simulate_lorenz(dt=dt, timesteps=timesteps)
t = time_series['t']
X = time_series['X']
X_ = X[0,:]
delays = 10

dmd = algorithms.DMD()
dmd.fit(X_, dt, delays=delays, trunc_mode='rank', s_thresh=4)
X_r = dmd.reconstruct(t)
V = dmd.Vh_.conj().T

# plot original state space
fig = plt.figure(1)
ax = fig.gca(projection='3d')
ax.plot(X[0],X[1],X[2])
plt.show()

# plot first 3 delay coordinates space
fig = plt.figure(2)
ax = fig.gca(projection='3d')
ax.plot(V[:,0],V[:,1],V[:,2])
plt.show()

# plot 4th delay coordinate against X_
fig = plt.figure(3)
#plt.plot(V[:,3])
plt.plot(X_)
plt.show()

# plot singular values
# plt.figure(2)
# plt.plot(dmd.s, marker='.')
# plt.plot(dmd.s_, marker='v')

# plt.figure(1)
# plt.plot(t,X[2])
# plt.plot(t,X_r[2])
# plt.show()
