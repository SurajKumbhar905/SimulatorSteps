//
//  UITestRecorderOverlay.swift
//  AppStoreTabbbar
//
//  Created by Suraj Kumbhar on 03/06/26.
//

import UIKit

#if DEBUG
public class UITestRecorderOverlay {
    public static let shared = UITestRecorderOverlay()
    private var window: UIWindow?
    private var button: UIButton?
    
    public func show() {
        guard window == nil else { return }
        
        // Find active window scene to attach our floating control window
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        let overlayWindow = UIWindow(windowScene: windowScene)
        overlayWindow.windowLevel = .alert + 1
        overlayWindow.frame = CGRect(x: 20, y: 100, width: 90, height: 45)
        overlayWindow.backgroundColor = .clear
        
        let toggleButton = UIButton(type: .system)
        toggleButton.frame = overlayWindow.bounds
        toggleButton.backgroundColor = UIColor.systemRed
        toggleButton.setTitle("⏺ Record", for: .normal)
        toggleButton.setTitleColor(.white, for: .normal)
        toggleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        toggleButton.layer.cornerRadius = 12
        toggleButton.accessibilityIdentifier = "rec_toggle_btn"
        toggleButton.addTarget(self, action: #selector(toggleRecording), for: .touchUpInside)
        
        overlayWindow.addSubview(toggleButton)
        overlayWindow.isHidden = false
        
        self.button = toggleButton
        self.window = overlayWindow
    }
    
    @objc private func toggleRecording() {
        if UITestRecorder.shared.isRecording {
            button?.backgroundColor = UIColor.systemRed
            button?.setTitle("⏺ Record", for: .normal)
            
            if let jsonLog = UITestRecorder.shared.stopRecording() {
                print("\n📋 Copy the JSON payload below and give it to your AI Agent:\n")
                print(jsonLog)
                print("\n======================================================\n")
            }
        } else {
            button?.backgroundColor = UIColor.systemGreen
            button?.setTitle("⏹ Stop", for: .normal)
            UITestRecorder.shared.startRecording()
        }
    }
}
#endif
