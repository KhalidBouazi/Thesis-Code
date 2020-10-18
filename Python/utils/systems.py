# -*- coding: utf-8 -*-
"""
Created on Wed Oct  7 13:10:38 2020

@author: bouaz
"""

import numpy as np

# constants
g = 9.81

# system equations
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
    dx : array
        DESCRIPTION.

    '''
    dx = lambda t,x: [sigma*(x[1] - x[0])/tau,
                     (x[0]*(rho - x[2]) - x[1])/tau,
                     (x[0]*x[1] - beta*x[2])/tau]

    return dx

def duffing(alpha, beta, delta, omega, tau):
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
    dx : array
        differential equation.

    '''
    dx = lambda t,x : [x[1]/tau,
                      (-delta*x[1] - alpha*x[0] - beta*x[0]**3)/tau]

    return dx

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
    dx : array
        differential equation.

    '''
    dx = lambda t,x : [(-x[1] - x[2])/tau,
                      (x[0] + a*x[1])/tau,
                      (b + x[2]*(x[0] - c))/tau]

    return dx

def vanderpol(mu, tau):
    '''
    

    Parameters
    ----------
    mu : double
        DESCRIPTION.
    tau : double
        DESCRIPTION.

    Returns
    -------
    dx : array
        differential equation.

    '''
    dx = lambda t,x : [x[1]/tau,
                      (mu*(1-x[0]**2)*x[1] - x[0])/tau] # + beta*u
    
    return dx

def pendulum(l):
    '''
    

    Parameters
    ----------
    l : double
        pendulum length.

    Returns
    -------
    dx : array
        differential equation.

    '''
    dx = lambda t, x : [x[1],
                       -9.81/l * np.sin(x[0])]
    
    return dx

def doubletank(A1, A2, q1, q2, u):
    '''
    

    Parameters
    ----------
    A1 : double
        DESCRIPTION.
    A2 : double
        DESCRIPTION.
    q1 : double
        DESCRIPTION.
    q2 : double
        DESCRIPTION.
    u  : double
        DESCRIPTION.

    Returns
    -------
    dx : array
        differential equation.

    '''
    dx = lambda t, x : [(-q1*np.sqrt(2*g*(x[0] - x[1])) + u)/A1,
                       (q1*np.sqrt(2*g*(x[0] - x[1])) - q2*np.sqrt(2*g*x[1]))/A2]

    return dx

def trippletank(A1, A2, A3, q1, q2, q3, u):
    '''
    

    Parameters
    ----------
    A1 : double
        DESCRIPTION.
    A2 : double
        DESCRIPTION.
    A3 : double
        DESCRIPTION.
    q1 : double
        DESCRIPTION.
    q2 : double
        DESCRIPTION.
    q3 : double
        DESCRIPTION.
    u  : array
        DESCRIPTION.

    Returns
    -------
    dx : array
        differential equation.

    '''
    dx = lambda t, x : [(-q1*np.sqrt(2*g*(x[0] - x[1])) + u[0])/A1,
                       (q1*np.sqrt(2*g*(x[0] - x[1])) + q3*np.sqrt(2*g*(x[2] - x[1])) - q2*np.sqrt(2*g*x[1]))/A2,
                       (-q3*np.sqrt(2*g*(x[2] - x[1])) + u[1])/A3]

    return dx
