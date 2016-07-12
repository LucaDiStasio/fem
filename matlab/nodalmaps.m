function[map] = nodalmaps(N,element,dof,order,type)
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
% type    : scalar integer flag for the type of map
%           1: direct,  map [D*N x D*nnodes] --> global = map*local
%           2: inverse, map [D*nnodes x D*N] -->  local = map*global
%
%%

s = ones(dof*4,1);
nnodes = size(element,2);

switch order
    case 1
        switch type
            case 1
                i = zeros(dof*nnodes,1);
                j = zeros(dof*nnodes,1);
                for k = 1:nnodes
                    for l=1:dof
                        i(dof*(k-1)+l) = dof*(element(1,k)-1) + l;
                        j(dof*(k-1)+l) = dof*(k-1) + l;
                    end
                end
                map = sparse(i,j,s,dof*N,dof*nnodes);
            case 2
                i = zeros(dof*nnodes,1);
                j = zeros(dof*nnodes,1);
                for k = 1:nnodes
                    for l=1:dof
                        i(dof*(k-1)+l) = dof*(k-1) + l;
                        j(dof*(k-1)+l) = dof*(element(1,k)-1) + l;
                    end
                end
                map = sparse(i,j,s,dof*nnodes,dof*N);
        end
    case 2
        switch type
            case 1
                i = zeros(dof*nnodes,1);
                j = zeros(dof*nnodes,1);
                for k = 1:dof
                    for l=1:nnodes
                        i(nnodes*(k-1)+l) = N*(k-1) + element(1,l);
                        j(nnodes*(k-1)+l) = nnodes*(k-1) + l;
                    end
                end
                map = sparse(i,j,s,dof*N,dof*nnodes);
            case 2
                i = zeros(dof*nnodes,1);
                j = zeros(dof*nnodes,1);
                for k = 1:dof
                    for l=1:nnodes
                        i(nnodes*(k-1)+l) = nnodes*(k-1) + l;
                        j(nnodes*(k-1)+l) = N*(k-1) + element(1,l);
                    end
                end
                map = sparse(i,j,s,dof*nnodes,dof*N);
        end
end

end