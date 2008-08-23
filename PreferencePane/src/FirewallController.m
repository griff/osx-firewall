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
#import "FirewallController.h"
#import "RuleController.h"
#include "Common.h"


@implementation FirewallController

void MakeRights(
    SFAuthorizationView* authorizationView,
	int rightCount,
	const BASCommandSpec		commands[]
);

- (void)authorizationViewCreatedAuthorization:(SFAuthorizationView *)view {
	SFAuthorization * auth = [view authorization];
	[[owner processor] setAuthorization: [auth authorizationRef]];
}

- (void)authorizationViewDidAuthorize:(SFAuthorizationView *)view {
//	SFAuthorization * auth = [view authorization];
//	AuthorizationRef authRef = [auth authorizationRef];
//	[[owner processor] setAuthorization: authRef];
	//[[owner processor] executeList];
    [statusButton setEnabled: YES];
    [newRuleButton setEnabled: YES];
    [advancedButton setEnabled: YES];
    [list setEnabled: YES];
    [owner setAuthorized: YES];
}

- (void)authorizationViewDidDeauthorize:(SFAuthorizationView *)view {
    [owner setAuthorized: NO];
    [statusButton setEnabled: NO];
    [newRuleButton setEnabled: NO];
    [advancedButton setEnabled: NO];
    [list deselectAll: self];
    [list setEnabled: NO];
}

- (IBAction)toggleStatus:(id)sender {
	BOOL active = [owner active];
    
    [owner setActive: !active];
    [self updateStatus];
}

- (void)updateStatus {
	BOOL active = [owner active];
	if( active ) {
		NSString *startText = @"Click stop to allow incoming network communications to all services and ports.";
		[statusButton setTitle: @"Stop"];
		[status setTitleWithMnemonic: @"Firewall On"];
		[statusText setTitleWithMnemonic: startText];
	}
	else {
		NSString *stopText = @"Click start to prevent incoming network communication to all services and "
				@"ports other than those enabled below.";
		[statusButton setTitle: @"Start"];
		[status setTitleWithMnemonic: @"Firewall Off"];
		[statusText setTitleWithMnemonic: stopText];
	}
	[list setNeedsDisplay: true];
	[list displayIfNeeded];
}


- (IBAction)deleteRule:(id)sender {
    [[owner processor] removeObjectFromServicesAtIndex: [list selectedRow]];
}

- (IBAction)editRule:(id)sender {
	[ruleController showSheet: [list selectedRow]];
}

- (IBAction)newRule:(id)sender {
	[ruleController showSheet: -1];
}

- (IBAction)cancelAdvanced:(id)sender {
    [NSApp endSheet: advancedSheet];
}

- (IBAction)showLog:(id)sender {
    // TODO: implement
}

- (IBAction)okAdvanced:(id)sender {
	[[owner processor] setUdpBlock: NSOnState == [blockUdp state]];
	[[owner processor] setStealthEnabled: NSOnState == [enableStealth state]];
	[[owner processor] setLoggingEnabled: NSOnState == [enableLogging state]];

	[NSApp endSheet: advancedSheet];
}


