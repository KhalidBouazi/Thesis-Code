# -*- coding: utf-8 -*-
"""
Created on Tue Oct  6 11:57:40 2020

@author: bouaz
"""

import matplotlib.pyplot as plt
import matplotlib.cm as cm
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
    
def plot_singular_values(s, norm=True):
    
    plt.figure()
    
    # normalize singular values
    if norm:
        s = s / np.linalg.norm(s, 2)

    plt.plot(s, marker='.', linestyle='None')
    plt.xlabel('Rang')
    plt.ylabel('Normierter Singulärwert')
    
    plt.tight_layout()
    plt.show()
    
def compare_orig_recon_timeseries(t, X, X_, dims=None, overlay=False):
    
    # shorten, because X_ may be time-delayed and shorter than X
    t = t[range(X_.shape[1])]
    X = X[:,range(X_.shape[1])]
    
    # set dimensions to be plotted
    if dims == None:
        dims = range(X.shape[0])
    else:    
        dims = np.sort(dims)
        
    fig = plt.figure()
    
    if not overlay:
        for i in range(2*len(dims)):
            j = int(np.floor(i/2))
            ax = fig.add_subplot(len(dims), 2, i+1)
            if np.mod(i,2) == 0:
                ax.plot(t,X[dims[j],:],'tab:blue', linewidth=2)
                ax.set_ylabel('x'+str(j+1))
            else:
                ax.plot(t,X_[dims[j],:],'tab:orange', linewidth=2)
                ax.set_ylabel('z'+str(j+1))
            ax.set_xlabel('Zeit in s')
    else:
        for i in range(len(dims)):
            ax = fig.add_subplot(len(dims), 1, i+1)
            ax.plot(t,X[dims[i],:], linewidth=2)
            ax.plot(t,X_[dims[i],:], linewidth=2)
            ax.set_xlabel('Zeit in s')
            ax.legend(['x'+str(i+1), 'z'+str(i+1)], loc='upper right')
    
    plt.tight_layout()
    plt.show()
    

def plot_recon_timeseries(t, X_, dims=None):
    
    # shorten, because X_ may be time-delayed and shorter than X
    t = t[range(X_.shape[1])]
    
    # set dimensions to be plotted
    if dims == None:
        dims = range(X_.shape[0])
    else:    
        dims = np.sort(dims)
        
    fig = plt.figure()
    
    for i in range(len(dims)):
        ax = fig.add_subplot(len(dims), 1, i+1)
        ax.plot(t,X_[dims[i],:], linewidth=2)
        ax.set_xlabel('Zeit in s')
        ax.set_ylabel('z'+str(i+1))
    
    plt.tight_layout()
    plt.show()
    
    
def plot_prediction(t_train, X_train, t_test, X_test, X_pred, dims=None):
    
    if dims == None:
        dims = range(X_train.shape[0]) 
    else:    
        dims = np.sort(dims)
    
    fig = plt.figure()
    
    for i in range(len(dims)):
        ax = fig.add_subplot(len(dims), 1, i+1)
        plt.plot(t_train, X_train[i], color='#666666', linewidth=2)
        plt.plot(t_test, X_test[i], '--', color='#666666', alpha=0.8, linewidth=2)
        plt.plot(t_test, X_pred[i], '--', color='red', alpha=0.8, linewidth=2)
        ax.set_xlabel('Zeit in s')
        ax.legend(['x_train_'+str(i+1), 'x_test_'+str(i+1), 'x_pred_'+str(i+1)], loc='upper left')
    
    plt.tight_layout()
    plt.show()
    
    
def show_matrix_pattern(A):
    
    plt.figure()
    
    plt.imshow(np.real(A), interpolation='nearest', cmap=plt.get_cmap('bwr'))
    
    a = max(np.max(np.real(A)),abs(np.min(np.real(A))))
    plt.axis('off')
    plt.colorbar()
    plt.clim([-a,a])
    
    plt.tight_layout()
    plt.show()
    

def plot_mode_amplitudes(omega, b):
    
    plt.figure()
    
    idxs = np.argsort(np.imag(omega))
    idxs = idxs[int(np.ceil(idxs.size/2)):]
    plt.plot(np.imag(omega[idxs]), np.abs(b[idxs]), 'o:', color='red', linewidth=2)
    
    plt.tight_layout()
    plt.show()
    

def plot_con_eigs(omega):
    
    plt.figure()
    
    margin = 0.1
    
    plt.axis([min(np.real(omega))-margin,0.5,min(np.imag(omega))-margin,max(np.imag(omega))+margin])
    plt.plot([min(np.real(omega))-margin, 0.5], [0, 0], '--', color='#666666', linewidth=1)
    plt.plot([0, 0], [min(np.imag(omega))-margin, max(np.imag(omega))+margin], '--', color='#666666', linewidth=1)
    plt.plot(np.real(omega), np.imag(omega), 'x', color='red')
    
    plt.tight_layout()
    plt.show()
    
    
def plot_disc_eigs(d):
    
    plt.figure()
    
    theta = np.linspace(0,2*np.pi,1000)
    
    margin_h = (max(np.real(d)) - min(np.real(d)))*0.1
    margin_v = (max(np.imag(d)) - min(np.imag(d)))*0.1

    plt.axis([min(np.real(d))-margin_h,max(np.real(d))+margin_h,min(np.imag(d))-margin_v,max(np.imag(d))+margin_v])
    plt.plot(np.cos(theta), np.sin(theta), linewidth=2, color='#666666')
    plt.plot(np.real(d), np.imag(d), 'o', color='red')
    
    plt.tight_layout()
    plt.show()

# def plot_intermittent_force(t, x):
    
def plot_svd_modes(U):
    
    plt.figure()
    
    plt.plot(U)
    
    plt.tight_layout()
    plt.show()
    
    
def plot_U_modes_on_phase(X, U, dims=None):
    
    if dims == None:
        dims = range(U.shape[1]) 
    else:    
        dims = np.sort(dims)
        
    fig = plt.figure()
    
    for i in range(len(dims)):
        ax = fig.add_subplot(1, len(dims), 1+i, projection='3d')
        col = U[:,i].T
        col = np.abs(col/np.max(col))
        ax.plot_surface(X[0,:], X[1,:], X[2,:], facecolors=cm.jet(col), linewidth=0, antialiased=False)
    
    plt.show()


def plot_Phi_modes(Phi, dims=None):
    
    if dims == None:
        dims = range(Phi.shape[0]) 
    else:    
        dims = np.sort(dims)
        
    plt.figure()
    
    for i in range(len(dims)):
        plt.plot(Phi[i,:])
        
    plt.show()








