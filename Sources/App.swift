import SwiftUI

@main
struct TechChallengeApp: App {

#if DEBUG
    var body: some Scene {
        WindowGroup {
            if ProcessInfo.processInfo.environment["IS_UNIT_TESTING"] == "1" {
                Text("Running tests")
            } else {
                RootFlow().rootView
            }
        }
    }
#else
    var body: some Scene {
        WindowGroup {
            RootFlow().rootView
        }
    }
#endif

}
