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
#import "PortsEntry.h"
#import "FirewallRule.h"

@implementation PortsEntry
@synthesize idValue;
@synthesize name;
@synthesize tcp;
@synthesize udp;
@synthesize priority;

- (id)init {
    idValue = nil;
    name = nil;
    priority = 0;
	return [super init];
}

- (id)initWithDictionary:(NSDictionary*)dict {
	id val = [self init];
	idValue = [dict objectForKey: @"id"];
    [idValue retain];
	name = [dict objectForKey: @"name"];
    [name retain];
	priority = [[dict objectForKey: @"priority"] integerValue];
	NSArray *tcpRules = [dict objectForKey: @"tcpRules"];
	NSArray *udpRules = [dict objectForKey: @"udpRules"];
	
	NSMutableArray* tcpM = [NSMutableArray arrayWithCapacity: [tcpRules count]]; 
	NSMutableArray* udpM = [NSMutableArray arrayWithCapacity: [udpRules count]]; 
	for (NSDictionary* rule in tcpRules) {
		[tcpM addObject: [Port portWithDictionary:rule]];
	}

	for (NSDictionary* rule in udpRules) {
		[udpM addObject: [Port portWithDictionary:rule]];
	}
	tcp = [[NSArray alloc] initWithArray: tcpM];
	udp = [[NSArray alloc] initWithArray: udpM];

	return val;
}

- (void)dealloc {
    [idValue release];
    [name release];
    [tcp release];
    [udp release];
    [super dealloc];
}


- (NSDictionary*)dictionaryValue {
	NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity: 5];
	[dict setObject: idValue forKey: @"id"];
	[dict setObject: name forKey: @"name"];
	[dict setObject: [NSNumber numberWithInteger:priority] forKey: @"priority"];
	if( tcp == nil || [tcp count] == 0 ) {
		[dict setObject: [NSArray array] forKey: @"tcpRules"];
	} else {
		NSMutableArray* tcpM = [NSMutableArray arrayWithCapacity: [tcp count]];
		for( Port* port in tcp ) {
			[tcpM addObject: [port dictionaryValue]];
		}
		[dict setObject: tcpM forKey: @"tcpRules"];
	}
	
	if( udp == nil || [udp count] == 0 ) {
		[dict setObject: [NSArray array] forKey: @"udpRules"];
	} else {
		NSMutableArray* udpM = [NSMutableArray arrayWithCapacity: [udp count]];
		for( Port* port in udp ) {
			[udpM addObject: [port dictionaryValue]];
		}
		[dict setObject: udpM forKey: @"udpRules"];
	}
	
	return dict;
}

- (NSString*)ruleString:(BOOL)isUdp {
	NSArray* ruleset = isUdp ? udp : tcp;
	NSInteger prio = isUdp ? priority+1 : priority;
	
	if( ruleset == nil ) return nil;
	NSUInteger count = [ruleset count];
	if( count == 0 ) return nil;
	NSMutableArray *portsM = [NSMutableArray arrayWithCapacity: count];
	for (Port *rule in ruleset) {
		[portsM addObject: [rule description]];
	}
	NSString *ports = [portsM componentsJoinedByString: @","];
	return [NSString stringWithFormat: @"%d allow %@ from any to any dst-port %@ in", prio, (isUdp ? @"udp" : @"tcp"), ports];	
}

- (NSArray*)rules:(BOOL)isUdp {
	NSArray* ruleset = isUdp ? udp : tcp;
	NSInteger prio = isUdp ? priority+1 : priority;

	if( ruleset == nil ) return [NSArray array];
	NSUInteger count = [ruleset count];
	if( count == 0 ) return [NSArray array];

    return [FirewallRule ruleWithPorts:ruleset andUdp:isUdp andPriority:prio];
}

@end
