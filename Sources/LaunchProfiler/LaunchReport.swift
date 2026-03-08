import Foundation

/// A report containing the results of a launch profiling session.
public struct LaunchReport {

    /// A single milestone recorded during launch.
    public struct Milestone {
        public let name: String
        public let absoluteTime: CFAbsoluteTime
        public let relativeToPrevious: TimeInterval
        public let relativeToStart: TimeInterval

        public init(name: String, absoluteTime: CFAbsoluteTime, relativeToPrevious: TimeInterval, relativeToStart: TimeInterval) {
            self.name = name
            self.absoluteTime = absoluteTime
            self.relativeToPrevious = relativeToPrevious
            self.relativeToStart = relativeToStart
        }
    }

    public let totalDuration: TimeInterval
    public let milestones: [Milestone]

    public init(totalDuration: TimeInterval, milestones: [Milestone]) {
        self.totalDuration = totalDuration
        self.milestones = milestones
    }

    /// The milestone that took the longest time relative to its predecessor.
    public var slowestMilestone: Milestone? {
        milestones.max(by: { $0.relativeToPrevious < $1.relativeToPrevious })
    }

    /// A formatted summary string suitable for console output.
    public var formattedSummary: String {
        var lines: [String] = []
        lines.append("========================================")
        lines.append("  Launch Profile Report")
        lines.append("========================================")

        for milestone in milestones {
            let ms = String(format: "%.0fms", milestone.relativeToPrevious * 1000)
            lines.append("  \(milestone.name.padding(toLength: 16, withPad: " ", startingAt: 0)) \(ms)")
        }

        lines.append("----------------------------------------")
        lines.append("  Total           \(String(format: "%.3fs", totalDuration))")

        if let slowest = slowestMilestone {
            lines.append("  Slowest         \(slowest.name) (\(String(format: "%.0fms", slowest.relativeToPrevious * 1000)))")
        }

        lines.append("========================================")
        return lines.joined(separator: "\n")
    }
}
