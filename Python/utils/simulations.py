# -*- coding: utf-8 -*-
"""
Created on Sun Sep 20 16:21:23 2020

@author: bouaz
"""

import numpy as np
from scipy.integrate import solve_ivp
from utils import systems

def simulate_system(system, dt, timesteps, x0=None,  params=None, u=None, train_split=0.6):
    '''
    

    Parameters
    ----------
    system : string
        system to be simulated.
    dt : double
        sample time.
    timesteps : TYPE
        number of time steps.
    x0 : array, optional
        initial value. The default is None.
    params : array, optional
        system parameters. The default is None.

    Raises
    ------
    ValueError
        DESCRIPTION.

    Returns
    -------
    time_series : array
        series with time and data.

    '''
    
    # extract params and initial value
    params = get_system_params(system, params)
    x0 = get_initial_value(system, x0)
            
    # simulate system
    t_end = dt*timesteps
    t_eval = np.linspace(0, t_end, timesteps+1)
    x = np.zeros((len(x0), len(t_eval)))
    
    if u is None:
        fun = get_system_fun(system, params)
        sol = solve_ivp(fun, [0, t_end], x0, t_eval=t_eval)
        x = sol.y
    else:
        if u.ndim == 1:
            u.shape = (1, len(u))
            
        if u.shape[1] != timesteps+1:
            raise ValueError('Input u does not have the right width.')
        
        x[:,0] = x0
        for i in range(1,timesteps+1):
            fun = get_system_fun(system, params, u[:,i-1])
            t_span = [t_eval[i-1], t_eval[i]]
            sol = solve_ivp(fun, t_span, x0)
            x0 = sol.y[:,1]
            x[:,i] = x0
        
    # split data in train and test data
    train_idx = range(0,int(train_split*timesteps))
    test_idx = range(int(train_split*timesteps),timesteps+1)
        
    return t_eval[train_idx], x[:,train_idx], t_eval[test_idx], x[:,test_idx]      

def get_system_params(system, params):
    '''
    

    Parameters
    ----------
    system : string
        system to be simulated.
    params : array
        system parameters.

    Raises
    ------
    ValueError
        DESCRIPTION.

    Returns
    -------
    params : TYPE
        system parameters.

    '''
    
    if system == 'lorenz':
        
        if params == None:
            params = [10., 28., 8/3, 1.]
        elif len(params) != 4:
            raise ValueError('Check your system parameters. You need {sigma, rho, beta, tau}.')
            
    elif system == 'duffing':
        
        if params == None:
            params = [1., 1, 0., 1., 1.]
        elif len(params) != 6:
            raise ValueError('Check your system parameters. You need {alpha, beta, delta, omega, tau}.')
            
    elif system == 'rössler': 
        
        if params == None:
           params = [0.2, 0.2, 5.7, 1.]
        elif len(params) != 4:
            raise ValueError('Check your system parameters. You need {a, b, c, tau}.')
            
    elif system == 'vanderpol':
        if params == None:
            params = [5., 1.]
        elif len(params) != 2:
            raise ValueError('Check your system parameters. You need {mu, tau}.')
    
    elif system == 'pendulum':
        if params == None:
            params = [1]
        elif len(params) != 1:
            raise ValueError('Check your system parameters. You need {l}.')
    
    elif system == 'doubletank':
        if params == None:
            Ai = (0.14**2)*np.pi/4
            params = [Ai, Ai, 21.8e-6, 41e-6]
        elif len(params) != 4:
            raise ValueError('Check your system parameters. You need {A1, A2, q1, q2}.')
            
    elif system == 'trippletank':
        if params == None:
            Ai = (0.14**2)*np.pi/4
            params = [Ai, Ai, Ai, 21.8e-6, 41e-6, 21.8e-6]
        elif len(params) != 6:
            raise ValueError('Check your system parameters. You need {A1, A2, A3, q1, q2, q3}.')
    
    else:
        raise ValueError('There is no system ' + system + '.')
        
    return params

def get_system_fun(system, params, u=None):
    '''
    

    Parameters
    ----------
    system : string
        system to be simulated.
    params : array
        system parameters.

    Returns
    -------
    fun : array
        system equations.

    '''
    
    if system == 'lorenz':  
        fun = systems.lorenz(*params)
            
    elif system == 'duffing':
        fun = systems.duffing(*params)
            
    elif system == 'rössler': 
        fun = systems.rössler(*params)
      
    elif system == 'vanderpol':
        fun = systems.vanderpol(*params)
        
    elif system == 'pendulum':
        fun = systems.pendulum(*params)
        
    elif system == 'doubletank':
        if u is None:
            u = 0.
        elif len(u) != 1:
            raise ValueError('u must be real and of dimension 1.')
        
        fun = systems.doubletank(*params, u)

    elif system == 'trippletank':
        if u is None:
            u = [0., 0.]
        elif len(u) != 2:
            raise ValueError('u must be real and of dimension 2.')
            
        fun = systems.trippletank(*params, u)
        
    return fun

def get_initial_value(system, x0):
    '''
    

    Parameters
    ----------
    system : string
        system to be simulated.
    x0 : array
        initial value.

    Raises
    ------
    ValueError
        DESCRIPTION.

    Returns
    -------
    x0 : array
        initial value.

    '''
    
    if system == 'lorenz':
        if x0 is None:
            x0 = [-8, 7, 27]
        elif len(x0) != 3:
            raise ValueError('Check your initial value. You need dimension 3.')
            
    elif system == 'duffing':
        if x0 is None:
            x0 = [1., 0.]
        elif len(x0) != 3:
            raise ValueError('Check your initial value. You need dimension 2.')
            
    elif system == 'rössler': 
        if x0 is None:
            x0 = [0, 10, 0]
        elif len(x0) != 3:
            raise ValueError('Check your initial value. You need dimension 3.')
            
    elif system == 'vanderpol':
        if x0 is None:
            x0 = [2., 0.]
        elif len(x0) != 2:
            raise ValueError('Check your initial value. You need dimension 2.')
            
    elif system == 'pendulum':
        if x0 is None:
            x0 = [np.pi/4, 0.]
        elif len(x0) != 2:
            raise ValueError('Check your initial value. You need dimension 2.')
     
    elif system == 'doubletank':
        if x0 is None:
            x0 = [.5, .3]
        elif len(x0) != 2:
            raise ValueError('Check your initial value. You need dimension 2.')
            
    elif system == 'trippletank':
        if x0 is None:
            x0 = [.5, .3, .6]
        elif len(x0) != 3:
            raise ValueError('Check your initial value. You need dimension 3.')
    
    return x0
        
        