# -*- coding: utf-8 -*-
"""
Created on Sun Sep 20 13:25:52 2020

@author: bouaz
"""

import numpy as np
import scipy as sp

def hankel(X, delays, spacing=1):
    '''
    Computes hankel matrix of X

    :param delays: number of delay coordinates
    :param spacing: multiple of sample time between to samples
    :return: hankel matrix
    '''
    height, width = X.shape
    hankel_shape = (height * delays,
                    width - spacing * (delays - 1))
    H = np.zeros(hankel_shape)
    for i in range(delays):
        idxs = np.arange(spacing * i, width - spacing * (delays - 1 - i))
        H[i*height:(i+1)*height] = X[:, idxs]
    
    return H


def trunc_svd(X, mode, s_thresh):
    '''
    Computes truncated SVD of X

    :param mode: truncation mode 'value' or 'rank'
    :param s_thresh: Threshold below which to discard singular values or rank
    :return: truncated SVD
    '''
    U, s, Vh = sp.linalg.svd(X, full_matrices=False)
    
    rank = 0
    if mode == 'value':
        if 0 > s_thresh:
            raise ValueError('s_thresh has to be 0 < s_thresh.')
        rank = np.where(s > s_thresh)[0].size
    elif mode == 'rank':
        if 0 > s_thresh or s_thresh > len(s):
            raise ValueError('s_thresh has to be 0 < s_thresh <= len(s).')
        rank = s_thresh
    elif mode == 'none':
        rank = s.size
    else:
        raise ValueError('Mode has to be value, rank or none.')
            
    U_ = U[:, :rank]
    s_ = s[:rank]
    Vh_ = Vh[:rank, :]
        
    return U_, s_, Vh_, U, s, Vh


def sort_eig(A, evs=0, which='LM'):
    '''
    Computes eigenvalues and eigenvectors of A and sorts them in decreasing lexicographic order.

    :param evs: number of eigenvalues/eigenvectors
    :return:    sorted eigenvalues and eigenvectors
    '''
    n = A.shape[0]
    if 0 < evs < n:
        d, W = sp.sparse.linalg.eigs(A, evs, which=which)
    else:
        d, W = sp.linalg.eig(A)
    ind = d.argsort()[::-1] # [::-1] reverses the list of indices
    return d[ind], W[:, ind]