classdef NumberOfIterationsHelper < each.iterators.Iterable
methods
    function obj = NumberOfIterationsHelper(Array)
        obj.NumberOfIterations = Array;
    end

    function elem = getValue(~,~)
        elem = [];
    end
end
end
% Copyright 2014-2023 The MathWorks, Inc.
