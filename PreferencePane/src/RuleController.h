/*!
 @header RuleController.h
 @copyright Anders Borch, Brian Olsen
 @abstract Class responsible for handling editing and creating of firewall rules.
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
#import "CustomFirewallEntry.h"

@interface RuleController : NSObject {
    IBOutlet NSTextField *descriptionLabel;
    IBOutlet NSTextField *description;
    IBOutlet NSTextField *tcpPorts;
    IBOutlet NSTextField *udpPorts;
    IBOutlet NSWindow *edit_rule;
    IBOutlet NSButton *okButton;
    IBOutlet NSPopUpButton *portsPopup;
    IBOutlet id owner;
	CustomFirewallEntry *entry;
    NSInteger entryIdx;
}

- (IBAction)cancel:(id)sender;
- (IBAction)ok:(id)sender;
- (IBAction)activateOther:(id)sender;
- (IBAction)portSelected:(id)sender;

- (BOOL)verified;
- (void)showSheet:(NSInteger)idx;
- (void)awakeFromNib;

@end
