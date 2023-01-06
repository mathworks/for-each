classdef Iterable < matlab.unittest.TestCase
% Test common Iteration Properties
    methods (Test)

        function negativeTest(testcase)
            import each.test.helpers.NumberOfIterationsHelper;

            testcase.verifyError(...
                @() NumberOfIterationsHelper(magic(3)),...
                'MATLAB:validation:IncompatibleSize')

            testcase.verifyError(...
                @() NumberOfIterationsHelper(-6),...
                "MATLAB:validators:mustBeNonnegative")

            testcase.verifyError(...
                @()NumberOfIterationsHelper(2.5),...
                "MATLAB:validators:mustBeInteger");
        end

        function unsupportedOperations(testcase)
            import each.test.helpers.NumberOfIterationsHelper;

            it = NumberOfIterationsHelper(10);
            msgId = "Iterable:UnsupportedOperation";
            testcase.verifyError(@()it(:),msgId);
            testcase.verifyError(@()it(3),msgId);
            testcase.verifyError(@()it(:,2,2),msgId);
            testcase.verifyError(@()[it it],msgId);

            function assignVal()
                it(2)=3;
            end
            testcase.verifyError(@assignVal,msgId);

            function deleteVal()
                it(2)=[];
            end
            testcase.verifyError(@deleteVal,msgId);
        end

        function numIterations(testcase)
            import each.test.helpers.NumberOfIterationsHelper;
            act = NumberOfIterationsHelper(30);
            testcase.verifyClass(act.NumberOfIterations,'double');
            testcase.verifyEqual(act.NumberOfIterations,30);

            act = NumberOfIterationsHelper(uint64(32));
            testcase.verifyClass(act.NumberOfIterations,'double');
            testcase.verifyEqual(act.NumberOfIterations,32);
        end
    end
end

% Copyright 2014-2023 The MathWorks, Inc.
