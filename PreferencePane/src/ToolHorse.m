//
//  ToolHorse.m
//  Firewall
//
//  Created by Brian Olsen on 22/08/08.
//  Copyright 2008 Maven-Group. All rights reserved.
//

#import "ToolHorse.h"
//#import <CoreFoundation/CoreFoundation.h>

OSStatus DoFirewallAddRule(CFStringRef bundleID, AuthorizationRef gAuth, FirewallRule* rule)
{
    OSStatus        err;
    CFStringRef     command;
    NSMutableDictionary*   request;
    CFDictionaryRef response;
    BASFailCode     failCode;

    assert(bundleID != NULL);
    
    command = CFSTR(kFirewallAddRuleCommand);
    assert(command != NULL);

    request = [NSMutableDictionary dictionaryWithCapacity:6];
    assert(request != NULL);
    [request addEntriesFromDictionary:[rule dictionaryValue]];
    [request setObject:(NSString*)command forKey:(NSString*)CFSTR(kBASCommandKey)];

    response = NULL;
    
    // Execute it.

	err = BASExecuteRequestInHelperTool(
        gAuth, 
        kFirewallCommandSet, 
        bundleID, 
        (CFDictionaryRef)request, 
        &response
    );
    
    // If it failed, try to recover.
    if ( (err != noErr) && (err != userCanceledErr) ) {
        int alertResult;
        
        failCode = BASDiagnoseFailure(gAuth, bundleID);
        
        // At this point we tell the user that something has gone wrong and that we need 
        // to authorize in order to fix it.  Ideally we'd use failCode to describe the type of 
        // error to the user.
            
        alertResult = NSRunAlertPanel(@"Needs Install", @"BAS needs to install", @"Install", @"Cancel", NULL);
        
        if ( alertResult == NSAlertDefaultReturn ) {
            // Try to fix things.
            
            err = BASFixFailure(gAuth, (CFStringRef) bundleID, CFSTR("InstallTool"), CFSTR("HelperTool"), failCode);

            // If the fix went OK, retry the request.
            
            if (err == noErr) {
                err = BASExecuteRequestInHelperTool(
                    gAuth, 
                    kFirewallCommandSet, 
                    bundleID, 
                    (CFDictionaryRef)request, 
                    &response
                );
            }
        } else {
            err = userCanceledErr;
        }
    }

    // If all of the above went OK, it means that the IPC to the helper tool worked.  We 
    // now have to check the response dictionary to see if the command's execution within 
    // the helper tool was successful.
    
    if (err == noErr) {
        err = BASGetErrorFromResponse(response);
    }
    
    // Extract the descriptors from the response and copy them out to our caller.
    
    if (response != NULL) {
        CFRelease(response);
    }
    
    return err;
}

OSStatus DoFirewallDeleteRule(CFStringRef bundleID, AuthorizationRef gAuth, FirewallRule* rule)
{
    return noErr;
}

OSStatus DoFirewallApplyBlockUdpRules(CFStringRef bundleID, AuthorizationRef gAuth, Boolean enabled)
{
    return noErr;
}

OSStatus DoFirewallApplyStealthRules(CFStringRef bundleID, AuthorizationRef gAuth, Boolean enabled)
{
    return noErr;
}

OSStatus DoFirewallApplyDefaultRules(CFStringRef bundleID, AuthorizationRef gAuth, Boolean enabled)
{
    return noErr;
}

OSStatus DoFirewallLogging(CFStringRef bundleID, AuthorizationRef gAuth, Boolean enabled)
{
    return noErr;
}
