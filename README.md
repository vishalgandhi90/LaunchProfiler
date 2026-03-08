# LaunchProfiler

![CI](https://github.com/vishalgandhi90/LaunchProfiler/actions/workflows/ci.yml/badge.svg)
![Swift 5.9+](https://img.shields.io/badge/Swift-5.9+-orange.svg)
![iOS 15+](https://img.shields.io/badge/iOS-15+-blue.svg)
![SPM Compatible](https://img.shields.io/badge/SPM-Compatible-brightgreen.svg)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

A lightweight iOS app startup time profiling library. Drop it in, add milestones, and get a detailed breakdown of your launch performance — no setup required.

## Console Output

```
┌──────────────────────────────────────────────────────────────┐
│                    Launch Profile Report                     │
├──────────────────────────┬──────────┬──────────┬─────────────┤
│ Milestone                │ Duration │ Total    │ % of Total  │
├──────────────────────────┼──────────┼──────────┼─────────────┤
│ 🟢 App Delegate            │   0.042s │   0.042s │    5.3%     │
│ 🟢 Dependency Injection    │   0.128s │   0.170s │   16.2%     │
│ 🟡 Initial Data Fetch      │   0.340s │   0.510s │   43.0%     │
│ 🟢 First Screen Render     │   0.095s │   0.605s │   12.0%     │
│ 🟢 Interactive             │   0.186s │   0.791s │   23.5%     │
│ 🟢 Finish                  │   0.000s │   0.791s │    0.0%     │
├──────────────────────────┴──────────┴──────────┴─────────────┤
│ 🟢 Total: 0.791s                                             │
│ ⚠️  Slowest: Initial Data Fetch (0.340s)                      │
└──────────────────────────────────────────────────────────────┘
```

## Features

- **Zero dependencies** — Pure Swift, no external libraries
- **Lightweight** — Minimal overhead, safe for production
- **Thread-safe** — Record milestones from any thread
- **Configurable thresholds** — Color-coded output (🟢 good, 🟡 acceptable, 🔴 slow)
- **Custom reporting** — Send reports to analytics via delegate
- **DEBUG-only by default** — No performance impact in release builds

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/vishalgandhi90/LaunchProfiler.git", from: "1.0.0")
]
```

## Quick Start

### 1. Start the profiler (as early as possible)

```swift
// In AppDelegate or @main App
import LaunchProfiler

func application(_ application: UIApplication,
                 didFinishLaunchingWithOptions launchOptions: ...) -> Bool {
    LaunchProfiler.shared.start()

    // Your existing setup...
    LaunchProfiler.shared.mark("App Delegate")
    return true
}
```

### 2. Add milestones throughout your launch

```swift
// After DI container setup
LaunchProfiler.shared.mark("Dependency Injection")

// After initial API call
LaunchProfiler.shared.mark("Initial Data Fetch")

// After first screen appears
LaunchProfiler.shared.mark("First Screen Render")
```

### 3. Finish when the app is interactive

```swift
// In your first view's viewDidAppear or onAppear
LaunchProfiler.shared.mark("Interactive")
LaunchProfiler.shared.finish()
```

## Configuration

```swift
LaunchProfiler.shared.configure(LaunchProfilerConfiguration(
    enabled: true,
    thresholds: LaunchThreshold(good: 0.5, acceptable: 1.5),
    autoFinishAfterSeconds: 10.0,  // Safety net auto-finish
    reportingMode: .both,          // .console, .delegate, or .both
    isEnabledInRelease: false      // Only profile in DEBUG by default
))
```

## Custom Reporting

Send launch data to your analytics service:

```swift
class LaunchAnalytics: LaunchProfilerDelegate {
    func didFinishProfiling(report: LaunchReport) {
        // Send to Datadog, Firebase, etc.
        Analytics.track("app_launch", properties: [
            "total_duration": report.totalDuration,
            "slowest_step": report.slowestMilestone?.name ?? "",
            "slowest_duration": report.slowestMilestone?.relativeToPrevious ?? 0
        ])
    }
}

// Set delegate before finishing
LaunchProfiler.shared.delegate = launchAnalytics
```

## Requirements

- iOS 15+
- Swift 5.9+
- Xcode 15+

## License

MIT License. See [LICENSE](LICENSE) for details.

## Author

**Vishal Gandhi** — [vishalgandhi.dev](https://vishalgandhi.dev) · [GitHub](https://github.com/vishalgandhi90)
