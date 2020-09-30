# -*- coding: utf-8 -*-
"""
Created on Sun Sep 20 14:05:53 2020

@author: bouaz
"""

import numpy as np
import scipy.linalg as la
from .utils import hankel_matrix

def compute_dmd_rank(S, trunc_method, threshold=None):
    
    # INPUT =======================================================================
    # S                     matrix of singular values
    # trunc_method          method for truncation
    # threshold?            truncation threshold for singular values             
    # =============================================================================
    
    # OUTPUT ======================================================================
    # rank                  truncation rank of S            
    # =============================================================================
    
    if trunc_method == 'soft':
        if threshold is None:
            raise ValueError('Threshold must be defined for soft threshold truncation method')
        rank = np.where(S > threshold)[0].size
    else:
        if threshold is None:
            rank = S.size
        else:
            rank = threshold
    
    return rank

def compute_real_dmd_modes(Phi, omega, b):
    
    # INPUT =======================================================================
    # Phi                   dmd modes
    # omega                 continuous dmd eigenvalues
    # b                     mode amplitudes             
    # =============================================================================
    
    # OUTPUT ======================================================================
    # Phi_real              real dmd modes           
    # omega_real            continuous dmd eigenvalues          
    # b                     mode amplitudes           
    # =============================================================================
    
    Phi_real = np.zeros(Phi.shape)
    omega_real = []
    omega_imag = []
    
    b_tmp = []
    
    omega_idx = np.arange(omega.size)
    omega_copy = omega.copy()
    
    i = 0
    while i < omega.size:
        if np.iscomplex(omega_copy[0]):
            Phi_real[:,i] = 2*np.real(Phi[:,omega_idx[0]])
            Phi_real[:,i+1] = -2*np.real(Phi[:,omega_idx[0]])
            omega_real.append(np.real(omega_copy[0]))
            omega_imag.append(np.imag(omega_copy[0]))
            omega_real.append(np.real(omega_copy[0]))
            omega_imag.append(-np.imag(omega_copy[0]))
            b_tmp.append(b[omega_idx[0]])
            b_tmp.append(b[omega_idx[0]].conj())
            
            conj_idx = np.argsort(np.abs(np.conj(omega_copy[0]) - omega_copy))[0]
            
            mask = np.ones(omega_idx.size, dtype=bool)
            mask[[0, conj_idx]] = False
            omega_idx = omega_idx[mask]
            omega_copy = omega_copy[mask]
            i += 2
        else:
            Phi_real[:, i] = np.real(Phi[:, omega_idx[0]])
            omega_real.append(np.real(omega_copy[0]))
            omega_imag.append(0.0)
            b_tmp.append(np.real(b[omega_idx[0]]))
            omega_idx = omega_idx[1:]
            omega_copy = omega_copy[1:]
            i += 1
            
    omega = np.vstack((np.array(omega_real), np.array(omega_imag)))
    b = np.array(b_tmp)
    
    return Phi_real, omega, b
            
class DMD:
    def  __init__(self, trunc_method='hard', threshold=None, n_delay_coords=1, spacing=1):
        
        # INPUT =======================================================================
        # trunc_method?         method for truncation
        # threshold?            truncation threshold for singular values
        # n_delay_coords?       number of delay coordinates        
        # spacing?              number of sample time shifts between 2 data samples    
        # =============================================================================
        
        self.trunc_method = trunc_method
        if self.trunc_method == 'soft' and threshold is None:
            self.threshold = 1e-10
        else:
            self.threshold = threshold
        self.n_delay_coords = n_delay_coords
        self.spacing = spacing
        
    def fit(self, X_fit, dt, real=None, t0=0.0, sample_spacing=1, dt_scale=1):
    
        # INPUT =======================================================================
        # X_fit                 data matrix
        # dt                    sample time
        # real?                          
        # t0?                    
        # sample_spacing?      
        # dt_scale?             
        # =============================================================================
    
        self.dt = dt
        
        if real is None:
            self.real = np.where(np.iscomplex(X_fit))[0].size < 1
        else:
            self.real = real
            
        if self.n_delay_coords > 1:
            H = hankel_matrix(X_fit, n_delay_coords=self.n_delay_coords, spacing=self.spacing)
            X = H[:,:-dt_scale:sample_spacing]
            X_ = H[:,dt_scale::sample_spacing]
        else:
            X = X_fit[:,:-dt_scale:sample_spacing]
            X_ = X_fit[:,dt_scale::sample_spacing]
            
        # compute svd and truncation rank
        U,S,Vt = la.svd(X, full_matrices=False)
        rank = compute_dmd_rank(S, self.trunc_method, threshold=self.threshold)
        self.rank = rank
        
        # compute dmd matrix
        U = U[:,:rank]
        S = S[:rank]
        V = Vt[:rank].conj().T
        tmp = np.dot(X_, V/S)
        A_tilde = np.dot(U.conj().T, tmp)
        
        # compute eigenvalues and eigenvectors
        Lambda, W = la.eig(A_tilde)
        
        if np.any(Lambda[~np.iscomplex(Lambda)] <= 0):
            raise ValueError('Found negative eigenvalue')
              
        # computes dmd modes and mode amplitudes
        Phi = np.dot(tmp, W)
        Phi = Phi / np.sqrt(np.sum(Phi**2, axis=0)) / np.sqrt(rank)
        omega = np.log(Lambda) / (dt_scale*dt)
        b = la.lstsq(Phi, X[:,0])[0]
        
        sort_order = np.argsort(np.abs(b))[::-1]
        Phi = Phi[:, sort_order]
        omega = omega[sort_order]
        b = b[sort_order]
        
        # take the beginning rows of Phi in case of time delay
        Phi = Phi[:X_fit.shape[0]]
        
        if not self.real:
            self.Phi = Phi
            self.omega = omega
            self.b = b
        else:
            self.Phi, self.omega, self.b = compute_real_dmd_modes(Phi, omega, b)
            
        self.A = np.dot(tmp, U.conj().T)
        self.A_tilde = A_tilde
        self.A_continuous = (self.A - np.eye(self.A.shape[0])) / (dt*dt_scale)
        self.A_tilde_continuous = (self.A_tilde - np.eye(self.A_tilde.shape[0])) / (dt*dt_scale)
        self.P = U
        
    def reduced_dynamics(self, t, imag_evals=False):
        if self.omega.ndim == 2:
            x = np.zeros((self.rank, t.size))
            i = 0
            while i < self.omega.shape[1]:
                if imag_evals:
                    growth_rate = 0
                else:
                    growth_rate = self.omega[0,i]
                    
                if self.omega[1,i] != 0:
                    x[i] = np.exp(growth_rate*t) * (np.real(self.b[i])*np.cos(self.omega[1,i]*t)
                                                    - np.imag(self.b[i])*np.sin(self.omega[1,i]*t))
                    x[i+1] = np.exp(growth_rate*t) * (np.real(self.b[i])*np.cos(self.omega[1,i]*t)
                                                      + np.imag(self.b[i])*np.sin(self.omega[1,i]*t))            
                    i += 2
                else:
                    x[i] = np.exp(growth_rate*t) * np.real(self.b[i])
                    i += 1
                
                return x
            return (np.exp(np.outer(self.omega,t)).conj().T * self.b).conj().T
        
    def reconstruct(self, t, imag_evals=False):
        return np.dot(self.Phi, self.reduced_dynamics(t, imag_evals=imag_evals))
        
        
        
            
    
    
    
    
    
    
    
    
    
    