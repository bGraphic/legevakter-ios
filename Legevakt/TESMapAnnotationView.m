//
//  TESMapAnnotationView.m
//  Legevakt
//
//  Created by Benedicte Raae on 09.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "TESMapAnnotationView.h"
#import "TESMapAnnotation.h"

@implementation TESMapAnnotationView

- (id)initWithAnnotation:(id)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Compensate frame a bit so everything's aligned
        [self setCenterOffset:CGPointMake(-3.5f, 0)];
        [self setCalloutOffset:CGPointMake(-3.5f, 0)];
    }
    
    return self;
}

- (void)setAnnotation:(id)annotation {
    [super setAnnotation:annotation];
    
    HealthService *healthService = [(TESMapAnnotation *) annotation healthService];
    UIImage *image = healthService.isOpen?[UIImage imageNamed:@"ER_open_pin"]:[UIImage imageNamed:@"ER_closed_pin"];
    self.image = image;
}

@end
