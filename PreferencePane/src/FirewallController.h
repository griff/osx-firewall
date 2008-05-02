/*!
 @header ServiceListController.h
 @copyright Anders Borch, Brian Olsen
 @abstract Class responsible for handing interaction with services table.
 @discussion
 This file is part of Firewall.
 
 Firewall is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, version 2 of the License..
 
 Firewall is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Firewall.  If not, see <http://www.gnu.org/licenses/>. 
 */
#import <Cocoa/Cocoa.h>
#import <SecurityInterface/SFAuthorizationView.h>
#import "ServiceListProcessor.h"
#import "RuleController.h"
@class RuleController;

/*!
 @class FirewallController
 @abstract Class responsible for handing interaction with services table.
 */
@interface FirewallController : NSArrayController {
    IBOutlet RuleController *ruleController;
    IBOutlet NSTextField* status;
    IBOutlet NSTextField* statusText;
	IBOutlet NSButton* statusButton;
    IBOutlet NSTableView* list;
    IBOutlet NSButton *blockUdp;
    IBOutlet NSButton *enableLogging;
    IBOutlet NSButton *enableStealth;
    IBOutlet NSWindow* advancedSheet;
    IBOutlet NSButton *newRuleButton;
    IBOutlet NSButton *advancedButton;
    IBOutlet SFAuthorizationView* authorizationView;
    IBOutlet id owner;
}

- (void)authorizationViewCreatedAuthorization:(SFAuthorizationView *)view;
- (void)authorizationViewDidAuthorize:(SFAuthorizationView *)view;
- (void)authorizationViewDidDeauthorize:(SFAuthorizationView *)view;

- (IBAction)deleteRule:(id)sender;
- (IBAction)editRule:(id)sender;
- (IBAction)newRule:(id)sender;

/*!
 @function toggleStatus:
 @abstract Toggles status of firewall to/from on/off.
 @param sender The Start/Stop button
 */
- (IBAction)toggleStatus:(id)sender;

- (void)updateStatus;

/*!
 @function showAdvanced:
 @abstract Open the advanced settings sheet.
 @param sender The "Advaned..." button
 */
- (IBAction)showAdvanced:(id)sender;

/*!
 @function cancelAdvanced:
 @abstract handle click events from cancel button on advanced sheet
 */
- (IBAction)cancelAdvanced:(id)sender;

/*!
 @function showLog:
 @abstract handle click events from show log button on advanced sheet
 @discussion
 TODO: Find out how show log is implemented in Tiger and immitate the 
 functionality from there.
 */
- (IBAction)showLog:(id)sender;

/*!
 @function okAdvanced:
 @abstract handle click events from ok button on advanced sheet
 @discussion
 Close advanced sheet, and test whether "Block UDP traffic" checkbox has
 changed state. Invoke executeRules:(NSArray*)items asActive:(bool)active  
 with the services and extraServices as arguments in order to update firewall 
 state with new udp rules. 
 */
- (IBAction)okAdvanced:(id)sender;

- (void)didEndSheet:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo;

- (void)awakeFromNib;

@end
