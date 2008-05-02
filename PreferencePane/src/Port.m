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
#import "Port.h"


@implementation Port

- (NSUInteger) min {
	if( min == nil )
		return [port unsignedIntegerValue];
	return [min unsignedIntegerValue];
}

- (NSUInteger) max {
	if( max == nil )
		return [port unsignedIntegerValue];
	return [max unsignedIntegerValue];
}

- (NSUInteger) port {
	if( port == nil )
		return [min unsignedIntegerValue];
	return [port unsignedIntegerValue];
}

- (BOOL)isRange {
	return port == nil;
}

+ (id)portWithPort:(NSUInteger)aPort {
    id port = [[Port alloc] initWithPort:aPort];
    [port autorelease];
    return port;
}

+ (id)portWithMin:(NSUInteger)aMin withMax:(NSUInteger)aMax {
    id port = [[Port alloc] initWithMin:aMin withMax:aMax];
    [port autorelease];
    return port;
}

+ (id)portWithDictionary:(NSDictionary*)dict {
    id port = [[Port alloc] initWithDictionary:dict];
    [port autorelease];
    return port;
}

- (id)initWithPort:(NSUInteger)aPort {
	id me = [super init];
	port = [[NSNumber alloc] initWithUnsignedInteger: aPort];
    min = nil;
    max = nil;
	return me;
}

- (id)initWithMin:(NSUInteger)aMin withMax:(NSUInteger) aMax {
	id me = [super init];
    port = nil;
	min = [[NSNumber alloc] initWithUnsignedInteger: aMin];
	max = [[NSNumber alloc] initWithUnsignedInteger: aMax];
	return me;
}

- (id)initWithDictionary:(NSDictionary*)dict {
	id me = [super init];
    port = [dict objectForKey: @"port"];
    if( port == nil ) {
        min = [dict objectForKey: @"startPort"];
        [min retain];
        max = [dict objectForKey: @"endPort"];
        [max retain];
    } else {
        [port retain];
        min = nil;
        max = nil;
    }
    return me;
}

- (void)dealloc {
    if( port != nil )
        [port release];
    if( min != nil )
        [min release];
    if(max != nil )
        [max release];
    [super dealloc];
}

- (NSDictionary*)dictionaryValue {
    if( [self isRange] ) {
        return [NSDictionary dictionaryWithObjectsAndKeys:min, @"startPort", max, @"endPort", nil];
    } else {
        return [NSDictionary dictionaryWithObject:port forKey: @"port"];
    }
}

- (NSString*)description {
	if( [self isRange] )
		return [NSString stringWithFormat:@"%lu-%lu", self.min, self.max];
	return [port stringValue];
}

- (BOOL)isEqual:(id)other {
	if (![other isKindOfClass: [Port class]]) return NO;
    if( port == nil ) 
        return [self max] == [other max] && [self min] == [other min];
    else
        return [self port] == [other port];
}

- (NSUInteger)hash {
    if( port == nil ) 
        return ([self max] <<16) + [self min];
    else
        return [self port];
}

@end
