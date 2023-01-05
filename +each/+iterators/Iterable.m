classdef Iterable < handle & matlab.mixin.indexing.RedefinesParen
    % Interface Class for Loop Iterable Objects
    %
    % To create an iterator class, inherit from each.iterators.Iterable and
    % implement the getValue method and set the NumberOfIterations property.
    %
    % For example:
    %
    %   classdef MyIterator < each.iterators.Iterable
    %
    % See the code for each.iterators.ArrayIterator as an example of how to
    % create your own iterator.
    %
    % Iterable Members:
    %   Abstract Members:
    %       each.iterators.Iterable.NumberOfIterations - Number of iterations.
    %       each.iterators.Iterable/getValue - Used to get individual iteration
    %                                           values.
    %
    % See Also each.iterators.ArrayIterator, each
    %

    %   Copyright 2014-2023 The MathWorks, Inc.

    properties (GetAccess = public, SetAccess = protected)
        % NumberOfIterations must be set to a scalar value in the child class constructor
        NumberOfIterations;
    end

    methods (Abstract)
        %GETVALUE  Abstract Method for accessing iterator data.
        % VAL = getValue(OBJ,K) returns the Kth element of the iterator OBJ. K must
        %                       accept integer values between 1 and N, where
        %                       N = getNumIterations(OBJ).
        val = getValue(obj,k);
    end

    methods (Hidden, Sealed)
        % In order to overload FOR, the each.iterators.Iterable class overloads the
        % SIZE and SUBSREF methods, and provides a simplified interface of the
        % GETVALUE method and NumberOfIterations property.
        function [varargout] = size(obj)
            % Size
            varargout = {1 obj.NumberOfIterations};
        end
    end

    methods (Access=protected)
        function out = parenReference(obj,indexOp)
            % This method is called by the for loop
            idxs = indexOp.Indices;
            if numel(idxs)==2
                % Subsref should only call getValue when the expression is:
                % IO(:,k)
                if idxs{1} == ':' && isscalar(idxs{2})
                    try
                        out = getValue(obj,idxs{2});
                    catch ME
                        throwAsCaller(ME);
                    end
                    return
                end
            end
            error("This Operation is not supported.");
        end

        function obj = parenAssign(~,~,varargin) %#ok<STOUT>
            error("This Operation is not supported.");
        end

        function n = parenListLength(~,~,~)
            n=1;
        end

        function obj = parenDelete(~,~) %#ok<STOUT>
            error("This Operation is not supported.");
        end
    end

    methods
        function out = cat(~,varargin) %#ok<STOUT> 
            error("This Operation is not supported.");
        end

        function set.NumberOfIterations(obj,rhs)
            if ~isnumeric(rhs) || ~isscalar(rhs)
                throwAsCaller(MException('Iterators:Iterable:NumberOfIterations',...
                    'NumberOfIterations must be set to a numeric scalar value'));
            end

            if rhs > each.iterators.MaxIterations
                throwAsCaller(MException('each:iterators:TooManyIterations'...
                    ,'Cannot perform more than %d loop iterations.',each.iterators.MaxIterations));
            end
            obj.NumberOfIterations = floor(rhs);
        end
    end
end

