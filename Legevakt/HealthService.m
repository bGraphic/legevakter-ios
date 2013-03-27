//
//  HealthService.m
//  Legevakt
//
//  Created by Tom Erik Støwer on 3/27/13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "HealthService.h"

@implementation HealthService

- (NSString *)displayName
{
    return [self objectForKey:@"HealthServiceDisplayName"];
}

- (NSString *)phoneNumber
{
    return [self objectForKey:@"HealthServicePhone"];
}
- (NSString *)address
{
    NSString *address = [NSString stringWithFormat:@"%@, %@ %@",
                         [self objectForKey:@"VisitAddressStreet"],
                         [self objectForKey:@"VisitAddressPostNr"],
                         [self objectForKey:@"VisitAddressPostName"]];
    return address;
}

#pragma mark -
#pragma mark Class Methods
+ (NSString *)parseClassName
{
    return @"HealthService";
}

@end
