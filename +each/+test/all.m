% Copyright 2014-2023 The MathWorks, Inc.
% Runs all the tests in the each.test package

import matlab.unittest.TestSuite
suite = TestSuite.fromPackage("each.test");
suite.run();
