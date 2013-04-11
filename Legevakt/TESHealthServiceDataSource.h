//
//  TESHealthServiceDataSource.h
//  Legevakt
//
//  Created by Benedicte Raae on 11.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface TESHealthServiceDataSource : NSObject <UITableViewDataSource>

@property (strong, nonatomic) NSArray *healthServices;
@property (strong, nonatomic) CLLocation *myLocation;

+ (TESHealthServiceDataSource *) healthServiceDataSourceWithHealthservices:(NSArray *) healthServices andLocation:(CLLocation *) myLocation;


@end
