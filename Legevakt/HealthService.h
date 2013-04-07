//
//  HealthService.h
//  Legevakt
//
//  Created by Tom Erik Støwer on 3/27/13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Municipality.h"

@interface HealthService : PFObject <PFSubclassing, MunicipalityDelegate>

@property (strong, readonly) NSMutableArray* applicableMunicipalities;

- (NSString *)displayName;
- (NSString *)phoneNumber;
- (NSString *)address;
- (NSString *)formattedApplicableMunicipalities;
- (NSString *)formattedDistanceFromLocation:(CLLocation *)location;
- (NSString *)formattedOpeningHoursAsString;

- (BOOL)isOpen;

- (void)initializeApplicableMunicipalities;

#pragma mark MunicipalityDelegate
- (void)foundMunicipality:(Municipality *)municipality;

#pragma mark Class Methods
+ (NSString *)parseClassName;

@end
