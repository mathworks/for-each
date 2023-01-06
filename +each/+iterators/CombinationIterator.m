classdef CombinationIterator < each.iterators.Iterable
%COMBINATIONITERATOR iterator for array combinations
% Iterator for looping over all the combinations of elements in a set of arrays
%
% CombinationIterator Methods:
%   each.iterators.CombinationIterator/CombinationIterator - Constructor for a combination iterator
%   each.iterators.CombinationIterator/getValue            - Get the Kth combination of an iterator object.
%
% See Also: each, eachCombination, each.iterators.Iterable
%

%   Copyright 2014-2023 The MathWorks, Inc.

    properties (GetAccess = public, SetAccess = private)
        NumberOfInputs;
    end

    properties (Access = private)
        Iters
        Dimensions
    end

    methods

        function obj = CombinationIterator(varargin)
            %COMBINATIONITERATOR create a N-Tuple iterator from a set of arrays
            % IO = COMBINATIONITERATOR(varargin) creates a combination iterator which
            %                                    will iterate over all pairwise
            %                                    elements of the arrays in varargin.
            %
            % Example, the following will iterate of each pair from arrays A and B:
            %
            %   A = 1:3;
            %   B = -1:1;
            %   IO = each.iterators.COMBINATIONITERATOR(A,B);
            %   n = IO.NumberOfIterations
            %
            % Note: If an element of any of the input arrays is empty, there will be
            %       no iterations.
            %
            % See Also: each, eachTuple, each.iterators.Iterable
            N = nargin;
            obj.NumberOfInputs = N;

            % In order to iterate as a nested loop
            % reverse iteration on the input to loop "innermost" first
            itrs = cell(1,N);
            dims = ones(1,N);
            for ii = N:-1:1
                itr = each.iterators.getIterator(varargin{ii});
                itrs{N-ii+1} = itr;
                dims(N-ii+1) = itr.NumberOfIterations;
            end
            obj.Iters = itrs;

            obj.Dimensions = dims;
            obj.NumberOfIterations = prod(obj.Dimensions);

            % uint64 support - works in 2013a and later
            % obj.Dimensions = cellfun( @(c) uint64(c.NumberOfIterations),obj.Iters);
            % obj.NumberOfIterations = prod(obj.Dimensions,'native');
        end

        function elem = getValue(obj,k)

            subs = {}; dim = obj.Dimensions;
            % Convert the kth linear index into multi-dimensional subscripts
            [subs{1:length(dim)}] = ind2sub(dim,k);

            N = numel(obj.Iters);
            elem = cell(1,N);
            for ii = 1:N
                % Iterators are stored in the reverse order, reorder the outputs
                % to return the elements in the same order as the arguments.
                elem{N-ii+1} = obj.Iters{ii}.getValue(subs{ii});
            end
        end

    end

end
