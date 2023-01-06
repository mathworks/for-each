classdef eachSlice < matlab.unittest.TestCase

    methods (Test)

        function numberOfIterations(testcase)
        A = randi(10,4,4,4);
        loopCounter = 0;
        for elem = eachSlice(A,3)
            loopCounter = loopCounter+1;
            testcase.verifyEqual(elem,A(:,:,loopCounter));
        end
        testcase.verifyEqual(loopCounter,numel(A)/size(A,1)/size(A,2));
        end
    end
end

% Copyright 2014-2023 The MathWorks, Inc.
