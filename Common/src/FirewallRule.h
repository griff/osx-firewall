//
//  FirewallRule.h
//  Firewall
//
//  Created by Brian Olsen on 22/08/08.
//  Copyright 2008 Maven-Group. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <Port.h>

@interface FirewallRule : NSObject {
    NSArray* ports;
	NSInteger priority;
    Boolean udp;
}
@property(readonly) NSArray* ports;
@property(readonly) Boolean udp;
@property(readonly) NSInteger priority;

+ (id)ruleWithPorts:(NSArray*)aPorts andUdp:(BOOL)aUdp andPriority:(NSInteger)aPriority;

+ (id)ruleWithDictionary:(NSDictionary*)dict;

/*
 @function initWithPorts:andUdp:andPriority:
 @abstract Initialize with empty set of tcp and udp rules.
 */
- (id)initWithPorts:(NSArray*)aPorts andUdp:(BOOL)aUdp andPriority:(NSInteger)aPriority;

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

- (NSArray*)ruleStrings;

@end
