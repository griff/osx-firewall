/*
 *  Common.c
 *  Firewall
 *
 *  Created by Brian Olsen on 08/06/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */

#include "Common.h"

/**
NSLocalizedString(@"AddRulePrompt", @"prompt included in authorization dialog for the AddRule command");
NSLocalizedString(@"DeleteRulePrompt", @"prompt included in authorization dialog for the DeleteRule command");
NSLocalizedString(@"ApplyBlockUdpRulesPrompt", @"prompt included in authorization dialog for the ApplyBlockUdpRules command");
NSLocalizedString(@"ApplyStealthRulesPrompt", @"prompt included in authorization dialog for the ApplyStealthRules command");
NSLocalizedString(@"ApplyDefaultRulesPrompt", @"prompt included in authorization dialog for the ApplyDefaultRules command");
NSLocalizedString(@"LoggingPrompt", @"prompt included in authorization dialog for the Logging command");
 */
const BASCommandSpec kFirewallCommandSet[] = {
    {
        kFirewallAddRuleCommand,                // commandName
        kFirewallAddRuleCommandRightName,       // rightName
        kAuthorizationRuleAuthenticateAsAdmin,  // rightDefaultRule -- allow anyone
        "AddRulePrompt",                        // rightDescriptionKey -- no custom prompt
        NULL                                    // userData
    },
    {
        kFirewallDeleteRuleCommand,             // commandName
        kFirewallDeleteRuleCommandRightName,    // rightName
        kAuthorizationRuleAuthenticateAsAdmin,  // rightDefaultRule -- need admin creds
        "DeleteRulePrompt",                     // rightDescriptionKey -- no custom prompt
        NULL                                    // userData
    },
    {
        kFirewallApplyBlockUdpRulesCommand,          // commandName
        kFirewallApplyBlockUdpRulesCommandRightName, // rightName
        kAuthorizationRuleAuthenticateAsAdmin,       // rightDefaultRule -- need admin creds
        "ApplyBlockUdpRulesPrompt",                  // rightDescriptionKey -- no custom prompt
        NULL                                         // userData
    },
    {
        kFirewallApplyStealthRulesCommand,          // commandName
        kFirewallApplyStealthRulesCommandRightName, // rightName
        kAuthorizationRuleAuthenticateAsAdmin,      // rightDefaultRule -- need admin creds
        "ApplyStealthRulesPrompt",                  // rightDescriptionKey -- no custom prompt
        NULL                                        // userData
    },
    {
        kFirewallApplyDefaultRulesCommand,          // commandName
        kFirewallApplyDefaultRulesCommandRightName, // rightName
        kAuthorizationRuleAuthenticateAsAdmin,      // rightDefaultRule -- need admin creds
        "ApplyDefaultRulesPrompt",                  // rightDescriptionKey -- no custom prompt
        NULL                                        // userData
    },
    {
        kFirewallLoggingCommand,                // commandName
        kFirewallLoggingCommandRightName,       // rightName
        kAuthorizationRuleAuthenticateAsAdmin,  // rightDefaultRule -- need admin creds
        "LoggingPrompt",                        // rightDescriptionKey -- no custom prompt
        NULL                                    // userData
    },
    {   
        NULL,                     // the array is null terminated
        NULL, 
        NULL, 
        NULL, 
        NULL
    }
};
