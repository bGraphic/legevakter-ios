//
//  TESMapAnnotation.h
//  Legevakt
//
//  Created by Benedicte Raae on 09.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "HealthService.h"

@interface TESMapAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic) HealthService *healthService;

+ (TESMapAnnotation *) mapAnnotationForHealthService:(HealthService *) healthService;

@end
