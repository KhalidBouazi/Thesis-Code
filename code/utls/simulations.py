# -*- coding: utf-8 -*-
"""
Created on Sun Sep 20 16:21:23 2020

@author: bouaz
"""

import numpy as np
from scipy.integrate import solve_ivp

def lorenz(sigma, rho, beta, tau):
    '''
    

    Parameters
    ----------
    sigma : double
        DESCRIPTION.
    rho : double
        DESCRIPTION.
    beta : double
        DESCRIPTION.
    tau : double
        DESCRIPTION.

    Returns
    -------
    f : TYPE
        DESCRIPTION.

    '''
    f = lambda t,x: [sigma*(x[1] - x[0])/tau,
                     (x[0]*(rho - x[2]) - x[1])/tau,
                     (x[0]*x[1] - beta*x[2])/tau]

    return f

def duffing_oscillator(alpha, beta, gamma, delta, omega, tau):
    '''
    

    Parameters
    ----------
    alpha : double
        DESCRIPTION.
    beta : double
        DESCRIPTION.
    gamma : double
        DESCRIPTION.
    delta : double
        DESCRIPTION.
    omega : double
        DESCRIPTION.
    tau : double
        DESCRIPTION.

    Returns
    -------
    f : array
        differential equation.

    '''
    f = lambda t,x : [x[1]/tau,
                      (-delta*x[1] - alpha*x[0] - beta*x[0]**3 + gamma*np.cos(x[2]))/tau,
                      omega]

    return f

def rössler(a, b, c, tau):
    '''
    

    Parameters
    ----------
    a : double
        DESCRIPTION.
    b : double
        DESCRIPTION.
    c : double
        DESCRIPTION.
    tau : double
        DESCRIPTION.

    Returns
    -------
    f : array
        differential equation.

    '''
    f = lambda t,x : [(-x[1] - x[2])/tau,
                      (x[0] + a*x[1])/tau,
                      (b + x[2]*(x[0] - c))/tau]

    return f

def vanderpol_oscillator(mu, tau):
    '''
    

    Parameters
    ----------
    mu : double
        DESCRIPTION.
    tau : double
        DESCRIPTION.

    Returns
    -------
    f : array
        differential equation.

    '''
    f = lambda t,x : [x[1]/tau,
                      (mu*(1-x[0]**2)*x[1] - x[0])/tau] # + beta*u
    
    return f

def simulate_system(system, dt, timesteps, x0=None, params=None):
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
    
    # extract params, system equation and initial value
    params = get_system_params(system, params)
    fun = get_system_fun(system, params)
    x0 = get_initial_value(system, x0)
            
    # simulate
    t_end = dt*timesteps
    sol = solve_ivp(fun, [0, t_end], x0, t_eval=np.linspace(0, t_end, timesteps+1))
        
    time_series = {'X': sol.y, 't': sol.t}

    return time_series     

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
            
    elif system == 'duffing_oscillator':
        
        if params == None:
            params = [1., 1, 0., 0., 1., 1.]
        elif len(params) != 6:
            raise ValueError('Check your system parameters. You need {alpha, beta, gamma, delta, omega, tau}.')
            
    elif system == 'rössler': 
        
        if params == None:
           params = [0.2, 0.2, 5.7, 1.]
        elif len(params) != 4:
            raise ValueError('Check your system parameters. You need {a, b, c, tau}.')
            
    elif system == 'vanderpol_oscillator':
        if params == None:
            params = [10., 1.]
        elif len(params) != 2:
            raise ValueError('Check your system parameters. You need {mu, tau}.')
            
    return params

def get_system_fun(system, params):
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
        
        fun = lorenz(*params)
            
    elif system == 'duffing_oscillator':
        
        fun = duffing_oscillator(*params)
            
    elif system == 'rössler': 
        
        fun = rössler(*params)
      
    elif system == 'vanderpol_oscillator':

        fun = vanderpol_oscillator(*params)
            
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
            
    elif system == 'duffing_oscillator':
        
        if x0 is None:
            x0 = [1., 0., 0.]
        elif len(x0) != 3:
            raise ValueError('Check your initial value. You need dimension 3.')
            
    elif system == 'rössler': 
        
        if x0 is None:
            x0 = [0, 10, 0]
        elif len(x0) != 3:
            raise ValueError('Check your initial value. You need dimension 3.')
            
    elif system == 'vanderpol_oscillator':

        if x0 is None:
            x0 = [2.,0.]
        elif len(x0) != 2:
            raise ValueError('Check your initial value. You need dimension 2.')
            
    return x0
        
        