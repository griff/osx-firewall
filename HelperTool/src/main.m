//
//  main.m
//  Firewall
//
//  Created by Brian Olsen on 22/08/08.
//  Copyright 2008 Maven-Group. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "FirewallRule.h"
#import "Common.h"

void executeRule(id item, bool add) {
    NSString *cmd;
    if( add )
        cmd = @"add";
    else
        cmd = @"delete";
    NSMutableArray* arguments = [NSMutableArray arrayWithCapacity:10];
    [arguments addObject: cmd];
    if ([item isKindOfClass: [FirewallRule class]]) {
        FirewallRule *entry = item;
        [arguments addObjectsFromArray:[entry ruleStrings]];
    } else {
        // assume NSString
        [arguments addObjectsFromArray:[item componentsSeparatedByString:@" "]]; 
    }
    NSLog(@"Executing firewall cmd %@",[arguments componentsJoinedByString: @" "]);
    NSTask* task = [[NSTask alloc] init];
    [task setArguments:arguments];
    [task setLaunchPath:@"/sbin/ipfw"];
    [task launch];
    [task waitUntilExit];
    int status = [task terminationStatus];
 
    if (status == 0)
        NSLog(@"Task succeeded.");
    else
        NSLog(@"Task failed.");
}

OSStatus DoFirewallAddRuleCommand(
    AuthorizationRef            auth,
    const void *                userData,
    CFDictionaryRef             request,
    CFMutableDictionaryRef      response,
    aslclient                   asl,
    aslmsg                      aslMsg
) {
    int                         err;
    FirewallRule* rule = [FirewallRule ruleWithDictionary:(NSDictionary*)request];
    executeRule(rule, true);
    /*
    NSString* portStr = [port description];
    
    name = [portStr cString];
    err = asl_log(asl, aslMsg, ASL_LEVEL_DEBUG, "ports=%s", (const char*)name);
    */
    assert(err == 0);

    return noErr;
}

OSStatus DoFirewallDeleteRuleCommand(
    AuthorizationRef            auth,
    const void *                userData,
    CFDictionaryRef             request,
    CFMutableDictionaryRef      response,
    aslclient                   asl,
    aslmsg                      aslMsg
) {
    FirewallRule* rule = [FirewallRule ruleWithDictionary:(NSDictionary*)request];
    executeRule(rule, true);
    return noErr;
}

OSStatus DoFirewallApplyBlockUdpRulesCommand(
    AuthorizationRef            auth,
    const void *                userData,
    CFDictionaryRef             request,
    CFMutableDictionaryRef      response,
    aslclient                   asl,
    aslmsg                      aslMsg
) {
    NSDictionary* dict = (NSDictionary*)request;
    BOOL enabled = [[dict objectForKey:  kFirewallEnabledKey] boolValue];
	executeRule(@"3000 allow udp from any to any dst-port 53 in", enabled);
	executeRule(@"3001 allow udp from any to any dst-port 68 in", enabled);
	executeRule(@"3002 allow udp from any 67 to me in", enabled);
	executeRule(@"3003 allow udp from any 5353 to me in", enabled);
	executeRule(@"4000 allow udp from me to any out keep-state", enabled);
	executeRule(@"4001 allow udp from any to any in frag", enabled);
	executeRule(@"4002 deny udp from any to any in", enabled);

    return noErr;
}

OSStatus DoFirewallApplyStealthRulesCommand(
    AuthorizationRef            auth,
    const void *                userData,
    CFDictionaryRef             request,
    CFMutableDictionaryRef      response,
    aslclient                   asl,
    aslmsg                      aslMsg
) {
    NSDictionary* dict = (NSDictionary*)request;
    BOOL enabled = [[dict objectForKey:  kFirewallEnabledKey] boolValue];
    executeRule(@"33300 deny icmp from any to me in icmptypes 8", enabled);
    return noErr;
}

OSStatus DoFirewallApplyDefaultRulesCommand(
    AuthorizationRef            auth,
    const void *                userData,
    CFDictionaryRef             request,
    CFMutableDictionaryRef      response,
    aslclient                   asl,
    aslmsg                      aslMsg
) {
    NSDictionary* dict = (NSDictionary*)request;
    BOOL enabled = [[dict objectForKey:  kFirewallEnabledKey] boolValue];
    executeRule(@"100 allow ip from any to any via lo*", enabled);
	executeRule(@"101 deny ip from 127.0.0.0/8 to any in", enabled);
	executeRule(@"102 deny ip from any to 127.0.0.0/8 in", enabled);
	executeRule(@"103 deny ip from 224.0.0.0/3 to any in", enabled);
	executeRule(@"104 deny tcp from any to 224.0.0.0/3 in", enabled);
	executeRule(@"105 allow tcp from any to any out", enabled);
	executeRule(@"106 allow tcp from any to any established", enabled);
    executeRule(@"107 allow tcp from any to any frag", enabled);
	executeRule(@"4000 deny tcp from any to any", enabled);

    return noErr;
}

OSStatus DoFirewallLoggingCommand(
    AuthorizationRef            auth,
    const void *                userData,
    CFDictionaryRef             request,
    CFMutableDictionaryRef      response,
    aslclient                   asl,
    aslmsg                      aslMsg
) {
    NSDictionary* dict = (NSDictionary*)request;
    BOOL enabled = [[dict objectForKey:  kFirewallEnabledKey] boolValue];
    // TODO: Implement logging
    return noErr;
}

static const BASCommandProc kFirewallCommandProcs[] = {
    DoFirewallAddRuleCommand,
    DoFirewallDeleteRuleCommand,
    DoFirewallApplyBlockUdpRulesCommand,
    DoFirewallApplyStealthRulesCommand,
    DoFirewallApplyDefaultRulesCommand,
    DoFirewallLoggingCommand,
    NULL
};

int main(int argc, char **argv)
{
    return BASHelperToolMain(kFirewallCommandSet, kFirewallCommandProcs);
}
