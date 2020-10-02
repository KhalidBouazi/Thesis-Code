# -*- coding: utf-8 -*-
"""
Created on Sun Sep 20 13:25:52 2020

@author: bouaz
"""

import numpy as np

def hankel(X, delays, spacing=1):
    '''
    Computes hankel matrix of X

    :param delays: number of delay coordinates
    :param spacing: multiple of sample time between to samples
    :return: hankel matrix
    '''
    
    height = 0
    width = 0
    if X.ndim == 1:
        height = 1
        width = len(X)
        X.shape = (1, width)
    else:
        height, width = X.shape
    
    
    hankel_shape = (height * delays,
                    width - spacing * (delays - 1))
    print(hankel_shape)
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
    U, s, Vh = np.linalg.svd(X, full_matrices=False)
    
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
    Vh_ = Vh[:rank]
        
    return U_, s_, Vh_, U, s, Vh


def sort_eig(A):
    '''
    Computes eigenvalues and eigenvectors of A and sorts them in decreasing lexicographic order.

    :return:    sorted eigenvalues and eigenvectors
    '''
    d, W = np.linalg.eig(A)
    ind = d.argsort()[::-1] # [::-1] reverses the list of indices
    return d[ind], W[:, ind]