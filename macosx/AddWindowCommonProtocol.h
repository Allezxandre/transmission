//
//  AddWindowCommonProtocol.h
//  Transmission
//
//  Created by Alexandre Jouandin on 28/08/2017.
//  Copyright © 2017 The Transmission Project. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol AddWindowCommon
- (void) setPrioritySelection: (NSInteger) newPriority;
- (void) setGroupSelection: (NSInteger) newGroup;

@property (strong, readonly) NSPopUpButton * priorityPopUp;
@property (strong, readonly) NSPopUpButton * groupPopUp;
@end
