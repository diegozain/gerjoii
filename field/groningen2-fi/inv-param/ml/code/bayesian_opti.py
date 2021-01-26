import numpy as np
from scipy.stats import norm
from scipy.optimize import minimize
from sklearn.gaussian_process import GaussianProcessRegressor
from sklearn.gaussian_process.kernels import ConstantKernel, RBF
# ------------------------------------------------------------------------------
# diego domenzain @ Mines fall 2020. Corona year.
# modified from http://krasserm.github.io/2018/03/21/bayesian-optimization/
# ------------------------------------------------------------------------------
# 
# the functions in this file perform bayesian optimization on 
# 
# a set of parameters x and objective function values y
# 
# x is of size (n_samples by n_features)
# y is of size (n_samples by one)
# 
# The Objective Function y=y(x)
# 1. values are assumed noise-free,
# 2. we are looking for the argmin of y(x)
# 
# the main inversion routine is:
# 
#       optimize_baye( x , y , bounds , n_iter)
# 
# bounds are the bounds for each feature in x,
#       it is a matrix of size (n_features by two)
# ------------------------------------------------------------------------------
def exp_imp(x, x_samples, y_samples, gau_pro, xi=0.01):
    '''
    Computes the EI at points x based on existing samples x_samples
    and y_samples using a Gaussian process surrogate model.
    
    Args:
        x: Points at which EI shall be computed (one by n_features).
        x_samples: Sample locations (n_samples by n_features).
        y_samples: Sample values (n_samples by one).
        gau_pro: A GaussianProcessRegressor fitted to samples.
        xi: Exploitation-exploration trade-off parameter.
    
    Returns:
        Expected improvements at points x.
    '''
    xi=0.01
    mu, sigma = gau_pro.predict(x, return_std=True)
    mu_samples= np.max(y_samples)

    with np.errstate(divide='warn'):
        imp = mu - mu_samples - xi
        Z   = imp / sigma
        ei  = imp * norm.cdf(Z) + sigma * norm.pdf(Z)
        ei[sigma == 0.0] = 0.0
    return ei
# ------------------------------------------------------------------------------
def update_x(acq_fnc, x_samples, y_samples, gau_pro, bounds, n_restarts=1000):
    '''
    Proposes the next sampling point by optimizing the acq_fnc function.
    
    Args:
        acq_fnc: Acquisition function.
        x_samples: Sample locations (n_samples by n_features).
        y_samples: Sample values (n_samples by one).
        gau_pro: A GaussianProcessRegressor fitted to samples.

    Returns:
        Location of the acq_fnc function maximum.
    '''
    n_features = x_samples.shape[1]
    min_val = float('Inf')
    x_min = None
    
    def min_obj(x):
        return -acq_fnc(x.reshape(-1, n_features), x_samples, y_samples, gau_pro)
        
    # simulate a gridsearch by random sampling
    # this will help the minimize method below to have a robust initial guess
    x_samples_ = x_random(bounds,n_restarts)
    for i_ in range(x_samples_.shape[0]):
        y = min_obj(x_samples_[i_,:])
        if y < min_val:
            min_val = y
            x_min = x_samples_[i_,:]
    
    # 'CG' 'Nelder-Mead'  'L-BFGS-B' 'TNC'
    min_obj_ = minimize(min_obj, x0=x_min, bounds=bounds, method='L-BFGS-B') 
    # min_obj_ = minimize(min_obj, x0=x0, method='Nelder-Mead') 
    if min_obj_.fun < min_val:
        x_min = min_obj_.x
        
    return x_min.reshape(-1, n_features)
# ------------------------------------------------------------------------------
def optimize_baye_(x,y,bounds,n_iter):
    '''
             the sought after value will be
                                            argmin_x y = x[-1,:]
                                            
        this function assumes y=y(x) is available to compute.
    '''
    
    ker = ConstantKernel(1.0) * RBF(length_scale=1)
    gau_pro = GaussianProcessRegressor(kernel=ker,alpha=1e-0)
    
    # this algorithm is set-up for minimizing y
    y=-y
    
    for i in range(n_iter):
        # this gaussian process will gives rise to an acquisition function that 
        # approximates the true objective function.
        gau_pro.fit(x, y)

        # in this case, the acquisition function (i.e. the function that 
        # approximates the true objective funciton) is:
        #           the Expected Improvements function (exp_imp)
        # we now optimize exp_imp to find the best solution for x.
        x_next = update_x(exp_imp, x, y, gau_pro, bounds)
        
        # we now see what the value of this x_next is so we can iterate
        y_next = -obj_fnc(x_next)

        # Add sample to previous samples
        x = np.vstack((x, x_next))
        y = np.vstack((y, y_next))
        
    ibest = np.argmax(y)
    x[-1,:] = x[ibest,:]
    y[-1] = y[ibest]
    return x,-y
# ------------------------------------------------------------------------------
def optimize_baye(x,y,bounds):
    '''
             the sought after value will be
                                            argmin_x y = x[-1,:]
        
        this function assumes y=y(x) is extremeley difficult to compute,
        so it only gives the next best guess for x given initial conditions.    
    '''
    
    ker = ConstantKernel(1.0) * RBF(length_scale=1)
    gau_pro = GaussianProcessRegressor(kernel=ker,alpha=1e-0)
    
    # this algorithm is set-up for minimizing y
    y=-y
    
    # this gaussian process will gives rise to an acquisition function that 
    # approximates the true objective function.
    gau_pro.fit(x, y)

    # in this case, the acquisition function (i.e. the function that 
    # approximates the true objective funciton) is:
    #           the Expected Improvements function (exp_imp)
    # we now optimize exp_imp to find the best solution for x.
    x = update_x(exp_imp, x, y, gau_pro, bounds)

    return x
# ------------------------------------------------------------------------------
def x_random(bounds,n_restarts):
    n_features = bounds.shape[0]
    x_samples_ = np.zeros((n_restarts,n_features))
    for if_ in range(n_features):
        tmp_ = np.random.uniform(bounds[if_,0],bounds[if_,1],size=(n_restarts,1))
        x_samples_[:,if_] = tmp_.squeeze()
    return x_samples_
# ------------------------------------------------------------------------------
