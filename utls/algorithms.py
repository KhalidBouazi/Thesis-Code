# -*- coding: utf-8 -*-
"""
Created on Wed Sep 30 15:31:53 2020

@author: bouaz
"""

import numpy as np
from utls import utils


class DMD:
        
    def fit(self, M, dt, delays=1, spacing=1, alg_mode='exact', trunc_mode='none', s_thresh=1e-10):
        '''
        

        Parameters
        ----------
        M : array
            data matrix.
        dt : double
            sample time.
        delays : int, optional
            number of delay coordinates. The default is 1.
        spacing : int, optional
            space between to samples. The default is 1.
        alg_mode : string, optional
            mode of algorithm. The default is 'exact'.
        trunc_mode : string, optional
            mode of truncation. The default is 'none'.
        s_thresh : double, optional
            threshold below which to discard singular values. The default is 1e-10.

        Raises
        ------
        ValueError
            DESCRIPTION.

        Returns
        -------
        None.

        '''
        
        
        ''' === save input === '''
        self.M = M
        self.dt = dt
        self.delays = delays
        self.spacing = spacing
        self.alg_mode = alg_mode
        self.trunc_mode = trunc_mode
        self.s_thresh = s_thresh
        
        ''' === start algorithm === '''
        # compute hankel matrix
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
        V = Vh.conj().T
        S_inv = np.diag(1/s_)
        A = Uh_ @ Y @ V_ @ S_inv
        A_c = (A - np.eye(A.shape[0])) / dt
        
        # compute eigen values and vectors of A
        d, W = utils.sort_eig(A)
        D_inv = np.diag(1/d)
        
        # compute modes of A
        if alg_mode == 'exact':
            Phi = Y @ V_ @ S_inv @ W @ D_inv
        elif alg_mode == 'standard':
            Phi = U_ @ W
        else:
            raise ValueError('Only exact and standard DMD available.')
            
        # compute continuous-time eigenvalues of A
        omega = np.log(d)/dt
        
        # compute mode amplitudes
        b = np.linalg.lstsq(Phi, M[:,0], rcond=None)[0]
        
        ''' === save output === '''
        # snapshot matrices
        self.X = X
        self.Y = Y
        # truncated svd
        self.U_ = U_
        self.s_ = s_
        self.Vh_ = Vh_
        self.V_ = V_
        # svd
        self.U = U
        self.s = s
        self.Vh = Vh
        self.V = V
        # best fit matrix, eigen values and vectors, modes and amplitudes
        self.A = A
        self.A_c = A_c
        self.d = d
        self.omega = omega
        self.W = W
        self.Phi = Phi
        self.b = b
        
    def reconstruct(self, t):
        '''
        

        Parameters
        ----------
        t : array
            time array.

        Returns
        -------
        x : array
            signal.

        '''
        x = np.zeros((self.Phi.shape[0], len(t)))
        for i in range(len(t)):
            x[:,i] = self.Phi @ np.exp(np.diag(self.omega*t[i])) @ self.b

        return x
        

class HAVOK:
    
    def fit(self, M, dt, delays=1, spacing=1, trunc_mode='none', s_thresh=1e-10):
        '''
        
    
        Parameters
        ----------
        M : array
            data matrix.
        dt : double
            sample time.
        delays : int, optional
            number of delay coordinates. The default is 1.
        spacing : int, optional
            space between to samples. The default is 1.
        trunc_mode : string, optional
            mode of truncation. The default is 'none'.
        s_thresh : double, optional
            threshold below which to discard singular values. The default is 1e-10.
    
        Returns
        -------
        None.
    
        '''
        
        ''' === save input === '''
        self.M = M
        self.dt = dt
        self.delays = delays
        self.spacing = spacing
        self.trunc_mode = trunc_mode
        self.s_thresh = s_thresh
        
        ''' === start algorithm === '''
        # compute hankel matrix H
        H = utils.hankel(M, delays, spacing) 
    
        # compute svd of H
        U_, s_, Vh_, U, s, Vh = utils.trunc_svd(H, mode=trunc_mode, s_thresh=s_thresh)
        V_ = Vh_.conj().T
        V = Vh.conj().T
        
        ''' === save output === '''
        # hankel matrix
        self.H = H
        # truncated svd
        self.U_ = U_
        self.s_ = s_
        self.Vh_ = Vh_
        self.V_ = V_
        # svd
        self.U = U
        self.s = s
        self.Vh = Vh
        self.V = V
    
    def reconstruct(self, t):
        '''
        

        Parameters
        ----------
        t : array
            time array.

        Returns
        -------
        x : array
            signal.

        '''
        x = np.zeros((self.Phi.shape[0], len(t)))
        for i in range(len(t)):
            x[:,i] = self.Phi @ np.exp(np.diag(self.omega*t[i])) @ self.b

        return x
    
        
    



