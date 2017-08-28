//
//  AddWindowCommonProtocol.h
//  Transmission
//
//  Created by Alexandre Jouandin on 28/08/2017.
//  Copyright © 2017 The Transmission Project. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define GROUP_SELECTION_CHANGED_NOTIFICATION @"GroupSelectionChangedNotification"
#define PRIORITY_SELECTION_CHANGED_NOTIFICATION @"PrioritySelectionChangedNotification"

#define POPUP_PRIORITY_HIGH 0
#define POPUP_PRIORITY_NORMAL 1
#define POPUP_PRIORITY_LOW 2

@protocol AddWindowCommon
- (IBAction) setDestination: (id) sender;
- (IBAction) add: (id) sender;
- (IBAction) cancelAdd: (id) sender;
- (IBAction) changePriority: (id) sender;

- (void) setPrioritySelection: (NSInteger) newPriority;
- (void) setGroupSelection: (NSInteger) newGroup;

@property (strong, readonly) NSPopUpButton * priorityPopUp;
@property (strong, readonly) NSPopUpButton * groupPopUp;
@end
