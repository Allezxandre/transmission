//
//  Controller+NSSharingServicePickerTouchBarItemDelegate.swift
//  Transmission
//
//  Created by Alexandre Jouandin on 17/08/2017.
//  Copyright © 2017 The Transmission Project. All rights reserved.
//

import Foundation

@available(OSX 10.12.2, *)
extension Controller: NSSharingServicePickerTouchBarItemDelegate {
    public func items(for pickerTouchBarItem: NSSharingServicePickerTouchBarItem) -> [Any] {
        return ShareTorrentFileHelper.shared().shareTorrentURLs()
    }
}
