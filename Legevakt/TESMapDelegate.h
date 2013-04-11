//
//  TESMapDelegate.h
//  Legevakt
//
//  Created by Benedicte Raae on 11.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TESMapDelegate : NSObject <MKMapViewDelegate>

@property (weak, nonatomic) UINavigationController *navigationController;
@property (assign) BOOL showCallOut;

@end
