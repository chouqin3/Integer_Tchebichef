%---------------------------------------------------------------
% r=Comb(j,i)
%
% Extension of the combinatorial numbers nchoosek(j,i) for the
% special cases where i==0 or i>j that are not defined in the
% standard case.
%
% This function is used in the InverseMomentsBasis and in the
% ChebyshevBasis.
%
% Input parameters:
%       > j: total number of elements
%       > i: number of elements to choose
% Output parameters:
%       > r: the number of possible choices
%
% ---------------------------------------------------------------
function r=Comb(j,i)
  if (i==0) r=1;
  else
      if (i>j) r=0;
      else r=nchoosek(j,i);
      end
  end
