# -*- coding: utf-8 -*-
"""
Created on Sun Sep 20 16:21:23 2020

@author: bouaz
"""

import numpy as np
from scipy.integrate import ode

def lorenz(sigma, rho, beta, tau):
    '''
    Creates function and jacobi matrix of lorenz system

    :params: sigma, rho, beta, tau
    '''
    f = lambda t,x: [sigma*(x[1] - x[0])/tau,
                     (x[0]*(rho - x[2]) - x[1])/tau,
                     (x[0]*x[1] - beta*x[2])/tau]
    jac = lambda t,x: [[-sigma/tau, sigma/tau, 0.],
                       [(rho - x[2])/tau, -1/tau, -x[0]/tau],
                       [x[1]/tau, x[0]/tau, -beta/tau]]
    return f,jac

def simulate_lorenz(dt, timesteps, x0=None, sigma=10., rho=28., beta=8/3, tau=1.):
    '''
    Simulates lorenz system

    :param dt: sample time
    :param timesteps: time steps
    :param x0: initial value
    :params: sigma, rho, beta, tau 
    :return: time series
    '''
    if x0 is None:
        x0 = [-8, 7, 27]
        
    f, jac = lorenz(sigma, rho, beta, tau)
    r = ode(f,jac).set_integrator('zvode', method='bdf')
    r.set_initial_value(x0,t=0.0)
    
    t = [0.0]
    x = [x0]
    while r.successful() and len(x) < timesteps:
        r.integrate(r.t + dt)
        x.append(np.real(r.y))
        t.append(r.t)
        
    timeseries = {'X': np.array(x).T, 't': np.array(t)}

    return timeseries     
        
        
        
        
        