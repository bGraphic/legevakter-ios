//
//  HealthService.m
//  Legevakt
//
//  Created by Tom Erik Støwer on 3/27/13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "HealthService.h"
#import <Parse/PFObject+Subclass.h>
#import "OpeningHours.h"
#import "Municipality.h"
#import "TESNorwegianPhoneNumberFormatter.h"

//  Define Parse global Parse keys here
#define HealthServiceDisplayName                @"HealthServiceDisplayName"
#define HealthServicePhoneNumber                @"HealthServicePhone"
#define HealthServiceWebPage                    @"HealthServiceWeb"
#define HealthServiceStreetAddress              @"VisitAddressStreet"
#define HealthServicePostalCode                 @"VisitAddressPostNr"
#define HealthServicePostalPlace                @"VisitAddressPostName"
#define HealthServiceGeoPoint                   @"geoPoint"
#define HealthServiceOpeningHoursComment        @"OpeningHoursComment"
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
        
        [Municipality findMunicipalitiesWithCodes:tokenized withDelegate:self];
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

- (CLLocation *) location
{
    PFGeoPoint *geoPoint = [self geoPoint];
    
    if(geoPoint)
    {
        return [[CLLocation alloc] initWithLatitude:geoPoint.latitude longitude:geoPoint.longitude];
    }
    
    return nil;
}

- (NSString *)formattedPhoneNumber
{
    NSString *phoneNumber = [self formattedString:[self phoneNumber]];

    TESNorwegianPhoneNumberFormatter *formatter = [[TESNorwegianPhoneNumberFormatter alloc] init];
    
    return [formatter stringForObjectValue:phoneNumber];
}

- (NSString *)formattedWebPage
{
    return [self formattedString:[self webPage]];
}

- (NSString *)formattedAddress
{
    NSString *address = [NSString stringWithFormat:@"%@\n%@ %@",
                         [self formattedString:[self streetAddress]],
                         [self formattedString:[self postalCode]],
                         [self formattedString:[self postalPlace]]
                        ];
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

- (NSString *)formattedOpeningHoursComment
{
    return [self formattedString:[self openingHoursComment]];
}

- (NSString *)formattedOpeningHoursAsString
{
    return [self.openingHours openingHoursAsString];
}

- (BOOL)isOpen
{
    return [self.openingHours isOpenWithDate:[NSDate date]];
}

- (NSString *) formattedString:(id) string
{
    if (string == [NSNull null])
        return @"";
    else
        return string;
}

#pragma mark MunicipalityDelegate

- (void)foundMunicipality:(Municipality *)municipality
{
    if(!self.applicableMunicipalities)
        self.applicableMunicipalities = [[NSMutableArray alloc] init];
    
    [self.applicableMunicipalities addObject:municipality];
}

- (void)foundMunicipalities:(NSArray *)municipalities
{
    if(!self.applicableMunicipalities)
        self.applicableMunicipalities = [[NSMutableArray alloc] init];
    self.applicableMunicipalities = [municipalities mutableCopy];
}

#pragma mark private

- (NSString *)phoneNumber
{
    return [self objectForKey:HealthServicePhoneNumber];
}

- (NSString *)webPage
{
    return [self objectForKey:HealthServiceWebPage];
}

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

- (NSString *)openingHoursComment
{
    if([self objectForKey:HealthServiceOpeningHoursComment] != [NSNull null])
        return [self objectForKey:HealthServiceOpeningHoursComment];
    else
        return nil;
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
