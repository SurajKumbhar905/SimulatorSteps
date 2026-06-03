#!/bin/bash

case "$1" in
    start)
        echo "🚀 [Recorder] Starting capture..."
        xcrun simctl openurl booted "testrecorder://start"
        ;;
    stop)
        echo "🛑 [Recorder] Stopping capture..."
        xcrun simctl openurl booted "testrecorder://stop"
        
        # Give the simulator a split second to sync the clipboard to the Mac
        sleep 0.5
        
        echo "💾 Saving JSON file to Desktop..."
        # 'pbpaste' is a native macOS tool that extracts text directly from your Mac's clipboard
        pbpaste > ~/Desktop/ui_test_steps.json
        
        echo "✅ Done! Saved to ~/Desktop/ui_test_steps.json"
        ;;
    *)
        echo "Usage: ./recorder.sh {start|stop}"
        exit 1
        ;;
esac
