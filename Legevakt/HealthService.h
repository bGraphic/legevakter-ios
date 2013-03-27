//
//  HealthService.h
//  Legevakt
//
//  Created by Tom Erik Støwer on 3/27/13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthService : PFObject<PFSubclassing>

- (NSString *)displayName;
- (NSString *)phoneNumber;
- (NSString *)address;

- (NSString *)formattedDistanceFromLocation:(CLLocation *)location;

#pragma mark Class Methods
+ (NSString *)parseClassName;

@end
