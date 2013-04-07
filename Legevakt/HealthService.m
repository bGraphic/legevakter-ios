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
#import "Municipality.h"

//  Define Parse global Parse keys here
#define HealthServiceDisplayName                @"HealthServiceDisplayName"
#define HealthServicePhoneNumber                @"HealthServicePhone"
#define HealthServiceStreetAddress              @"VisitAddressStreet"
#define HealthServicePostalCode                 @"VisitAddressPostNr"
#define HealthServicePostalPlace                @"VisitAddressPostName"
#define HealthServiceGeoPoint                   @"geoPoint"
#define HealthServiceOpeningHours               @"OpeningHours"
#define HealthServiceApplicableMunicipalities   @"AppliesToMunicipalityCodes"

@interface HealthService ()

@property (strong, nonatomic) OpeningHours* openingHours;
@property (strong, readwrite) NSMutableArray *applicableMunicipalities;

@end

@implementation HealthService

@synthesize openingHours  = _openingHours;
@synthesize applicableMunicipalities = _applicableMunicipalities;

- (void)initializeApplicableMunicipalities
{
    if (!_applicableMunicipalities) {
        NSString *raw = [self objectForKey:HealthServiceApplicableMunicipalities];
        NSArray *tokenized = [raw componentsSeparatedByString:@" "];
        
        for (id obj in tokenized)
            [Municipality findMunicipalityWithCode:(NSString *)obj withDelegate:self];
    }
}

- (NSString *)formattedApplicableMunicipalities
{
    return [Municipality formattedMunicipalities:self.applicableMunicipalities];
}

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

- (NSString *)formattedOpeningHoursAsString
{
    return [self.openingHours openingHoursAsString];
}

- (BOOL)isOpen
{
    return [self.openingHours isOpenWithDate:[NSDate date]];
}

#pragma mark MunicipalityDelegate

- (void)foundMunicipality:(Municipality *)municipality
{
    if(!self.applicableMunicipalities)
        self.applicableMunicipalities = [[NSMutableArray alloc] init];
    
    [self.applicableMunicipalities addObject:municipality];
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

- (OpeningHours *)openingHours
{
    if (!_openingHours)
        _openingHours = [[OpeningHours alloc] initWithOpeningHoursString:[self objectForKey:HealthServiceOpeningHours]];
    return _openingHours;
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
