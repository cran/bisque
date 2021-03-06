% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sKrig.R
\name{sKrig}
\alias{sKrig}
\title{Draw posterior predictive samples from a spatial Gaussian process model}
\usage{
sKrig(x, sFit, coords.krig, coords = sFit$coords, burn = 0, ncores = 1)
}
\arguments{
\item{x}{Observation of a spatial Gaussian random field, passed as a vector}

\item{sFit}{posterior samples of model parameters; output from 
bisque::sFit}

\item{coords.krig}{Spatial coordinates at which the field should be 
interpolated}

\item{coords}{Spatial coordinates at which observations are available}

\item{burn}{number of posterior samples to discard from sFit before sampling}

\item{ncores}{Kriging is done via composition sampling, which may be done in
parallel.  \code{ncores} specifies the number of cores over which sampling 
is done.  If \code{ncores>1}, bisque::sKrig assumes that a parallel 
backend suitable for use with the foreach package is already registered.}
}
\description{
Draw posterior predictive samples from a spatial Gaussian process model
}
\examples{
library(fields)

simulate.field = function(n = 100, range = .3, smoothness = .5, phi = 1){
  # Simulates a mean-zero spatial field on the unit square
  #
  # Parameters:
  #  n - number of spatial locations
  #  range, smoothness, phi - parameters for Matern covariance function
  
  coords = matrix(runif(2*n), ncol=2)
  
  Sigma = Matern(d = as.matrix(dist(coords)), 
                 range = range, smoothness = smoothness, phi = phi)
  
  list(coords = coords,
       params = list(n=n, range=range, smoothness=smoothness, phi=phi),
       x = t(chol(Sigma)) \%*\%  rnorm(n))
}

# simulate data
x = simulate.field()

# configure gibbs sampler  
it = 100

# run sampler using default posteriors
post.samples = sFit(x = x$x, coords = x$coords, nSamples = it)

# build kriging grid
cseq = seq(0, 1, length.out = 10)
coords.krig = expand.grid(x = cseq, y = cseq)

# sample from posterior predictive distribution
burn = 75
samples.krig = sKrig(x$x, post.samples, coords.krig = coords.krig, burn = burn)
}
