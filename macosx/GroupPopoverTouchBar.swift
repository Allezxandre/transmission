//
//  GroupPopoverTouchBar.swift
//  Transmission
//
//  Created by Alexandre Jouandin on 23/08/2017.
//  Copyright © 2017 The Transmission Project. All rights reserved.
//

import Cocoa

@available(OSX 10.12.2, *)
class GroupPopoverTouchBarItem: NSPopoverTouchBarItem {
    
    @IBOutlet var windowController: AddWindowCommon! {
        didSet {
            NotificationCenter.default.addObserver(forName: NSNotification.Name(GROUP_SELECTION_CHANGED_NOTIFICATION), object: windowController, queue: nil, using: self.updatePopoverButton)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBOutlet var buttonScrollView: NSScrollView! {
        didSet {
            let buttons = GroupsController.groups().touchbarGroupItems(withAction: #selector(groupButtonTouched), onTarget: self)
            
            // Create a scroll view of button, from https://stackoverflow.com/a/42772296
            let documentView = NSView(frame: NSRect.zero)
            var constraintViews = [String: NSView]()
            var visualFormat = "H:|-8-"
            var size = NSSize(width: 8, height: 30)
            for (index, button) in buttons.enumerated() {
                documentView.addSubview(button)
                size.width += 8 + button.intrinsicContentSize.width
                button.translatesAutoresizingMaskIntoConstraints = false
                let buttonConstraintName = "button\(index)"
                constraintViews[buttonConstraintName] = button
                visualFormat += "[\(buttonConstraintName)]-8-"
            }
            visualFormat += "|"
            let constraints = NSLayoutConstraint.constraints(withVisualFormat: visualFormat, options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: constraintViews)
            size.width += 100 // FIXME: computed width isn't enough so we use this workaround
            documentView.setFrameSize(size)
            NSLayoutConstraint.activate(constraints)
            buttonScrollView.documentView = documentView
            buttonScrollView.verticalScroller = nil
            buttonScrollView.rulersVisible = false
            buttonScrollView.autoresizesSubviews = false
            buttonScrollView.automaticallyAdjustsContentInsets = false
        }
    }
    
    func groupButtonTouched(sender: NSButton) {
        // For this to work, the tags from the touchbar have to match those of the set-up menu
        if let tag = sender.cell?.tag {
            self.windowController.setGroupSelection(tag)
        } else {
            assertionFailure("No tag on sender cell. Cannot determine group.")
        }
        self.dismissPopover(sender)
    }
    
    func updatePopoverButton(notification: Notification) {
        if let selectedItem = self.windowController.groupPopUp.selectedItem {
            self.collapsedRepresentationLabel = selectedItem.title
            self.collapsedRepresentationImage = selectedItem.image
        } else {
            assertionFailure("Received notification for group update but cannot determine the selected item.")
        }
    }
}

@available(OSX 10.12.2, *)
extension GroupsController {
    
    /// Generates a list of TouchBar buttons that represent the Transmission download groups.
    /// - parameter action: The action to pass to each button.
    /// - parameter target: The target to pass to each button.
    func touchbarGroupItems(withAction action: Selector?, onTarget target: Any?) -> [NSButton] {
        var groupItems = [NSButton]()
        
        let noneGroup = NSMutableDictionary(dictionary: [
            "Name" : NSLocalizedString("None", comment: "Groups -> Menu"),
            "Index": -1,
            ])
        let noneImage = NSImage(named: "GroupsNoneTemplate")
        
        if let noneItem = touchbarItem(forGroup: noneGroup, withImage: noneImage, withTarget: target, withAction: action) {
            groupItems.append(noneItem)
        } // else case already handled inside touchbarItem:forGroup:...
        
        for group in self.groups as! Array<NSMutableDictionary> {
            if let groupItem = touchbarItem(forGroup: group, withTarget: target, withAction: action) {
                groupItems.append(groupItem)
            } // else case already handled inside touchbarItem:forGroup:...
        }
        
        return groupItems
    }
    
    /// Generates a touchbar button corresponding to a Transmission download group.
    /// - parameter group: The group to represent.
    /// - parameter image: (optional) The image to use for the button, if `nil`, this method will
    ///                    call `image:forGroup` to get an image.
    /// - parameter target: The target to pass to the button.
    /// - parameter action: The action to pass to the button.
    ///
    /// - Important: The 'Index' key from the `group` argument is used to generate the tags of the TouchBar buttons,
    ///              and those tags are then passed to the groupPopUp menu of the `AddWindowController`,
    ///              so the **groupPopUp menu has to use 'Index' to generate its tags** so that they match.
    private func touchbarItem(forGroup group: NSMutableDictionary, withImage image: NSImage? = nil, withTarget target: Any?, withAction action: Selector?) -> NSButton? {
        guard let name = group["Name"] as? String,
            let index = group["Index"] as? Int else {
            // The keys don't exist or the objects don't have the right format
            assertionFailure("Unexpected group object received (an expected key is missing): \(group)")
            return nil
        }
        
        let button = NSButton(title: name,
                              image: image ?? self.image(forGroup: group),
                              target: target, action: action)
        button.cell?.tag = index
        return button
    }
}
