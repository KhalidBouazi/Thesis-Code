# -*- coding: utf-8 -*-
"""
Created on Wed Sep 30 15:31:53 2020

@author: bouaz
"""

import numpy as np
import scipy as sp
import scipy.sparse.linalg
from utils import *


def dmd(X, Y, mode='exact', trunc_mode='none', s_thresh=1e-10):
    '''
    Exact and standard DMD of the data matrices X and Y.

    :param svThresh: Threshold below which to discard singular values
    :param mode: 'exact' for exact DMD or 'standard' for standard DMD
    :return: eigenvalues d and modes Phi
    '''
    U_, s_, Vh_, U, s, Vh = trunc_svd(X, mode=trunc_mode, s_thresh=s_thresh)

    Uh_ = U_.conj().T
    V_ = Vh_.conj().T
    S_ = np.diag(s_)
    S_inv = np.diag(1/s_)
    A = Uh_ @ Y @ V_ @ S_inv
    
    # mode eigenvalues and vectors
    d, W = sort_eig(A)
    D = np.diag(1/d)
    
    # modes
    if mode == 'exact':
        Phi = Y @ V_ @ S_inv @ W # @  D
    elif mode == 'standard':
        Phi = U_ @ W
    else:
        raise ValueError('Only exact and standard DMD available.')
        
    # mode amplitudes
    b = sp.linalg.inv(W @ D) @ (S_ @ V_[1,:])

    return U_, s_, Vh_, U, s, Vh, A, d, W, Phi, b


def havok(X, delays, spacing=1, trunc_mode='none', s_thresh=1e-10):
    '''
    HAVOK for matrix X

    :param svThresh: Threshold below which to discard singular values
    :return: eigenvalues d and modes Phi
    '''
    H = utils.hankel(X, delays, spacing) 
    U_, s_, Vh_, U, s, Vh = trunc_svd(H, mode=trunc_mode, s_thresh=s_thresh)





