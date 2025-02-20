# -*- coding: utf-8 -*-
"""
Created on Wed Oct  7 15:21:08 2020

@author: bouaz
"""

import math
import numpy as np


def identity(x):
    '''
    Identity function.
    '''
    return x


class monomials(object):
    '''
    Computation of monomials in d dimensions.
    '''

    def __init__(self, p):
        '''
        The parameter p defines the maximum order of the monomials.
        '''
        self.p = p

    def __call__(self, x):
        '''
        Evaluate all monomials of order up to p for all data points in x.
        '''
        [d, m] = x.shape # d = dimension of state space, m = number of test points
        c = allMonomialPowers(d, self.p) # matrix containing all powers for the monomials
        n = c.shape[1] # number of monomials
        y = np.ones([n, m])
        for i in range(n):
            for j in range(d):
                y[i, :] = y[i, :] * np.power(x[j, :], c[j, i])
        return y
    
    def diff(self, x):
        '''
        Compute partial derivatives for all data points in x.
        '''
        [d, m] = x.shape # d = dimension of state space, m = number of test points
        c = allMonomialPowers(d, self.p) # matrix containing all powers for the monomials
        n = c.shape[1] # number of monomials
        y = np.zeros([n, d, m])
        for i in range(n): # for all monomials
            for j in range(d): # for all dimensions
                e = c[:, i].copy() # exponents of ith monomial
                a = e[j]
                e[j] = e[j] - 1 # derivative w.r.t. j
                
                if np.any(e < 0):
                    continue # nothing to do, already zero
                
                y[i, j, :] = a*np.ones([1, m])
                for k in range(d):
                    y[i, j, :] = y[i, j, :] * np.power(x[k, :], e[k])
        return y
    
    def ddiff(self, x):
        '''
        Compute second order derivatives for all data points in x.
        '''
        [d, m] = x.shape # d = dimension of state space, m = number of test points
        c = allMonomialPowers(d, self.p) # matrix containing all powers for the monomials
        n = c.shape[1] # number of monomials
        y = np.zeros([n, d, d, m])
        for i in range(n): # for all monomials
            for j1 in range(d): # for all dimensions
                for j2 in range(d): # for all dimensions
                    e = c[:, i].copy() # exponents of ith monomial
                    a = e[j1]
                    e[j1] = e[j1] - 1 # derivative w.r.t. j1
                    a *= e[j2];
                    e[j2] = e[j2] - 1 # derivative w.r.t. j2
                    
                    if np.any(e < 0):
                        continue # nothing to do, already zero
                    
                    y[i, j1, j2, :] = a*np.ones([1, m])
                    for k in range(d):
                        y[i, j1, j2, :] = y[i, j1, j2, :] * np.power(x[k, :], e[k])
        return y
        
    def __repr__(self):
        return 'Monomials of order up to %d.' % self.p
    
    def display(self, alpha, d, name = None, eps = 1e-6):
        '''
        Display the polynomial with coefficients alpha.
        '''
        c = allMonomialPowers(d, self.p) # matrix containing all powers for the monomials
        
        if name != None: print(name + ' = ', end = '')
        
        ind, = np.where(abs(alpha) > eps)
        k = ind.shape[0]
        
        if k == 0: # no nonzero coefficients
            print('0')
            return
        
        for i in range(k):
            if i == 0:
                print('%.5f' % alpha[ind[i]], end = '')
            else:
                if alpha[ind[i]] > 0:
                    print(' + %.5f' % alpha[ind[i]], end = '')
                else:
                    print(' - %.5f' % -alpha[ind[i]], end = '')
                        
            self._displayMonomial(c[:, ind[i]])
        print('')
        
    def _displayMonomial(self, p):
        d = p.shape[0]
        if np.all(p == 0):
            print('1', end = '')
        else:
            for j in range(d):
                if p[j] == 0:
                    continue;
                if p[j] == 1:
                    print(' x_%d' % (j+1), end = '')
                else:
                    print(' x_%d^%d' % (j+1, p[j]), end = '')
                    
    
# auxiliary functions
def nchoosek(n, k):
    '''
    Computes binomial coefficients.
    '''
    return math.factorial(n)//math.factorial(k)//math.factorial(n-k) # integer division operator


def nextMonomialPowers(x):
    '''
    Returns powers for the next monomial. Implementation based on John Burkardt's MONOMIAL toolbox, see
    http://people.sc.fsu.edu/~jburkardt/m_src/monomial/monomial.html.
    '''
    m = len(x)
    j = 0
    for i in range(1, m): # find the first index j > 1 s.t. x[j] > 0
        if x[i] > 0:
            j = i
            break
    if j == 0:
        t = x[0]
        x[0] = 0
        x[m - 1] = t + 1
    elif j < m - 1:
        x[j] = x[j] - 1
        t = x[0] + 1
        x[0] = 0
        x[j-1] = x[j-1] + t
    elif j == m - 1:
        t = x[0]
        x[0] = 0
        x[j - 1] = t + 1
        x[j] = x[j] - 1
    return x


def allMonomialPowers(d, p):
    '''
    All monomials in d dimensions of order up to p.
    '''
    # Example: For d = 3 and p = 2, we obtain
    # [[ 0  1  0  0  2  1  1  0  0  0]
    #  [ 0  0  1  0  0  1  0  2  1  0]
    #  [ 0  0  0  1  0  0  1  0  1  2]]
    n = nchoosek(p + d, p) # number of monomials
    x = np.zeros(d) # vector containing powers for the monomials, initially zero
    c = np.zeros([d, n]) # matrix containing all powers for the monomials
    for i in range(1, n):
        c[:, i] = nextMonomialPowers(x)
    c = np.flipud(c) # flip array in the up/down direction
    return c