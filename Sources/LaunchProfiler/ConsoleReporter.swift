import Foundation

/// Prints a formatted launch report to the console.
public enum ConsoleReporter {

    public static func print(report: LaunchReport, thresholds: LaunchThreshold) {
        var output = "\n"
        output += "========================================\n"
        output += "  Launch Profile Report\n"
        output += "========================================\n"

        for milestone in report.milestones {
            let ms = String(format: "%6.0fms", milestone.relativeToPrevious * 1000)
            let classification = thresholds.classify(milestone.relativeToPrevious)
            output += "  \(milestone.name.padding(toLength: 16, withPad: " ", startingAt: 0)) \(ms)  \(classification.emoji)\n"
        }

        output += "----------------------------------------\n"

        let totalClassification = thresholds.classify(report.totalDuration)
        output += "  Total           \(String(format: "%.3fs", report.totalDuration))  \(totalClassification.emoji)\n"

        if let slowest = report.slowestMilestone {
            output += "  Slowest         \(slowest.name) (\(String(format: "%.0fms", slowest.relativeToPrevious * 1000)))\n"
        }

        output += "========================================\n"

        Swift.print(output)
    }
}
