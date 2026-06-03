suraj@Surajs-MacBook-Air Overlay % ~/Desktop/recorder.sh start
🚀 [Recorder] Starting capture...
suraj@Surajs-MacBook-Air Overlay % ~/Desktop/recorder.sh stop 
import SwiftUI

@main
struct AppStoreTabbbarApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
#if DEBUG
                    // Listen to external commands fired from your Mac
                    if url.host == "start" {
                        UITestRecorder.shared.startRecording()
                    } else if url.host == "stop" {
                        if let jsonLog = UITestRecorder.shared.stopRecording() {
                            // Copy directly to the clipboard.
                            // Because of Simulator integration, this copies directly to your Mac clipboard!
                            UIPasteboard.general.string = jsonLog
                            print("📋 JSON copied directly to your Mac clipboard.")
                        }
                    }
#endif
                }
        }
    }
}
