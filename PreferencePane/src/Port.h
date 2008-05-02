/*!
 @header Port.h
 @copyright Anders Borch, Brian Olsen
 @abstract Class representing a port or port range.
 @discussion
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
#import <Cocoa/Cocoa.h>

/*!
 @class Port
 @abstract Class representing a port or port range.
 */
@interface Port : NSObject {
	NSNumber *port;
	NSNumber *max;
	NSNumber *min;
}

+ (id)portWithPort:(NSUInteger)aPort;
+ (id)portWithMin:(NSUInteger)aMin withMax:(NSUInteger)aMax; 
+ (id)portWithDictionary:(NSDictionary*)dict;

- (id)initWithPort:(NSUInteger)aPort;
- (id)initWithMin:(NSUInteger)aMin withMax:(NSUInteger)aMax; 
- (id)initWithDictionary:(NSDictionary*)dict;

- (void)dealloc;

/*!
 @function port:
 @abstract Returns the single port value of this instance.
 @result Single port value.
 */
- (NSUInteger)port;

/*!
 @function min:
 @abstract Returns the lower port value of this range.
 @result Lower port value of the range.
 */
- (NSUInteger)min;

/*!
 @function max:
 @abstract Returns the upper port value of this range.
 @result Upper port value of the range.
 */
- (NSUInteger)max;

- (BOOL)isRange;

- (NSString*)description;

- (NSDictionary*)dictionaryValue;

- (BOOL)isEqual:(id)other;

- (NSUInteger)hash;

@end
