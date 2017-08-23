//
//  AddWindowController+TouchBar.swift
//  Transmission
//
//  Created by Alexandre Jouandin on 21/08/2017.
//  Copyright © 2017 The Transmission Project. All rights reserved.
//

import Foundation

extension AddWindowController {
    
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
    
    @IBAction func changedTouchBarPriority(_ sender: NSSegmentedControl) {
        assert(sender == self.touchBarPriorityControl, "Unexpected sender for 'changedTouchBarPriority:': \(sender)")
        var selectedPriority: TouchBarPriority! = TouchBarPriority(rawValue: sender.indexOfSelectedItem)
        if selectedPriority == nil {
            assertionFailure("Unexpected touchbar priority value selected: \(sender.indexOfSelectedItem).")
            selectedPriority = TouchBarPriority.normal
        }
        self.torrent().setPriority(selectedPriority.torrentPriority)
        self.priorityPopUp.selectItem(at: selectedPriority.popUpPriority)
    }
    
}
