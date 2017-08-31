//
//  URLSheetWindowController.swift
//  Transmission
//
//  Created by Alexandre Jouandin on 31/08/2017.
//  Copyright © 2017 The Transmission Project. All rights reserved.
//

import Cocoa

class URLSheetWindowController: NSWindowController {
    
    var urlString: String? = nil
    private var controller: Controller
    
    @IBOutlet var labelField: NSTextField!
    @IBOutlet var textField: NSTextField!
    @IBOutlet var openButton: NSButton!
    @IBOutlet var cancelButton: NSButton!
    
    // TouchBar support
    @IBOutlet var touchBarOpenButton: NSButton?
    @IBOutlet var touchBarCancelButton: NSButton?
    
    override var windowNibName: String! {
        return "URLSheetWindow"
    }
    
    // MARK: Init
    public init(controller: Controller) { // FIXME: Use swift-way
        self.controller = controller
        super.init(window: nil) // uses `self.windowNibName`
    }
    
    required init?(coder: NSCoder) {
        // Cannot retrieve the controller from coder
        fatalError("init(coder:) cannot be used on URLSheetWindowController")
    }
    
    override func awakeFromNib() {
        self.labelField.stringValue = NSLocalizedString("Internet address of torrent file:", comment: "URL sheet label")
        
        if let urlString = urlString {
            self.textField.stringValue = urlString
            self.textField.selectText(self)
            
            self.updateOpenButton(forURL: urlString)
        }
        
        openButton.title = NSLocalizedString("Open", comment: "URL sheet button")
        cancelButton.title = NSLocalizedString("Cancel", comment: "URL sheet button")
        openButton.sizeToFit()
        cancelButton.sizeToFit()
        
        touchBarOpenButton?.title = NSLocalizedString("Open", comment: "URL sheet button")
        touchBarCancelButton?.title = NSLocalizedString("Cancel", comment: "URL sheet button")
        touchBarOpenButton?.sizeToFit()
        touchBarCancelButton?.sizeToFit()
    }
    
    
    @IBAction open func openURLEndSheet(_ sender: Any?) {
        guard let window = self.window else {
            assertionFailure("URLSheetWindowController has no window.")
            return
        }
        window.orderOut(sender)
        NSApp.endSheet(window, returnCode: 1)
    }
    
    @IBAction func openURLCancelEndSheet(_ sender: Any?) {
        guard let window = self.window else {
            assertionFailure("URLSheetWindowController has no window.")
            return
        }
        window.orderOut(sender)
        NSApp.endSheet(window, returnCode: 0)
    }
    
    override func controlTextDidChange(_ obj: Notification) {
        self.updateOpenButton(forURL: self.textField.stringValue)
    }
    
    private func updateOpenButton(forURL url: String) {
        var enable = true
        enable = !url.isEmpty && {
            let prefixRange = NSString(string: url).range(of: "://")
            return (prefixRange.location == NSNotFound) || NSMaxRange(prefixRange) != url.characters.count
        }()
        
        self.openButton.isEnabled = enable
        self.touchBarOpenButton?.isEnabled = enable
    }
    
    

}

// MARK: -

// MARK: TouchBar
@available(OSX 10.12.2, *)
class URLSheetTouchBar: NSTouchBar {
    private static let xibName = "URLSheetWindow+TouchBar"
    
    /// Returns an instance of an AddWindowTouchBar
    static func instanceFromNib(withWindowController windowController: URLSheetWindowController) -> URLSheetTouchBar {
        // Load the objects from the xib file
        var objects = NSArray()
        Bundle.main.loadNibNamed(xibName, owner: windowController, topLevelObjects: &objects)
        
        // Find the first AddWindowTouchBar in the objects
        var touchbar: URLSheetTouchBar? = nil
        for object in objects {
            if let object = object as? URLSheetTouchBar {
                touchbar = object
                break
            }
        }
        
        if let touchbar = touchbar {
            return touchbar
        } else {
            fatalError("Cannot find an 'URLSheetTouchBar' in xib file named '\(xibName)'. Objects found: \(objects)")
        }
    }
}

// MARK: TouchBar support
@available(OSX 10.12.2, *)
extension URLSheetWindowController {
    override func makeTouchBar() -> NSTouchBar? {
        return URLSheetTouchBar.instanceFromNib(withWindowController: self)
    }
    
    @IBAction func performClickOnOpen(_ sender: NSButton) {
        self.openButton.performClick(sender)
    }
    
    @IBAction func performClickOnCancel(_ sender: NSButton) {
        self.cancelButton.performClick(sender)
    }
}
