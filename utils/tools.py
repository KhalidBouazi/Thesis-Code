# -*- coding: utf-8 -*-
"""
Created on Sun Sep 20 13:25:52 2020

@author: bouaz
"""

import numpy as np

def hankel(X, delays, spacing):
    '''
    

    Parameters
    ----------
    X : array
        data matrix.
    delays : int
        number of delay coordinates
    spacing : int, optional
            space between to samples.

    Returns
    -------
    H : array
        hankel matrix.

    '''
    
    # extract data matrix dimensions
    height = 0
    width = 0
    if X.ndim == 1:
        height = 1
        width = len(X)
        X.shape = (1, width)
    else:
        height, width = X.shape
    
    # compute hankel shape
    hankel_shape = (height * delays,
                    width - spacing * (delays - 1))

    # compute hankel matrix
    H = np.zeros(hankel_shape)
    for i in range(delays):
        idxs = np.arange(spacing * i, width - spacing * (delays - 1 - i))
        H[i*height:(i+1)*height] = X[:, idxs]
    
    return H


def trunc_svd(X, mode, s_thresh):
    '''
    

    Parameters
    ----------
    X : array
        data matrix.
    mode : string
        truncation mode.
    s_thresh : double
        threshold below which to discard singular values. The default is 1e-10..

    Raises
    ------
    ValueError
        DESCRIPTION.

    Returns
    -------
    U_ : array
        truncated left singular vectors.
    s_ : array
        truncated singular values.
    Vh_ : array
        truncated right singular vectors.
    U : array
        left singular vectors.
    s : array
        singular values.
    Vh : array
        right singular vectors.

    '''
    
    # compute svd of X
    U, s, Vh = np.linalg.svd(X, full_matrices=False)
    
    # determine truncation rank by threshold
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
    
    # truncate 
    U_ = U[:, :rank]
    s_ = s[:rank]
    Vh_ = Vh[:rank]
        
    return U_, s_, Vh_, U, s, Vh


def sort_eig(A):
    '''
    

    Parameters
    ----------
    A : array
        matrix.

    Returns
    -------
    d_sort : array
        sorted eigen values of A.
    W_sort : array
        sorted eigen vectors of A.

    '''
    
    # compute eigen values and vectors of A
    d, W = np.linalg.eig(A)
    
    # compute sorted indexes
    ind = d.argsort()[::-1] # [::-1] reverses the list of indices
    
    # sort eigen values and vectors
    d_sort = d[ind]
    W_sort = W[:, ind]
    
    return d_sort, W_sort

def diff(X, dt, rank):
    dX = []
    for i in range(2,len(X)-3):
        for k in range(rank):
            dX[i-2,k] = 1/(12*dt) * (-X(i+2,k) + 8*X(i+1,k) - 8*X(i-1,k) + X(i-2,k))
            
    return dX
        



