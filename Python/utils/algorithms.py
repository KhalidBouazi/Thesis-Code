# -*- coding: utf-8 -*-
"""
Created on Wed Sep 30 15:31:53 2020

@author: bouaz
"""

import numpy as np
import scipy as sp
from utils import tools


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
            M = tools.hankel(M, delays, spacing)
        
        # compute right and left snapshot matrices
        X = M[:,:-1]
        Y = M[:,1:]
            
        # compute svd of X
        U_, s_, Vh_, U, s, Vh = tools.trunc_svd(X, mode=trunc_mode, s_thresh=s_thresh)
    
        # compute best fit matrix A_tilde
        Uh_ = U_.conj().T
        V_ = Vh_.conj().T
        S_inv = np.diag(1/s_)
        A_tilde = Uh_ @ Y @ V_ @ S_inv
        
        # compute eigen values and vectors of A_tilde
        d, W = tools.sort_eig(A_tilde)
        D_inv = np.diag(1/d)
        
        # compute modes of A_tilde
        if alg_mode == 'exact':
            Phi = Y @ V_ @ S_inv @ W @ D_inv
        elif alg_mode == 'standard':
            Phi = U_ @ W
        else:
            raise ValueError('Only exact and standard DMD available.')  
            
        # compute continuous-time eigenvalues of A_tilde
        omega = np.log(d)/dt
        #omega_ = omega
        omega_ = np.imag(omega)*1j
        
        # compute mode amplitudes
        b = sp.linalg.lstsq(Phi, X[:,0])[0]

        # in case of delay embedding just use first rows of modes
        Phi = Phi[:self.M.shape[0]]  
                
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
        self.V = Vh.conj().T
        # best fit matrix, eigen values and vectors, modes and amplitudes
        self.A_tilde = A_tilde
        self.A_tilde_c = (A_tilde - np.eye(A_tilde.shape[0]))/dt
        self.A = Y @ V_ @ S_inv @ Uh_
        self.A_c = (self.A - np.eye(self.A.shape[0]))/dt
        self.d = d
        self.omega = omega
        self.omega_ = omega_
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
        
        dynamics = np.zeros((len(self.omega_), len(t)))
        for i in range(len(t)):
            dynamics[:,i] = np.diag(np.exp(self.omega_*t[i])) @ self.b 
                
        x = self.Phi @ dynamics
        
        return x
    
    
class EDMD:
    
    def fit(self, M, dt, psi, alg_mode='exact'):
        
        ''' === save input === '''
        self.M = M
        self.psi = psi
        
        ''' === start algorithm === '''
        M = psi(M)
        
        # compute right and left snapshot matrices
        PsiX = M[:,:-1]
        PsiY = M[:,1:]
        
        # transform matrices through set of observables
        # PsiX = psi(X)
        # PsiY = psi(Y)
        
        # 
        C_0 = PsiX @ PsiX.T
        C_1 = PsiX @ PsiY.T

        # compute best fit matrix A
        A = sp.linalg.pinv(C_0) @ C_1
        
        # compute eigen values and vectors of A
        d, W = tools.sort_eig(A)
        
        # compute continuous-time eigenvalues of A_tilde
        omega = np.log(d)/dt
        omega_ = np.imag(omega)*1j
        
        # Phi modes fehlen

        
        ''' === save output === '''
        self.A = A 
        self.d = d
        self.omega = omega
        self.omega_ = omega_
        self.W = W
        

class HAVOK(DMD):
    ### korrigieren !
    def hello():
        print('H')
    
    
        
    



