/*!
 @header PortsEntry.h
 @copyright Anders Borch, Brian Olsen
 @abstract Class holding information about a service which is either saved using subclasses FirewallEntry and CustomFirewallEntry or used for populating the ports popup.
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
#import "FirewallRule.h"

@interface PortsEntry : NSObject {
	NSString *idValue;
	NSString *name;
	NSArray *tcp, *udp;
	NSInteger priority;
}
@property(readonly) NSString *idValue;
@property(readonly) NSString *name;
@property(readonly) NSArray *tcp;
@property(readonly) NSArray *udp;
@property(readonly) NSInteger priority;

/*
 @function init:
 @abstract Initialize with empty set of tcp and udp rules.
 */
- (id)init;

/*!
 @function initWithDictionary:
 @abstract Initialize with doctents of dictionary
 @param dict The dictionary used to initialize the service
 @discussion
 The dictionary should contain an array of dictionaries. each with "name", 
 "tcpRules", and "udpRules" of a service. 
 
 "tcpRules" and "udpRules" should contain an 
 array of dictionaries with "port" and "priority". Port numbers being the ports to be
 allowed by the rule, and "priority" the rule number in the IP Firewall.
 */
- (id)initWithDictionary:(NSDictionary*)dict;

- (void)dealloc;

- (NSDictionary*)dictionaryValue;

- (NSString*)ruleString:(BOOL)isUdp;

- (FirewallRule*)rules:(BOOL)isUdp;

@end
