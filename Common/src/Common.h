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

#define kFirewallAddRuleCommand "AddRule"
    // inputs:
    //     kBASCommandKey (CFString)
    #define kFirewallUdpRules "udpRules" // (CFDictionary)
    #define kFirewallTcpRules "tcpRules" // (CFDictionary)
    // outputs:
    //     kBASErrorKey (CFNumber)
    // authorization right
    #define kFirewallAddRuleCommandRightName "dk.deck.firewall.AddRule"

#define kMyFirstCommand "MyFirstCommand"
    // inputs:
    //     kBASCommandKey (CFString)
    // outputs:
    //     kBASErrorKey (CFNumber)
    // authorization right
           #define kMyFirstCommandRightName "com.example.MyFirstCommand"
           
#define kMySecondCommand "MySecondCommand"
    // inputs:
    //     kBASCommandKey (CFString)
    // outputs:
    //     kBASErrorKey (CFNumber)
    //     kMySecondCommandStatusKey (CFString) -- detailed status result
    //     kBASDescriptorArrayKey (CFArray of CFNumber) -- one entry, TCP 
    // authorization right                              -- desc for port 80
           #define kMySecondCommandRightName "com.example.MySecondCommand"

extern const BASCommandSpec kMyCommandSet[];

#endif

