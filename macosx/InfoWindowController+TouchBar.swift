//
//  InfoWindowController+TouchBar.swift
//  Transmission
//
//  Created by Alexandre Jouandin on 28/08/2017.
//  Copyright © 2017 The Transmission Project. All rights reserved.
//

import Foundation


class SwiftInfoWindowController: InfoWindowController {
    
    @IBOutlet var touchbarTabControl: NSSegmentedControl! {
        didSet {
            NotificationCenter.default.addObserver(forName: NSNotification.Name(INFO_TAB_CHANGED_NOTIFICATION), object: self, queue: nil, using: self.updateTouchBarTab)
            // Set labels
            assert(touchbarTabControl.segmentCount == 6, "Unexpected segment count for touchbar tab control.")
            touchbarTabControl.setLabel(NSLocalizedString("General Info", comment: "Inspector -> tab"), forSegment: Int(TAB_GENERAL_TAG.rawValue))
            touchbarTabControl.setLabel(NSLocalizedString("Activity", comment: "Inspector -> tab"), forSegment: Int(TAB_ACTIVITY_TAG.rawValue))
            touchbarTabControl.setLabel(NSLocalizedString("Trackers", comment: "Inspector -> tab"), forSegment: Int(TAB_TRACKERS_TAG.rawValue))
            touchbarTabControl.setLabel(NSLocalizedString("Peers", comment: "Inspector -> tab"), forSegment: Int(TAB_PEERS_TAG.rawValue))
            touchbarTabControl.setLabel(NSLocalizedString("Files", comment: "Inspector -> tab"), forSegment: Int(TAB_FILE_TAG.rawValue))
            touchbarTabControl.setLabel(NSLocalizedString("Options", comment: "Inspector -> tab"), forSegment: Int(TAB_OPTIONS_TAG.rawValue))
            
            // Remove images
            for tag in 0..<touchbarTabControl.segmentCount {
                touchbarTabControl.setImage(nil, forSegment: tag)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(INFO_TAB_CHANGED_NOTIFICATION), object: self)
    }
    
    func updateTouchBarTab(notification: Notification) {
        self.touchbarTabControl.selectSegment(withTag: self.tabMatrix.selectedTag())
    }
    
    @available(OSX 10.12.2, *)
    @IBAction func userSelectedTouchBarItem(sender: NSSegmentedControl) {
        self.tabMatrix.selectCell(withTag: sender.selectedSegment)
        self.setTab(nil)
    }
}
