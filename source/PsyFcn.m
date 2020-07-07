function p = PsyFcn(x,mu,sigma)
% PsyFcn        Psychometric Function
%
% syntax: p = PsyFcn(x,mu,sigma)
%
% Computes the psychometric function at point x. The psychometric function is
% calculated as a cumulative normal distribution described by its mean value
% mu and its standard deviation sigma.
%
% See also: PsyFcnFit


% (c) of, 2004 Jan 12
% Last Update: 2005 Feb 14
% Timestamp: <PsyFcn.m Mon 2005/02/14 17:17:23 OF@OFPC>

if ~exist('mu','var') | isempty(mu),   % is there a value for mu?
  mu = 0;                              % set standard value
end
if ~exist('sigma','var') | isempty(sigma),  % is there a value for sigma?
  sigma = 1;                           % set standard value
end

p = erfc(-(x-mu)./(sqrt(2)*sigma))/2;  % calculate the function value
