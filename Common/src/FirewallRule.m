//
//  FirewallRule.m
//  Firewall
//
//  Created by Brian Olsen on 22/08/08.
//  Copyright 2008 Maven-Group. All rights reserved.
//

#import "FirewallRule.h"


@implementation FirewallRule
@synthesize ports;
@synthesize udp;
@synthesize priority;

+ (id)ruleWithPort:(Port*)aPort andUdp:(BOOL)aUdp andPriority:(NSInteger)aPriority {
    id port = [[FirewallRule alloc] initWithPort:aPort andUdp:aUdp andPriority:aPriority];
    [port autorelease];
    return port;
}

- (id)initWithPort:(Port*)aPort andUdp:(BOOL)aUdp andPriority:(NSInteger)aPriority  {
    ports = aPort;
    [ports retain];
    udp = aUdp;
    priority = aPriority;
	return [super init];
}

- (id)initWithDictionary:(NSDictionary*)dict {
	id val = [self init];
    udp = [[dict objectForKey: @"udp"] boolValue];
	priority = [[dict objectForKey: @"priority"] integerValue];
    
    NSDictionary* rule = [dict objectForKey: @"ports"];
    ports = [Port portWithDictionary:rule];
    [ports retain];

	return val;
}

- (void)dealloc {
    if(ports != nil)
        [ports release];
    [super dealloc];
}


- (NSDictionary*)dictionaryValue {
	NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity: 3];
	[dict setObject: [NSNumber numberWithBool:udp] forKey: @"udp"];
	[dict setObject: [NSNumber numberWithInteger:priority] forKey: @"priority"];
    [dict setObject:[ports dictionaryValue] forKey: @"ports"];

	return [NSDictionary dictionaryWithDictionary: dict];
}

@end
