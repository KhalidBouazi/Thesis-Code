# -*- coding: utf-8 -*-
"""
Created on Wed Sep 30 17:41:55 2020

@author: bouaz
"""

import numpy as np
from numpy.linalg import matrix_power
import scipy as sp
import matplotlib.pyplot as plt
from utls import *

dt = 0.001
timesteps = 100000

time_series = simulate_lorenz(dt=dt, timesteps=timesteps)

t = time_series['t']
X = time_series['X']
Y = time_series['Y']

U_, s_, Vh_, U, s, Vh, A, d, W, Phi, b = dmd(X,Y,trunc_mode='rank',s_thresh=2)

print(Phi)
print(b)
print(d)

d = np.imag(d)*1j
print(d)

x = lambda k : Phi @ matrix_power(np.diag(d),k-1) @ b

print(Phi @ matrix_power(np.diag(d),1) @ b)

horizon = 10000
k_predict = np.linspace(1,horizon,horizon) + timesteps
t_predict = k_predict * dt

X_p = []
for i in range(horizon):
    #print(x(int(k_predict[i])))
    X_p.append(x(int(k_predict[i])))
X_p = np.array(X_p).T

plt.figure(1)
plt.plot(t,X[0,:])
plt.plot(t_predict,np.real(X_p[0,:]))
plt.show()
