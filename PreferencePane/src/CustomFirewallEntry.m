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
#import "CustomFirewallEntry.h"

@implementation CustomFirewallEntry
@synthesize selectedPort;

- (id)initWithProcessor:(ServiceListProcessor*)aProcessor {
    id me = [super initWithProcessor:aProcessor];
    enabled = (BOOL)[processor active];
    selectedPort = -1;
    priority = [processor nextPriority];
    return me;
}

- (id)initWithDictionary:(NSDictionary*)dict withProcessor:(ServiceListProcessor*)aProcessor {
	id me = [super initWithDictionary:dict withProcessor:aProcessor];
	enabled = [[dict objectForKey: @"enabled"] boolValue];
    selectedPort = [[dict objectForKey: @"selectedPort"] integerValue];
	return me;
}

- (NSDictionary*)dictionaryValue {
	NSDictionary* portEntry = [super dictionaryValue];
	NSMutableDictionary* dict = [NSMutableDictionary  dictionaryWithCapacity:[portEntry count]+1];
	[dict addEntriesFromDictionary:portEntry];
	[dict setObject: [NSNumber numberWithBool:enabled] forKey: @"enabled"];
	[dict setObject: [NSNumber numberWithInteger:selectedPort] forKey: @"selectedPort"];
	return [NSDictionary dictionaryWithDictionary: dict];
}

- (BOOL)enabled {
	return enabled;
}

- (void)setEnabled:(BOOL)value {
	if( value != enabled )
	{
        if( [processor toggleSingleService: self asEnabled:value] ) {
            enabled = value;
            [processor storePreferences];
        }
	}
}

- (BOOL)custom {
    return YES;
}

- (void)setName:(NSString*)aName {
    if(name != nil) [name release];
    name = [[NSString alloc] initWithString:aName];
    if( idValue != nil ) [idValue release];
    idValue = [[NSString alloc] initWithFormat:@"%@-%d", name, priority];
}

- (void)setTcp:(NSArray*)value {
    if( tcp != nil ) [tcp release];
    tcp = [[NSArray alloc] initWithArray:value];
}

- (void)setUdp:(NSArray*)value {
    if( udp != nil ) [udp release];
    udp = [[NSArray alloc] initWithArray:value];
}


@end
