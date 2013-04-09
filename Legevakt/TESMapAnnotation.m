//
//  TESMapAnnotation.m
//  Legevakt
//
//  Created by Benedicte Raae on 09.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "TESMapAnnotation.h"

@implementation TESMapAnnotation

- (void)setHealthService:(id)newHealthService
{
    if (_healthService != newHealthService) {
        _healthService = newHealthService;
    }
}

- (CLLocationCoordinate2D) coordinate
{
    return self.healthService.location.coordinate;
}

- (NSString *) title
{
    return self.healthService.displayName;
}

- (NSString *) subtitle
{
    return [NSString stringWithFormat:@"%@ | Tel: %@", self.healthService.isOpen?@"Åpent":@"Stengt", self.healthService.formattedPhoneNumber];
}

+ (TESMapAnnotation *) mapAnnotationForHealthService:(HealthService *) healthService
{
    TESMapAnnotation *mapAnnotation = [[TESMapAnnotation alloc] init];
    mapAnnotation.healthService = healthService;
    
    return mapAnnotation;
}

@end
