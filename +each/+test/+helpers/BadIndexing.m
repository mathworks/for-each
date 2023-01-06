classdef BadIndexing
methods
    function [out] = subsref(~,varargin)
        error('iterators:test:badindexing','Indexing Not Supported');
    end
end
end

% Copyright 2014-2023 The MathWorks, Inc.
