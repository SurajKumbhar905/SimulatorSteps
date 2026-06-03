//
//  UITestRecorder.swift
//  AppStoreTabbbar
//
//  Created by Suraj Kumbhar on 03/06/26.
//

import UIKit

#if DEBUG
public class UITestRecorder {
    public static let shared = UITestRecorder()
    
    public private(set) var isRecording = false
    private var steps: [[String: Any]] = []
    
    public func startRecording() {
        _ = UIWindow.swizzleSendEvent
        isRecording = true
        steps.removeAll()
        print("🚀 [UITestRecorder] Recording started. Tap elements on the simulator.")
    }
    
    public func stopRecording() -> String? {
        isRecording = false
        print("🛑 [UITestRecorder] Recording stopped.")
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: steps, options: .prettyPrinted),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return nil
        }
        return jsonString
    }
    
    fileprivate func recordTap(on view: UIView) {
        if view.accessibilityIdentifier == "rec_toggle_btn" { return }
        
        // Use the deep hierarchy scanner to find hidden identifiers or text labels
        let metadata = resolveMetadata(for: view)
        let className = String(describing: type(of: view))
        
        let step: [String: Any] = [
            "action": "tap",
            "element_type": className,
            "accessibility_identifier": metadata.identifier,
            "accessibility_label": metadata.label,
            "visible_text": metadata.text,
            "timestamp": Date().timeIntervalSince1970
        ]
        
        steps.append(step)
        print("📸 [UITestRecorder] Logged step: Tap -> ID: \(metadata.identifier) | Type: \(className) | Text: \(metadata.text)")
    }
    
    /// Recursively digs into a view and its children to extract valid automated testing keys
    private func resolveMetadata(for view: UIView) -> (identifier: String, label: String, text: String) {
        // 1. Direct inspection
        var id = view.accessibilityIdentifier
        var label = view.accessibilityLabel
        var text = extractText(from: view)
        
        // 2. Dynamic Deep-Scan fallback for system layout wrappers (like _UITabButton)
        if id == nil || id == "MISSING_IDENTIFIER" || text.isEmpty {
            let deepMatch = scanSubviews(inside: view)
            if id == nil || id == "" { id = deepMatch.identifier }
            if label == nil || label == "" { label = deepMatch.label }
            if text.isEmpty { text = deepMatch.text }
        }
        
        // Clean formatting fallback paths
        let finalID = id ?? "MISSING_IDENTIFIER"
        let finalLabel = label ?? ""
        
        // Ultimate fallback: if no ID was found but we found visible text, use text as ID
        let optimizedID = (finalID == "MISSING_IDENTIFIER" && !text.isEmpty) ? text : finalID
        
        return (optimizedID, finalLabel, text)
    }
    
    /// Deep hierarchy inspector loop
    private func scanSubviews(inside parentView: UIView) -> (identifier: String?, label: String?, text: String) {
        var foundID: String? = nil
        var foundLabel: String? = nil
        var foundText = ""
        
        for subview in parentView.subviews {
            // Check if subview contains an identifier
            if let subID = subview.accessibilityIdentifier, !subID.isEmpty {
                foundID = subID
            }
            if let subLabel = subview.accessibilityLabel, !subLabel.isEmpty {
                foundLabel = subLabel
            }
            
            let txt = extractText(from: subview)
            if !txt.isEmpty {
                foundText = txt
            }
            
            // Continue drilling down if things are still missing
            if foundID == nil || foundText.isEmpty {
                let deepResult = scanSubviews(inside: subview)
                if foundID == nil { foundID = deepResult.identifier }
                if foundLabel == nil { foundLabel = deepResult.label }
                if foundText.isEmpty { foundText = deepResult.text }
            }
        }
        return (foundID, foundLabel, foundText)
    }
    
    private func extractText(from view: UIView) -> String {
        if let label = view as? UILabel { return label.text ?? "" }
        if let button = view as? UIButton { return button.titleLabel?.text ?? "" }
        if let textField = view as? UITextField { return textField.text ?? "" }
        
        // Reflection check for private mirror classes containing a text property
        let mirror = Mirror(reflecting: view)
        for child in mirror.children where child.label == "text" {
            if let textValue = child.value as? String { return textValue }
        }
        return ""
    }
}

// MARK: - Method Swizzling for UIWindow
extension UIWindow {
    static let swizzleSendEvent: Void = {
        let originalSelector = #selector(sendEvent(_:))
        let swizzledSelector = #selector(swizzled_sendEvent(_:))
        
        guard let originalMethod = class_getInstanceMethod(UIWindow.self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(UIWindow.self, swizzledSelector) else { return }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }()
    
    @objc func swizzled_sendEvent(_ event: UIEvent) {
        self.swizzled_sendEvent(event)
        
        guard UITestRecorder.shared.isRecording else { return }
        
        if event.type == .touches,
           let touches = event.allTouches,
           let touch = touches.first,
           touch.phase == .ended {
            
            let location = touch.location(in: self)
            if let hitView = self.hitTest(location, with: event) {
                UITestRecorder.shared.recordTap(on: hitView)
            }
        }
    }
}
#endif
