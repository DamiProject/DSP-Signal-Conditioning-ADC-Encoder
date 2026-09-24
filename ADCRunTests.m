%% Runs all tests for ADC Signal Chain

clear;
clc;

%% ==========================================
%% PROJECT ROOT
%% ==========================================

projectRoot = fileparts(mfilename("fullpath"));

%% ==========================================
%% PROJECT PATHS
%% ==========================================

addpath(genpath(fullfile(projectRoot, "Design")));

%% ==========================================
%% LOCATE TESTS
%% ==========================================

TestRoot = fullfile(projectRoot, "Tests");

if ~isfolder(TestRoot)
    error( ...
        'ADCSignalChain:TestsNotFound', ...
        'The ADC Tests folder could not be located.');
end

%% ==========================================
%% CREATE TEST SUITE
%% ==========================================

TestSuite = testsuite( ...
    TestRoot, ...
    "IncludeSubfolders", true);

%% ==========================================
%% CONFIGURE TEST RUNNER
%% ==========================================

Runner = matlab.unittest.TestRunner.withDefaultPlugins;

%% ==========================================
%% CI TEST REPORTING
%% ==========================================

if strcmpi(getenv("GITHUB_ACTIONS"), "true")

    ReportRoot = fullfile( ...
        projectRoot, ...
        "test-results");

    if ~isfolder(ReportRoot)
        mkdir(ReportRoot);
    end

    %% JUnit XML report
    import matlab.unittest.plugins.XMLPlugin

    XMLReport = fullfile( ...
        ReportRoot, ...
        "adc-test-results.xml");

    Runner.addPlugin( ...
        XMLPlugin.producingJUnitFormat(XMLReport));

    %% HTML report
    import matlab.unittest.plugins.TestReportPlugin

    HTMLReport = fullfile( ...
        ReportRoot, ...
        "adc-test-report.html");

    Runner.addPlugin( ...
        TestReportPlugin.producingHTML( ...
            HTMLReport, ...
            "Title", ...
            "ADC Signal Chain Verification Report"));
end

%% ==========================================
%% RUN TESTS
%% ==========================================

results = Runner.run(TestSuite);

disp(results);

%% ==========================================
%% VERIFY TEST RESULTS
%% ==========================================

assertSuccess(results);