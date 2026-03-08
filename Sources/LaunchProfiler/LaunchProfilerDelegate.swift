import Foundation

/// Protocol for receiving launch profiling reports.
public protocol LaunchProfilerDelegate: AnyObject {
    func launchProfiler(didFinishWithReport report: LaunchReport)
}
