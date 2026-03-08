import Foundation

/// A lightweight profiler for measuring iOS app launch performance.
/// Uses a milestone-based approach to track time spent in each phase of startup.
public final class LaunchProfiler {

    public static let shared = LaunchProfiler()

    private let lock = NSLock()
    private var startTime: CFAbsoluteTime = 0
    private var previousTime: CFAbsoluteTime = 0
    private var milestones: [(name: String, absolute: CFAbsoluteTime)] = []
    private var isRunning = false
    private var configuration = LaunchProfilerConfiguration()

    public weak var delegate: LaunchProfilerDelegate?

    private init() {}

    /// Configure the profiler with custom settings.
    public func configure(_ config: LaunchProfilerConfiguration) {
        lock.lock()
        defer { lock.unlock() }
        configuration = config
    }

    /// Start profiling. Call this at the very beginning of your app's launch.
    public func start() {
        lock.lock()
        defer { lock.unlock() }

        guard configuration.enabled else { return }

        startTime = CFAbsoluteTimeGetCurrent()
        previousTime = startTime
        milestones = []
        isRunning = true
    }

    /// Mark a milestone during launch. Call this after each significant initialization step.
    public func mark(_ name: String) {
        lock.lock()
        defer { lock.unlock() }

        guard isRunning else { return }

        let now = CFAbsoluteTimeGetCurrent()
        milestones.append((name: name, absolute: now))
        previousTime = now
    }

    /// Finish profiling and generate a report.
    @discardableResult
    public func finish() -> LaunchReport? {
        lock.lock()
        defer { lock.unlock() }

        guard isRunning, configuration.enabled else {
            isRunning = false
            return nil
        }

        let endTime = CFAbsoluteTimeGetCurrent()
        milestones.append((name: "Finish", absolute: endTime))

        let totalDuration = endTime - startTime

        var prev = startTime
        let reportMilestones: [LaunchReport.Milestone] = milestones.map { milestone in
            let relativeToPrevious = milestone.absolute - prev
            let relativeToStart = milestone.absolute - startTime
            prev = milestone.absolute
            return LaunchReport.Milestone(
                name: milestone.name,
                absoluteTime: milestone.absolute,
                relativeToPrevious: relativeToPrevious,
                relativeToStart: relativeToStart
            )
        }

        let report = LaunchReport(totalDuration: totalDuration, milestones: reportMilestones)
        isRunning = false

        if configuration.reportingMode == .console {
            ConsoleReporter.print(report: report, thresholds: configuration.thresholds)
        }

        delegate?.launchProfiler(didFinishWithReport: report)

        return report
    }
}
