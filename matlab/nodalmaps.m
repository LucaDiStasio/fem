function[map] = nodalmaps(N,element,values,dof,order)
%%
%==============================================================================
% Copyright (c) 2016 Universit� de Lorraine & Lule� tekniska universitet
% Author: Luca Di Stasio <luca.distasio@gmail.com>
%                        <luca.distasio@ingpec.eu>
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 
% 
% Redistributions of source code must retain the above copyright
% notice, this list of conditions and the following disclaimer.
% Redistributions in binary form must reproduce the above copyright
% notice, this list of conditions and the following disclaimer in
% the documentation and/or other materials provided with the distribution
% Neither the name of the Universit� de Lorraine or Lule� tekniska universitet
% nor the names of its contributors may be used to endorse or promote products
% derived from this software without specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.
%==============================================================================
%
%  DESCRIPTION
%  
%  A function to build the map between global and local nodal coordinates
%  of a mesh with 4-nodes linear quadrilateral elements
%
% Input:
%
% N      : total number of nodes
%
% element: [1 x nnodes] vector of global nodal indeces belonging to element "element"
%
% dof    : scalar, total number of degrees of freedom
%
% order  : scalar integer flag for the order of degrees of freedom in the global vector:
%
%          1: [degree 1 - node 1;...
%              degree 2 - node 1;...
%              degree ... - node 1;...
%              degree D - node 1;...
%              degree 1 - node 2;...
%              degree 2 - node 2;...
%              degree ... - node 2;...
%              degree D - node 2;...
%              degree 1 - node ...;...
%              degree 2 - node ...;...
%              degree ... - node ...;...
%              degree D - node ...;...
%              degree 1 - node N;...
%              degree 2 - node N;...
%              degree ... - node N;...
%              degree D - node N]
%
%          2: [degree 1 - node 1;...
%              degree 1 - node 2;...
%              degree 1 - node ...;...
%              degree 1 - node N;...
%              degree 2 - node 1;...
%              degree 2 - node 2;...
%              degree 2 - node ...;...
%              degree 2 - node N;...
%              degree ... - node 1;...
%              degree ... - node 2;...
%              degree ... - node ...;...
%              degree ... - node N;...
%              degree D - node 1;...
%              degree D - node 2;...
%              degree D - node ...;...
%              degree D - node N]
%
% Output:
%
% map    : direct map [D*N x D*N] (global <= map <= local)
%
%%

nnodes = size(element,2);                                                  % Number of local nodes, i.e. number of corners of the elements

switch order
    case 1
        i = zeros(dof*nnodes*dof*nnodes,1);                                % Sparse matrix construction: initialize vector of row indeces
        j = zeros(dof*nnodes*dof*nnodes,1);                                % Sparse matrix construction: initialize vector of column indeces
        s = zeros(dof*nnodes*dof*nnodes,1);                                % Sparse matrix construction: initialize vector of values
        for k = 1:nnodes                                                   % Loop through global matrix rows
            for l=1:dof
                for m = 1:nnodes                                           % Loop through global matrix columns
                    for n=1:dof
                        i(dof*nnodes*dof*(k-1)+dof*nnodes*(l-1)+dof*(m-1)+n) = dof*(element(1,k)-1) + l;
                        j(dof*nnodes*dof*(k-1)+dof*nnodes*(l-1)+dof*(m-1)+n) = dof*(element(1,m)-1) + n;
                        s(dof*nnodes*dof*(k-1)+dof*nnodes*(l-1)+dof*(m-1)+n) = values(dof*(k-1)+l,dof*(m-1)+n);
                    end
                end
            end
        end      
    case 2
        i = zeros(dof*nnodes*dof*nnodes,1);                                % Sparse matrix construction: initialize vector of row indeces
        j = zeros(dof*nnodes*dof*nnodes,1);                                % Sparse matrix construction: initialize vector of column indeces
        s = zeros(dof*nnodes*dof*nnodes,1);                                % Sparse matrix construction: initialize vector of values
        for k = 1:nnodes                                                   % Loop through global matrix rows
            for l=1:dof
                for m = 1:nnodes                                           % Loop through global matrix columns
                    for n=1:dof
                        i(dof*nnodes*dof*(k-1)+dof*nnodes*(l-1)+dof*(m-1)+n) = N*(l-1) + element(1,k);
                        j(dof*nnodes*dof*(k-1)+dof*nnodes*(l-1)+dof*(m-1)+n) = N*(n-1) + element(1,m);
                        s(dof*nnodes*dof*(k-1)+dof*nnodes*(l-1)+dof*(m-1)+n) = values(dof*(k-1)+l,dof*(m-1)+n);
                    end
                end
            end
        end      
end

map = sparse(i,j,s,dof*N,dof*N);

end