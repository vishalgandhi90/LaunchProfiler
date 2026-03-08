import XCTest
@testable import LaunchProfiler

final class LaunchProfilerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        LaunchProfiler.shared.configure(LaunchProfilerConfiguration(
            enabled: true,
            reportingMode: .delegate,
            isEnabledInRelease: true
        ))
    }

    func testMilestoneRecording() {
        LaunchProfiler.shared.start()
        LaunchProfiler.shared.mark("Step 1")
        LaunchProfiler.shared.mark("Step 2")
        let report = LaunchProfiler.shared.finish()

        XCTAssertNotNil(report)
        // Step 1 + Step 2 + Finish
        XCTAssertEqual(report?.milestones.count, 3)
        XCTAssertEqual(report?.milestones[0].name, "Step 1")
        XCTAssertEqual(report?.milestones[1].name, "Step 2")
    }

    func testTotalDuration() {
        LaunchProfiler.shared.start()
        Thread.sleep(forTimeInterval: 0.1)
        LaunchProfiler.shared.mark("After sleep")
        let report = LaunchProfiler.shared.finish()

        XCTAssertNotNil(report)
        XCTAssertGreaterThanOrEqual(report!.totalDuration, 0.09)
    }

    func testSlowestMilestone() {
        LaunchProfiler.shared.start()
        LaunchProfiler.shared.mark("Fast")
        Thread.sleep(forTimeInterval: 0.15)
        LaunchProfiler.shared.mark("Slow")
        LaunchProfiler.shared.mark("Fast Again")
        let report = LaunchProfiler.shared.finish()

        XCTAssertEqual(report?.slowestMilestone?.name, "Slow")
    }

    func testDisabledProfiler() {
        LaunchProfiler.shared.configure(LaunchProfilerConfiguration(enabled: false))
        LaunchProfiler.shared.start()
        LaunchProfiler.shared.mark("Test")
        let report = LaunchProfiler.shared.finish()

        XCTAssertNil(report)
    }
}

final class LaunchReportTests: XCTestCase {

    func testFormattedSummary() {
        let milestones = [
            LaunchReport.Milestone(name: "Init", absoluteTime: 0, relativeToPrevious: 0.1, relativeToStart: 0.1),
            LaunchReport.Milestone(name: "UI Ready", absoluteTime: 0, relativeToPrevious: 0.3, relativeToStart: 0.4),
        ]
        let report = LaunchReport(totalDuration: 0.4, milestones: milestones)

        XCTAssertTrue(report.formattedSummary.contains("Init"))
        XCTAssertTrue(report.formattedSummary.contains("UI Ready"))
        XCTAssertTrue(report.formattedSummary.contains("0.400"))
    }

    func testThresholdClassification() {
        let threshold = LaunchThreshold(good: 1.0, acceptable: 2.0)

        XCTAssertEqual(threshold.classify(0.5), .good)
        XCTAssertEqual(threshold.classify(1.5), .acceptable)
        XCTAssertEqual(threshold.classify(3.0), .slow)
    }
}

extension LaunchThreshold.Classification: Equatable {}
