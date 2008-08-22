/*
 *  Common.h
 *  Firewall
 *
 *  Created by Brian Olsen on 08/06/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */
#ifndef __COMMON_H__
#define __COMMON_H__

#include "BetterAuthorizationSampleLib.h"

#define kFirewallEnabledKey @"enabled"

#define kFirewallAddRuleCommand "AddRule"
    // inputs:
    //     kBASCommandKey (CFString)
    //     FirewallRule serialized
    // outputs:
    //     kBASErrorKey (CFNumber)
    // authorization right
    #define kFirewallAddRuleCommandRightName "dk.deck.firewall.AddRule"

#define kFirewallDeleteRuleCommand "DeleteRule"
    // inputs:
    //     kBASCommandKey (CFString)
    //     FirewallRule serialized
    // outputs:
    //     kBASErrorKey (CFNumber)
    // authorization right
    #define kFirewallDeleteRuleCommandRightName "dk.deck.firewall.DeleteRule"

#define kFirewallApplyBlockUdpRulesCommand "ApplyBlockUdpRules"
    // inputs:
    //     kBASCommandKey (CFString)
    //     kFirewallEnabledKey (CFBoolean)
    // outputs:
    //     kBASErrorKey (CFNumber)
    // authorization right
    #define kFirewallApplyBlockUdpRulesCommandRightName "dk.deck.firewall.ApplyBlockUdpRules"
           
#define kFirewallApplyStealthRulesCommand "ApplyStealthRules"
    // inputs:
    //     kBASCommandKey (CFString)
    //     kFirewallEnabledKey (CFBoolean)
    // outputs:
    //     kBASErrorKey (CFNumber)
    // authorization right
    #define kFirewallApplyStealthRulesCommandRightName "dk.deck.firewall.ApplyStealthRules"
           
#define kFirewallApplyDefaultRulesCommand "ApplyDefaultRules"
    // inputs:
    //     kBASCommandKey (CFString)
    //     kFirewallEnabledKey (CFBoolean)
    // outputs:
    //     kBASErrorKey (CFNumber)
    // authorization right
    #define kFirewallApplyDefaultRulesCommandRightName "dk.deck.firewall.ApplyDefaultRules"

#define kFirewallLoggingCommand "Logging"
    // inputs:
    //     kBASCommandKey (CFString)
    //     kFirewallEnabledKey (CFBoolean)
    // outputs:
    //     kBASErrorKey (CFNumber)
    // authorization right
    #define kFirewallLoggingCommandRightName "dk.deck.firewall.Logging"

extern const BASCommandSpec kFirewallCommandSet[];

#endif

