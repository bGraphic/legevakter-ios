//
//  TESHealthServiceDataSource.h
//  Legevakt
//
//  Created by Benedicte Raae on 11.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface TESHealthServicesDataSource : NSObject <UITableViewDataSource>

@property (strong, nonatomic) NSArray *healthServices;
@property (strong, nonatomic) CLLocation *myLocation;

+ (TESHealthServicesDataSource *) healthServiceDataSourceWithHealthservices:(NSArray *) healthServices andLocation:(CLLocation *) myLocation;


@end
