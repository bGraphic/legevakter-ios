//
//  HealthService.m
//  Legevakt
//
//  Created by Tom Erik Støwer on 3/27/13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "HealthService.h"

@implementation HealthService

#pragma mark public
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
                         [self streetAddress],
                         [self postalCode],
                         [self postalPlace]];
    return address;
}

- (NSString *)formattedDistanceFromLocation:(CLLocation *)location
{
    PFGeoPoint *locationAsGeoPoint = [PFGeoPoint geoPointWithLocation:location];
    NSNumber *distanceAsNumber = [self distanceFromGeoPoint:locationAsGeoPoint];

    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"0.#"];
    NSString *formattedDistanceString = [NSString stringWithFormat:@"%@ km", [numberFormatter stringFromNumber:distanceAsNumber]];
    
    return formattedDistanceString;
}

#pragma mark private

- (NSString *)streetAddress
{
    return [self objectForKey:@"VisitAddressStreet"];
}

- (NSString *)postalCode
{
    return [self objectForKey:@"VisitAddressPostNr"];
}

- (NSString *)postalPlace
{
    return [self objectForKey:@"VisitAddressPostNr"];
}

- (NSNumber *)distanceFromGeoPoint:(PFGeoPoint *)geoPoint
{
    PFGeoPoint *healthServiceGeoPoint = [self objectForKey:@"geoPoint"];
    NSNumber *distance = [NSNumber numberWithDouble:[healthServiceGeoPoint distanceInKilometersTo:geoPoint]];
    
    return distance;
}

#pragma mark -
#pragma mark Class Methods


+ (NSString *)parseClassName
{
    return @"HealthService";
}

@end
