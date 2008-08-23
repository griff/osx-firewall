//
//  ToolHorse.h
//  Firewall
//
//  Created by Brian Olsen on 22/08/08.
//  Copyright 2008 Maven-Group. All rights reserved.
//

#import "Common.h"
#import "FirewallRule.h"

extern OSStatus DoFirewallAddRule(CFStringRef bundleID, AuthorizationRef gAuth, FirewallRule* rule);
extern OSStatus DoFirewallDeleteRule(CFStringRef bundleID, AuthorizationRef gAuth, FirewallRule* rule);
extern OSStatus DoFirewallApplyBlockUdpRules(CFStringRef bundleID, AuthorizationRef gAuth, Boolean enabled);
extern OSStatus DoFirewallApplyStealthRules(CFStringRef bundleID, AuthorizationRef gAuth, Boolean enabled);
extern OSStatus DoFirewallApplyDefaultRules(CFStringRef bundleID, AuthorizationRef gAuth, Boolean enabled);
extern OSStatus DoFirewallLogging(CFStringRef bundleID, AuthorizationRef gAuth, Boolean enabled);
