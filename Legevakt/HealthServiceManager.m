//
//  HealthServiceManager.m
//  Legevakt
//
//  Created by Tom Erik Støwer on 3/27/13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "HealthServiceManager.h"
#import "HealthService.h"

@interface HealthServiceManager()

@property (strong,nonatomic) NSMutableArray *unifiedSearchResults;
@property id<HealthServiceManagerDelegate> unifiedSearchResultsDelegate;

@end

@implementation HealthServiceManager

- (void)searchWithString:(NSString *)searchString delegate:(id<HealthServiceManagerDelegate>)delegate
{
    if (searchString.length > 0) {
        self.unifiedSearchResults = nil;
        self.unifiedSearchResultsDelegate = delegate;
        [Municipality findMunicipalitiesWithSearchString:searchString delegate:self];
        [self findHealthServicesWithDisplayNameMatching:searchString];
    }
    

}

- (void)foundMunicipalities:(NSArray *)municipalities
{
    NSLog(@"found municipalities: %d", municipalities.count);
    [self findHealthServicesForMunicipalities:municipalities withDelegate:self];
}

- (void)findHealthServicesForMunicipalities:(NSArray *)municipalities withDelegate:(id<HealthServiceManagerDelegate>)delegate
{
    for (Municipality *municipality in municipalities) {
        PFQuery *query = [[PFQuery alloc] initWithClassName:@"HealthService"];
        NSString *code = [municipality objectForKey:@"Kommunenummer"];
        [query whereKey:@"AppliesToMunicipalityCodes" containsString:code];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            [self unifySearchResultsWithObjects:objects];
        }];
    }
}

- (void)findHealthServicesWithDisplayNameMatching:(NSString *)searchString
{
    PFQuery *query = [[PFQuery alloc] initWithClassName:@"HealthService"];
    [query whereKey:@"HealthServiceDisplayName" containsString:searchString];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self unifySearchResultsWithObjects:objects];
        }
    }];
}

- (void)unifySearchResultsWithObjects:(NSArray *)objects
{
    // do some sorting and prioritizing?
    NSLog(@"Updating unified search results with %d objects to total objects: %d", objects.count, self.unifiedSearchResults.count);
    if (!self.unifiedSearchResults)
        self.unifiedSearchResults = [[NSMutableArray alloc] init];
    [self.unifiedSearchResults addObjectsFromArray:objects];
    [self.unifiedSearchResultsDelegate manager:self foundHealthServicesFromSearch:self.unifiedSearchResults];
}

+ (void)findHealthServicesNearLocation:(CLLocation *)location withDelegate:(id<HealthServiceManagerDelegate>)delegate
{
    PFQuery *query = [[PFQuery alloc] initWithClassName:@"HealthService"];
    [query whereKey:@"geoPoint" nearGeoPoint:[PFGeoPoint geoPointWithLocation:location]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [delegate manager:self foundHealthServicesNearby:objects];
        }
        else
            NSLog(@"Unable to find places in findHealthServicesNearLocation: %@", error);
    }];
}


@end
