//
//  HealthServiceManager.m
//  Legevakt
//
//  Created by Tom Erik Støwer on 3/27/13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "HealthServiceManager.h"
#import "HealthService.h"

@implementation HealthServiceManager

+ (void)findHealthServicesNearLocation:(CLLocation *)location withDelegate:(id<HealthServiceManagerDelegate>)delegate
{
    PFQuery *query = [HealthService query];
    [query whereKey:@"geoPoint" nearGeoPoint:[PFGeoPoint geoPointWithLocation:location] withinKilometers:25.0];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [delegate manager:self foundHealthServicesNearby:objects];
        }
        else
            NSLog(@"Unable to find places in findHealthServicesNearLocation: %@", error);
    }];
}

@end
