/*!
 @header FirewallEntry.h
 @copyright Anders Borch, Brian Olsen
 @abstract Class holding information about a single builtin service which the firewall should allow of deny.
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
@class ServiceListProcessor;
#import "PortsEntry.h"

/*!
 @class FirewallEntry
 @abstract Class holding information about a single builtin service which the firewall should allow of deny.
 */
@interface FirewallEntry : PortsEntry {
	ServiceListProcessor* processor;
}

- (id)initWithProcessor:(ServiceListProcessor*)aProcessor;

- (id)initWithDictionary:(NSDictionary*)dict withProcessor:(ServiceListProcessor*)aProcessor;

- (BOOL)enabled;

- (void)setEnabled:(BOOL)aEnabled;

- (BOOL)custom;

/*!
 @function isEqual:
 @abstract Returns a Boolean value that indicates whether the receiver and a given object are equal.
 @param other The object to be compared to the receiver.
 @result YES if the receiver and anObject are equal, otherwise NO.
 @discussion
 This method defines what it means for instances to be equal. For example, a container object might 
 define two containers as equal if their corresponding objects all respond YES to an isEqual: request. 
 See the NSData, NSDictionary, NSArray, and NSString class specifications for examples of the use of 
 this method.
 
 If two objects are equal, they must have the same hash value. This last point is particularly important 
 if you define isEqual: in a subclass and intend to put instances of that subclass into a collection. 
 Make sure you also define hash in your subclass.
 */
- (BOOL)isEqual:(id)other;

@end
