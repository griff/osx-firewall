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

@implementation FirewallEntry

- (id)initWithProcessor:(ServiceListProcessor*)aProcessor {
	processor = aProcessor;
	return [super init];
}

- (id)initWithDictionary:(NSDictionary*)dict withProcessor:(ServiceListProcessor*)aProcessor {
	processor = aProcessor;
	return [super initWithDictionary:dict];
}


- (BOOL)enabled {
	BOOL ret = [processor serviceEnabled: self];
	return ret;
}

- (void)setEnabled:(BOOL)value {
	return [processor setServiceEnabled: self withValue:value];
}

- (BOOL)custom {
	return NO;
}

- (BOOL)isEqual:(id)other {
	if (![other isKindOfClass: [FirewallEntry class]]) return NO;
	if (![[other name] isEqualToString: name]) return NO;
	if (![[other tcp] isEqualToArray: tcp]) return NO;
	if (![[other udp] isEqualToArray: udp]) return NO;
	return YES;
}

@end
