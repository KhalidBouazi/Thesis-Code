# -*- coding: utf-8 -*-
"""
Created on Tue Oct  6 11:57:40 2020

@author: bouaz
"""

import matplotlib.pyplot as plt
import numpy as np

    
def compare_orig_delay_coords(X, Vh, dims=None):
    
    # set dimensions to be plotted
    if dims == None or (dims != None and X.shape[0] < len(dims)):
        dims = range(X.shape[0])
    else:
        dims = np.sort(dims)
    
    fig = plt.figure(figsize=plt.figaspect(0.5))
    ax1 = None
    ax2 = None
    
    if len(dims) == 3:
        ax1 = fig.add_subplot(121, projection='3d')
        ax2 = fig.add_subplot(122, projection='3d')
        ax1.set_xlabel('x1')
        ax1.set_ylabel('x2')
        ax1.set_zlabel('x3')
        ax2.set_xlabel('v1')
        ax2.set_ylabel('v2')
        ax2.set_zlabel('v3')
        ax1.set_zticks([])
        ax2.set_zticks([])
        
    elif len(dims) == 2:
        ax1 = fig.add_subplot(121)
        ax2 = fig.add_subplot(122)
        ax1.set_xlabel('x1')
        ax1.set_ylabel('x2')
        ax2.set_xlabel('v1')
        ax2.set_ylabel('v2')
        
    else:
        raise ValueError('Number of dimensions to plot should be 2 or 3.')

    ax1.set_xticks([])
    ax1.set_yticks([])
    ax2.set_xticks([])
    ax2.set_yticks([])
    ax1.grid('off')
    ax2.grid('off')
    ax1.set_title('Originale Koordinaten')
    ax2.set_title('Time-Delay Koordinaten')
    
    ax1.plot(*X[dims,:])
    ax2.plot(*Vh[dims,:])
    
    plt.show()
    
def plot_norm_singular_values(s):
    
    plt.figure()
    
    # normalize singular values
    s_norm = s/(np.sqrt(np.sum(s**2)))

    plt.plot(s_norm, marker='.', linestyle='None')
    plt.xlabel('Rang')
    plt.ylabel('Normierter Singulärwert')
    
    plt.show()
    
def compare_orig_recon_timeseries(t, X, X_, dims=None):
    
    # set dimensions to be plotted
    if dims == None:
        dims = range(X.shape[0])
    else:    
        dims = np.sort(dims)
        
    fig = plt.figure()
    
    for i in range(len(dims)):
        ax = fig.add_subplot(len(dims),1,i+1)
        ax.plot(t,X[dims[i],:])
        ax.plot(t,X_[dims[i],:])
        ax.set_xlabel('Zeit in s')
        ax.set_ylabel('x'+str(i+1))
    
    plt.show()
    
# def plot_intermittent_force(t, x):
    
        
    