- (void)awakeFromNib {
    OSStatus    junk;
    AuthorizationRef gAuth;
    
    // Create the AuthorizationRef that we'll use through this application.  We ignore 
    // any error from this.  A failure from AuthorizationCreate is very unusual, and if it 
    // happens there's no way to recover; Authorization Services just won't work.

    junk = AuthorizationCreate(NULL, NULL, kAuthorizationFlagDefaults, &gAuth);
    assert(junk == noErr);
    assert( (junk == noErr) == (gAuth != NULL) );

	// For each of our commands, check to see if a right specification exists and, if not,
    // create it.
    //
    // The last parameter is the name of a ".strings" file that contains the localised prompts 
    // for any custom rights that we use.
    
	BASSetDefaultRules(
		gAuth, 
		kFirewallCommandSet, 
        (CFStringRef)[[owner bundle] bundleIdentifier],
		CFSTR("FirewallAuthorizationPrompts")
	);
    junk = AuthorizationFree( gAuth, kAuthorizationFlagDefaults );
    assert(junk == noErr);

    int commandIndex = 0;
    int rightCount = 0;
    while (kFirewallCommandSet[commandIndex].commandName != NULL) {
        if(kFirewallCommandSet[commandIndex].rightName != NULL )
            rightCount++;
        commandIndex++;
    }
    
    /*
    AuthorizationItem myItems[];
    myItems[0].name = "dk.deck.firewall.restart";
    myItems[0].valueLength = 0;
    myItems[0].value = NULL;
    myItems[0].flags = 0;

    myItems[1].name = "dk.deck.firewall.service.enable";
    myItems[1].valueLength = 0;
    myItems[1].value = NULL;
    myItems[1].flags = 0;

    myItems[2].name = "dk.deck.firewall.block.udp";
    myItems[2].valueLength = 0;
    myItems[2].value = NULL;
    myItems[2].flags = 0;

    myItems[3].name = "dk.deck.firewall.stealth";
    myItems[3].valueLength = 0;
    myItems[3].value = NULL;
    myItems[3].flags = 0;

    myItems[4].name = "dk.deck.firewall.logging";
    myItems[4].valueLength = 0;
    myItems[4].value = NULL;
    myItems[4].flags = 0;

    myItems[5].name = "dk.deck.firewall.rule.new";
    myItems[5].valueLength = 0;
    myItems[5].value = NULL;
    myItems[5].flags = 0;

    myItems[6].name = "dk.deck.firewall.rule.edit";
    myItems[6].valueLength = 0;
    myItems[6].value = NULL;
    myItems[6].flags = 0;

    myItems[7].name = "dk.deck.firewall.rule.delete";
    myItems[7].valueLength = 0;
    myItems[7].value = NULL;
    myItems[7].flags = 0;
    
    AuthorizationRights myRights;
    myRights.count = sizeof (myItems) / sizeof (myItems[0]);
    myRights.items = myItems;

	[authorizationView setAuthorizationRights: &myRights];
    */
    MakeRights(authorizationView, rightCount, kFirewallCommandSet);
	[self updateStatus];
	[authorizationView setAutoupdate: YES];
	[authorizationView setDelegate: self];
}

- (IBAction)showAdvanced:(id)sender {
	[blockUdp setState: [[owner processor] udpBlock] ? NSOnState : NSOffState];
	[enableLogging setState: [[owner processor] loggingEnabled] ? NSOnState : NSOffState];
	[enableStealth setState: [[owner processor] stealthEnabled] ? NSOnState : NSOffState];
	[NSApp beginSheet: advancedSheet 
	   modalForWindow: [NSApp mainWindow] 
		modalDelegate: self
	   didEndSelector: @selector(didEndSheet:returnCode:contextInfo:) 
		  contextInfo: nil];
}

- (void)didEndSheet:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo {
    [sheet orderOut:self];
}

void MakeRights(
    SFAuthorizationView* authorizationView,
	int rightCount,
	const BASCommandSpec		commands[]
)
{
    AuthorizationItem myItems[rightCount];
    int commandIndex = 0;
    int rightIndex = 0;
    while (commands[commandIndex].commandName != NULL) {
        // Some no-obvious assertions:
        
        // If you have a right name, you must supply a default rule.
        // If you have no right name, you can't supply a default rule.

        assert( (commands[commandIndex].rightName == NULL) == (commands[commandIndex].rightDefaultRule == NULL) );

        // If you have no right name, you can't supply a right description.
        // OTOH, if you have a right name, you may supply a NULL right description 
        // (in which case you get no custom prompt).

        assert( (commands[commandIndex].rightName != NULL) || (commands[commandIndex].rightDescriptionKey == NULL) );
        
        // If there's a right name but no current right specification, set up the 
        // right specification.
        
        if (commands[commandIndex].rightName != NULL) {
            myItems[rightIndex].name = commands[commandIndex].rightName;
            myItems[rightIndex].valueLength = 0;
            myItems[rightIndex].value = NULL;
            myItems[rightIndex].flags = 0;
            rightIndex++;
        }
        commandIndex += 1;
    }
    AuthorizationRights myRights;
    myRights.count = sizeof (myItems) / sizeof (myItems[0]);
    myRights.items = myItems;
	[authorizationView setAuthorizationRights: &myRights];
}

@end
