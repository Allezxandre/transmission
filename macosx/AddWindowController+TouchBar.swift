//
//  AddWindowController+TouchBar.swift
//  Transmission
//
//  Created by Alexandre Jouandin on 21/08/2017.
//  Copyright © 2017 The Transmission Project. All rights reserved.
//

import Foundation

/// Indices of the touchbar priority segmented control.
enum TouchBarPriority: Int {
    case low = 0
    case normal = 1
    case high = 2
    
    /// Conversion of the indices to match the ones of `TR_PRI_*`.
    var torrentPriority: tr_priority_t {
        switch self {
        case .low:
            return tr_priority_t(TR_PRI_LOW)
        case .normal:
            return tr_priority_t(TR_PRI_NORMAL)
        case .high:
            return tr_priority_t(TR_PRI_HIGH)
        }
    }
    
    /// Conversion of the indices to match the ones of `POPUP_PRIORITY_*` in `AddWindowController.m`.
    var popUpPriority: Int {
        switch self {
        case .low:
            return 2
        case .normal:
            return 1
        case .high:
            return 0
        }
    }
}

@available(OSX 10.12.2, *)
class AddWindowTouchBar: NSTouchBar {
    
    private static let xibName = "AddWindowTouchBar"
    
    /// Returns an instance of an AddWindowTouchBar.
    /// - parameter windowController: The window controller that will own the `xib` file.
    ///
    /// - warning: Calling this method **will** call `awakeFromNib` on `windowController`.
    ///            If the method was already called, this can lead to unexpected behaviors.
    static func instanceFromNib(withWindowController windowController: AddWindowCommon) -> AddWindowTouchBar {
        // Load the objects from the xib file
        var objects = NSArray()
        Bundle.main.loadNibNamed(xibName, owner: windowController, topLevelObjects: &objects)
        
        // Find the first AddWindowTouchBar in the objects
        var touchbar: AddWindowTouchBar? = nil
        for object in objects {
            if let object = object as? AddWindowTouchBar {
                touchbar = object
                break
            }
        }
        
        if let touchbar = touchbar {
            return touchbar
        } else {
            fatalError("Cannot find an 'AddWindowTouchBar' in xib file named '\(xibName)'. Objects found: \(objects)")
        }
    }
    
    @IBOutlet weak var windowController: AddWindowCommon!
    @IBOutlet weak var touchBarPriorityControl: NSSegmentedControl!
    
    override func awakeFromNib() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(PRIORITY_SELECTION_CHANGED_NOTIFICATION), object: windowController, queue: nil, using: self.updateTouchbarPriority)
        self.updateTouchbarPriority(notification: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateTouchbarPriority(notification: Notification?) {
        self.touchBarPriorityControl.selectSegment(withTag: self.windowController.priorityPopUp.selectedTag())
    }
    
    @IBAction func changedTouchBarPriority(_ sender: NSSegmentedControl) {
        assert(sender == self.touchBarPriorityControl, "Unexpected sender for 'changedTouchBarPriority:': \(sender)")
        var selectedPriority: TouchBarPriority! = TouchBarPriority(rawValue: sender.indexOfSelectedItem)
        if selectedPriority == nil {
            assertionFailure("Unexpected touchbar priority value selected: \(sender.indexOfSelectedItem).")
            selectedPriority = TouchBarPriority.normal
        }
        self.windowController.setPrioritySelection(selectedPriority.popUpPriority)
    }
    
}

@available(OSX 10.12.2, *)
extension AddWindowController {
    open override func makeTouchBar() -> NSTouchBar? {
        return AddWindowTouchBar.instanceFromNib(withWindowController: self)
    }
}

@available(OSX 10.12.2, *)
extension AddMagnetWindowController {
    open override func makeTouchBar() -> NSTouchBar? {
        return AddWindowTouchBar.instanceFromNib(withWindowController: self)
    }
}
