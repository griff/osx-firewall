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

+ (id)ruleWithPorts:(NSArray*)aPorts andUdp:(BOOL)aUdp andPriority:(NSInteger)aPriority {
    id port = [[FirewallRule alloc] initWithPorts:aPorts andUdp:aUdp andPriority:aPriority];
    [port autorelease];
    return port;
}

+ (id)ruleWithDictionary:(NSDictionary*)dict {
    id port = [[FirewallRule alloc] initWithDictionary:dict];
    [port autorelease];
    return port;
}

- (id)initWithPorts:(NSArray*)aPorts andUdp:(BOOL)aBool andPriority:(NSInteger)aPriority  {
    ports = [[NSArray alloc] initWithArray:aPorts];
    udp = aBool;
    priority = aPriority;
	return [super init];
}

- (id)initWithDictionary:(NSDictionary*)dict {
	id val = [self init];
    udp = [[dict objectForKey: @"udp"] boolValue];
	priority = [[dict objectForKey: @"priority"] integerValue];
    
	NSArray *rules = [dict objectForKey: @"ports"];
	NSMutableArray* portsM = [NSMutableArray arrayWithCapacity: [rules count]]; 
	for (NSDictionary* rule in rules) {
		[portsM addObject: [Port portWithDictionary:rule]];
	}
	ports = [[NSArray alloc] initWithArray: portsM];

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

	if( ports == nil || [ports count] == 0 ) {
		[dict setObject: [NSArray array] forKey: @"ports"];
	} else {
		NSMutableArray* portsM = [NSMutableArray arrayWithCapacity: [ports count]];
		for( Port* port in ports ) {
			[portsM addObject: [port dictionaryValue]];
		}
		[dict setObject: portsM forKey: @"ports"];
	}

	return [NSDictionary dictionaryWithDictionary: dict];
}

- (NSArray*)ruleStrings {
	if( ports == nil ) return nil;
	NSUInteger count = [ports count];
	if( count == 0 ) return nil;
	NSMutableArray *portsM = [NSMutableArray arrayWithCapacity: count];
	for (Port *rule in ports) {
		[portsM addObject: [rule description]];
	}
	NSString *portsStr = [portsM componentsJoinedByString: @","];
	portsStr = [NSString stringWithFormat: @"%d allow %@ from any to any dst-port %@ in", priority, (udp ? @"udp" : @"tcp"), portsStr];
    return [portsStr componentsSeparatedByString:@" "];
}

@end
