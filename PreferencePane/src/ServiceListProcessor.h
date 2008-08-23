/*!
 @header ServiceListProcessor.h
 @copyright Anders Borch, Brian Olsen
 @abstract Class responsible for loading and saving services from and to property lists,
 and executing rules on ipfw.
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
#import <Security/Authorization.h>
#import "CustomFirewallEntry.h"

@class FirewallEntry, CustomFirewallEntry;

/*!
 @class ServiceListProcessor
 @abstract Class responsible for loading and saving services from and to property lists,
 and executing rules on ipfw.
 */
@interface ServiceListProcessor : NSObject {
	NSArray *defaultRules, *blockUdpRules, *ports;
	NSMutableArray *builtinServices, *extraServices;
	BOOL udpBlock, active;
	NSMutableDictionary* enabledServices;
	BOOL loggingEnabled;
	BOOL stealthEnabled;
	AuthorizationRef authorization;
    NSBundle* bundle;
}
@property(readonly) NSArray *defaultRules;
@property(readonly) NSArray *blockUdpRules;
@property(readonly) NSArray *builtinServices;
@property(readonly) NSArray *ports;
@property(readwrite) AuthorizationRef authorization;
@property(readonly) NSBundle* bundle;

- (id)initWithBundle:(NSBundle*)bundle;

/*!
 @function initWithFile:
 @abstract Initialize, configuring using file at path.
 @param path Path name of property list to configure from.
 @discussion
 The property list file should contain a dictionary with "defaultRules", "services",
 "ports", "blockUdpRules". "defaultRules" and "blockUdpRules" should conain a list of 
 strings which should be rules applied by default, and in case of blocking udp traffic,
 respectively.
*/
- (id)initWithFile:(NSString*)path;

- (void)dealloc;

- (void)loadPreferences;
- (void)storePreferences;

- (void)setStealthEnabled:(BOOL)enabled;
- (BOOL)stealthEnabled;

- (void)setLoggingEnabled:(BOOL)enabled;
- (BOOL)loggingEnabled;

/*!
 @function setUdpBlock:
 @param enabled true if udp rules should be activated or false if they should be deactivated
 @abstract execute rules, setting them as either active or inactive
 */
- (void)setUdpBlock:(BOOL)enabled;

/*!
 @function udpBlock:
 @result true if udptraffic is blocked
 */
-(BOOL)udpBlock;

/*!
 @function setActive:
 @param enabled true if rules should be activated or false if they should be deactivated
 @abstract execute rules, setting them as either active or inactive
 */
- (void)setActive:(BOOL)enabled;

/*!
 @function active:
 @result true if firewall is enabled
 */
-(BOOL)active;

/*!
 @function toggleSingleService:asEnabled:
 @param objectIndex The index of the service to set as either active or inactive
 @param isEnabled True if active, or false if inactive
 @result true if the toogle succeded.
 */
- (BOOL)toggleSingleService:(FirewallEntry*)entry asEnabled:(bool)isEnabled;

/*!
 @function serviceEnabled:
 @param entry The entry of the service to return the enabled boolean for.
 */
- (BOOL)serviceEnabled:(FirewallEntry*)entry;

- (void)setServiceEnabled:(FirewallEntry*)entry withValue:(BOOL)value;

- (void)updateSingleService:(CustomFirewallEntry*)entry 
                        tcp:(NSArray*)tcpPorts
                        udp:(NSArray*)udpPorts
                description:(NSString*)description
                selectedPort:(NSInteger)selectedPort;

- (NSInteger)nextPriority;

/*!
 @function countOfServices:
 @result number of services currently in services list.
 */
- (unsigned int)countOfServices;

/*!
 @function objectInServicesAtIndex:
 @param objectIndex The index of the service to retrieve.
 @result FirewallEntry for the given index.
 */
- (FirewallEntry *)objectInServicesAtIndex:(unsigned int)objectIndex;

/*!
 @function insertObject:inServicesAtIndex:
 @param entry The firewall entry to insert into the services list.
 @param index The index of the service to retrieve.
 */
- (void)insertObject:(CustomFirewallEntry *)entry inServicesAtIndex:(unsigned int)index;

/*!
 @function addObjectToServices:
 @param entry The firewall entry add to the services list.
 */
- (void)addObjectToServices:(CustomFirewallEntry *)entry;

/*!
 @function removeObjectFromServicesAtIndex:
 @param index The index of the service to remove.
 */
- (void)removeObjectFromServicesAtIndex:(unsigned int)index;

@end
