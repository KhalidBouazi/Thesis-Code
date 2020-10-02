# -*- coding: utf-8 -*-
"""
Created on Wed Sep 30 15:31:53 2020

@author: bouaz
"""

import numpy as np
from utls import utils


class DMD:
        
    def fit(self, M, dt, delays=1, spacing=1, mode='exact', trunc_mode='none', s_thresh=1e-10):
        '''
        Exact and standard DMD of M.
    
        :param dt: sample time
        :param delays: number of delay coordinates
        :param spacing: 
        :param trunc_mode: mode of truncation
        :param svThresh: Threshold below which to discard singular values
        :param mode: 'exact' for exact DMD or 'standard' for standard DMD
        :return: eigenvalues d and modes Phi
        '''
        if delays > 1:
            M = utils.hankel(M, delays, spacing) 
        
        # compute right and left snapshot matrices
        X = M[:,:-1]
        Y = M[:,1:]

        # compute svd of X
        U_, s_, Vh_, U, s, Vh = utils.trunc_svd(X, mode=trunc_mode, s_thresh=s_thresh)
    
        # compute best fit matrix A
        Uh_ = U_.conj().T
        V_ = Vh_.conj().T
        S_inv = np.diag(1/s_)
        A = Uh_ @ Y @ V_ @ S_inv
        
        # compute eigenvalues and -vectors of A
        d, W = utils.sort_eig(A)
        D_inv = np.diag(1/d)
        
        # compute modes of A
        if mode == 'exact':
            Phi = Y @ V_ @ S_inv @ W @ D_inv
        elif mode == 'standard':
            Phi = U_ @ W
        else:
            raise ValueError('Only exact and standard DMD available.')
            
        # compute continuous-time eigenvalues of A
        omega = np.log(d)/dt
        omega = np.imag(omega)*1j
        
        # compute mode amplitudes
        b = np.linalg.lstsq(Phi, M[:,0], rcond=None)[0]
        
        # truncated svd
        self.U_ = U_
        self.s_ = s_
        self.Vh_ = Vh_
        # svd
        self.U = U
        self.s = s
        self.Vh = Vh
        # best fit matrix, eigenvalues and -vectors, modes and amplitudes
        self.A = A
        self.d = d
        self.omega = omega
        self.W = W
        self.Phi = Phi
        self.b = b
        
    def reconstruct(self, t):
        x = np.zeros((self.Phi.shape[0], len(t)))
        for i in range(len(t)):
            x[:,i] = self.Phi @ np.exp(np.diag(self.omega*t[i])) @ self.b

        return x
        


def havok(M, dt, delays=1, spacing=1, trunc_mode='none', s_thresh=1e-10):
    '''
    HAVOK for matrix M

    :param delays: number of delay coordinates
    :param spacing: 
    :param trunc_mode: mode of truncation
    :param svThresh: Threshold below which to discard singular values
    :return: eigenvalues d and modes Phi
    '''
    H = utils.hankel(M, delays, spacing) 





