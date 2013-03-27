//
//  HealthService.m
//  Legevakt
//
//  Created by Tom Erik Støwer on 3/27/13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "HealthService.h"
#import <Parse/Parse.h>
#import "OpeningHours.h"

//  Define Parse global Parse keys here
#define HealthServiceDisplayName    @"HealthServiceDisplayName"
#define HealthServicePhoneNumber    @"HealthServicePhone"
#define HealthServiceStreetAddress  @"VisitAddressStreet"
#define HealthServicePostalCode     @"VisitAddressPostNr"
#define HealthServicePostalPlace    @"VisitAddressPostName"
#define HealthServiceGeoPoint       @"geoPoint"

@implementation HealthService

#pragma mark public

- (NSString *)displayName
{
    return [self objectForKey:HealthServiceDisplayName];
}

- (NSString *)phoneNumber
{
    return [self objectForKey:HealthServicePhoneNumber];
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
    NSNumber *distanceAsNumber = [self distanceFromGeoPoint:[self geoPointWithLocation:location]];

    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"0.#"];
    NSString *formattedDistanceString = [NSString stringWithFormat:@"%@ km", [numberFormatter stringFromNumber:distanceAsNumber]];
    
    return formattedDistanceString;
}

- (NSString *)testOpeningHours
{
    OpeningHours *hours = [[OpeningHours alloc] initWithOpeningHoursString:[self objectForKey:@"OpeningHours"]];
    return @"";
}

#pragma mark private

- (NSString *)streetAddress
{
    return [self objectForKey:HealthServiceStreetAddress];
}

- (NSString *)postalCode
{
    return [self objectForKey:HealthServicePostalCode];
}

- (NSString *)postalPlace
{
    return [self objectForKey:HealthServicePostalPlace];
}

- (PFGeoPoint *)geoPoint
{
    return (PFGeoPoint *)[self objectForKey:HealthServiceGeoPoint];
}

- (PFGeoPoint *)geoPointWithLocation:(CLLocation *)location
{
    return [PFGeoPoint geoPointWithLocation:location];
}

- (NSNumber *)distanceFromGeoPoint:(PFGeoPoint *)geoPoint
{
    NSNumber *distance = [NSNumber numberWithDouble:[[self geoPoint] distanceInKilometersTo:geoPoint]];
    
    return distance;
}

#pragma mark -
#pragma mark Class Methods

+ (NSString *)parseClassName
{
    return @"HealthService";
}

@end
