import Foundation

/// Configurable thresholds for classifying launch performance.
public struct LaunchThreshold {

    public enum Classification {
        case good
        case acceptable
        case slow

        public var emoji: String {
            switch self {
            case .good: return "✅"
            case .acceptable: return "⚠️"
            case .slow: return "🔴"
            }
        }
    }

    /// Maximum duration (in seconds) considered "good".
    public let good: TimeInterval

    /// Maximum duration (in seconds) considered "acceptable".
    public let acceptable: TimeInterval

    public init(good: TimeInterval = 1.0, acceptable: TimeInterval = 2.0) {
        self.good = good
        self.acceptable = acceptable
    }

    /// Classify a duration based on the configured thresholds.
    public func classify(_ duration: TimeInterval) -> Classification {
        if duration <= good {
            return .good
        } else if duration <= acceptable {
            return .acceptable
        } else {
            return .slow
        }
    }
}
