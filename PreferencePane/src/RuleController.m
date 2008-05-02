/*
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
#import "RuleController.h"
#import "FirewallEntry.h"
#import "PortsFormatter.h"

@implementation RuleController

- (IBAction)cancel:(id)sender {
    [entry release];
    [NSApp endSheet: edit_rule];
}

- (IBAction)ok:(id)sender {
	if( [self verified] )
    {
        if( entryIdx >= 0) {
            [[owner processor] updateSingleService:entry 
                                       tcp:[tcpPorts objectValue]
                                       udp:[udpPorts objectValue]
                               description:[description stringValue]
                              selectedPort: ([description isHidden] ? [portsPopup indexOfSelectedItem] : -1) ];
        } else {
            [entry setTcp: [tcpPorts objectValue]];
            [entry setUdp: [udpPorts objectValue]];
            [entry setName: [description stringValue]];

            if( [description isHidden]) {
                [entry setSelectedPort: [portsPopup indexOfSelectedItem]];
            } else {
                [entry setSelectedPort: -1];
            }
            [[owner processor] addObjectToServices: entry];
        }
		[NSApp endSheet: edit_rule];
    }
    [entry release];
}

- (IBAction)activateOther:(id)sender {
    [tcpPorts setObjectValue: [entry tcp]];
    [udpPorts setObjectValue: [entry udp]];
    [description setStringValue: [entry name]];
    [tcpPorts setEnabled: YES];
    [udpPorts setEnabled: YES];
    [description setHidden: NO];
    [descriptionLabel setHidden: NO];
}

- (IBAction)portSelected:(id)sender {
    NSArray* ports = [[owner processor] ports];
    NSInteger idx = [portsPopup indexOfSelectedItem];
    NSUInteger count = [ports count];
    if( count >  idx) {
        PortsEntry* pEntry = [ports objectAtIndex: idx];
        [tcpPorts setObjectValue: [pEntry tcp]];
        [udpPorts setObjectValue: [pEntry udp]];
        [description setStringValue: [pEntry name]];
        [tcpPorts setEnabled: NO];
        [udpPorts setEnabled: NO];
        [description setHidden: YES];
        [descriptionLabel setHidden: YES];
    }
}

- (BOOL)verified {
	NSString* string = [description stringValue];
	string = [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];

	NSLog(@"Verify '%@', '%@', '%@'", [tcpPorts objectValue], [udpPorts objectValue], [description stringValue]);
	return (([tcpPorts objectValue] != nil && [[tcpPorts objectValue] count] > 0 ) ||
		 ([udpPorts objectValue] != nil && [[udpPorts objectValue] count] > 0 ) ) &&
		  ![string isEqual: @""];
}

- (void)showSheet:(NSInteger)idx {
    if( idx < 0 ) {
        entry = [[CustomFirewallEntry alloc] initWithProcessor:[owner processor]];
        entryIdx = -1;
        [portsPopup selectItemAtIndex:0];
        [self portSelected:nil];
    } else { 
        entryIdx = idx;
        entry = (CustomFirewallEntry *)[[owner processor] objectInServicesAtIndex: idx];
        [entry retain];
        NSInteger selectedPort = [entry selectedPort];
        if( selectedPort >= 0 ) {
            [portsPopup selectItemAtIndex: selectedPort];
            [self portSelected: nil];
        } else {
            [portsPopup selectItemAtIndex: 0];
            [portsPopup selectItemWithTitle: @"Other"]; 
            [self activateOther:nil];
        }
    }
	[NSApp beginSheet: edit_rule 
	   modalForWindow: [NSApp mainWindow] 
		modalDelegate: self
	   didEndSelector: @selector(didEndSheet:returnCode:contextInfo:) 
		  contextInfo: nil];
}


- (void)didEndSheet:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo {
    [sheet orderOut:self];
}

- (void)awakeFromNib {
    NSFormatter *formatter = [PortsFormatter portsFormatter];
	[tcpPorts setFormatter:formatter];
	[udpPorts setFormatter: formatter];
    NSArray* ports = [[owner processor] ports];
    NSMenu* menu = [portsPopup menu];
	unsigned int idx = 0;
	unsigned int count = [ports count];
	for (idx = 0 ; idx < count; idx++) {
		PortsEntry* pEntry = [ports objectAtIndex: idx];
		NSString* name = [pEntry name];
        NSMenuItem* item = [[NSMenuItem alloc] initWithTitle: name action:NULL keyEquivalent:@""]; 
		[menu insertItem:item atIndex:idx];
        [item release];
	}
}

@end
