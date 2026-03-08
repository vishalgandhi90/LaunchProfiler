import Foundation

/// Configuration for the LaunchProfiler.
public struct LaunchProfilerConfiguration {

    public enum ReportingMode {
        case console
        case delegate
        case silent
    }

    /// Whether profiling is enabled.
    public let enabled: Bool

    /// Thresholds for classifying launch performance.
    public let thresholds: LaunchThreshold

    /// How reports are delivered.
    public let reportingMode: ReportingMode

    /// Whether profiling runs in release builds.
    public let isEnabledInRelease: Bool

    public init(
        enabled: Bool = true,
        thresholds: LaunchThreshold = LaunchThreshold(),
        reportingMode: ReportingMode = .console,
        isEnabledInRelease: Bool = false
    ) {
        self.enabled = enabled
        self.thresholds = thresholds
        self.reportingMode = reportingMode
        self.isEnabledInRelease = isEnabledInRelease
    }
}
