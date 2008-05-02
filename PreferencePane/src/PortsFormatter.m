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
#import "PortsFormatter.h"
#import "Port.h"

@implementation PortsFormatter

+ (id)portsFormatter{
    id ret = [[PortsFormatter alloc] init];
    [ret autorelease];
    return ret;
}

- (NSString *)stringForObjectValue:(id)anObject {
//	id g = [anObject class];
//	NSLog(@"Test '%@' '%@'", anObject, g );
	if( [@"" isEqual: anObject] )
		return @"";
	NSUInteger count = [anObject count];
	NSMutableArray *ports = [NSMutableArray arrayWithCapacity: count];
	for (Port *rule in anObject) {
		[ports addObject: [rule description]];
	}
	return [ports componentsJoinedByString: @","];
}

- (BOOL)getObjectValue:(id *)anObject forString:(NSString *)string errorDescription:(NSString **)error {
	string = [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	if( [string isEqual: @""] )
	{
		*anObject = [NSArray array];
		return YES;
	}
		
	NSArray *components = [string componentsSeparatedByString:@","];
	NSMutableArray *ports = [NSMutableArray arrayWithCapacity: [components count]];
//	NSLog(@"getObjectValue '%@' '%@'", string, components );
	for( NSString *port in components ) {
		NSArray *portrange = [port componentsSeparatedByString:@"-"];
		if([portrange count] == 0) {
//			NSLog(@"Invalid port 0 '%@'", port);
			if( error ) *error = @"Invalid port";
			//*anObject = nil;
			return NO;
		}
		if( [portrange count] > 2 ) {
//			NSLog(@"To many dashes '%@'", port);
			if( error ) *error = @"To many dashes";
			//*anObject = nil;
			return NO;
		}
		NSInteger i0 = [[portrange objectAtIndex: 0] integerValue];
		if( i0 <= 0 ) {
//			NSLog(@"Invalid port 1 '%@'", port);
			if( error ) *error = @"Invalid port";
			//*anObject = nil;
			return NO;
		}
		
		if( [portrange count] == 1 ) {
//			NSLog(@"Making single port %d", i0);
			[ports addObject: [Port portWithPort:i0]];
		} else {
			NSInteger i1 = [[portrange objectAtIndex: 1] integerValue];
			if( i1<= 0 ) {
//				NSLog(@"Invalid port 2 '%@'", port);
				if( error ) *error = @"Invalid port";
				//*anObject = nil;
				return NO;
			}
//			NSLog(@"Making port range %d-%d", i0, i1);
			[ports addObject: [Port portWithMin: i0 withMax:i1]];
		}
	}
	if( [ports count] > 0 )
		*anObject = ports;
	else
		*anObject = [NSArray array];
	return YES;
}

@end
