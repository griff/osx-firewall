/*
 *  Common.c
 *  Firewall
 *
 *  Created by Brian Olsen on 08/06/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */

#include "Common.h"

const BASCommandSpec kFirewallCommandSet[] = {
    {
        kFirewallAddRuleCommand,          // commandName
        kFirewallAddRuleCommandRightName, // rightName
        "default",                        // rightDefaultRule -- allow anyone
        NULL,                             // rightDescriptionKey -- no custom prompt
        NULL                              // userData
    },
    {
        kFirewallDeleteRuleCommand,          // commandName
        kFirewallDeleteRuleCommandRightName, // rightName
        "default",                           // rightDefaultRule -- need admin creds
        NULL,                                // rightDescriptionKey -- no custom prompt
        NULL                                 // userData
    },
    {
        kFirewallApplyBlockUdpRulesCommand,          // commandName
        kFirewallApplyBlockUdpRulesCommandRightName, // rightName
        "default",                                   // rightDefaultRule -- need admin creds
        NULL,                                        // rightDescriptionKey -- no custom prompt
        NULL                                         // userData
    },
    {
        kFirewallApplyStealthRulesCommand,          // commandName
        kFirewallApplyStealthRulesCommandRightName, // rightName
        "default",                                  // rightDefaultRule -- need admin creds
        NULL,                                       // rightDescriptionKey -- no custom prompt
        NULL                                        // userData
    },
    {
        kFirewallApplyDefaultRulesCommand,          // commandName
        kFirewallApplyDefaultRulesCommandRightName, // rightName
        "default",                                  // rightDefaultRule -- need admin creds
        NULL,                                       // rightDescriptionKey -- no custom prompt
        NULL                                        // userData
    },
    {
        kFirewallLoggingCommand,          // commandName
        kFirewallLoggingCommandRightName, // rightName
        "default",                        // rightDefaultRule -- need admin creds
        NULL,                             // rightDescriptionKey -- no custom prompt
        NULL                              // userData
    },
    {   
        NULL,                     // the array is null terminated
        NULL, 
        NULL, 
        NULL, 
        NULL
    }
};
