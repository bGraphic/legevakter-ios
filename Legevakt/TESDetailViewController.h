//
//  TESDetailViewController.h
//  Legevakt
//
//  Created by Benedicte Raae on 08.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "HealthService.h"

@interface TESDetailViewController : UITableViewController <UITableViewDelegate>

@property (strong, nonatomic) HealthService *healthService;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *webPageLabel;

@property (weak, nonatomic) IBOutlet UITextView *openingHoursTextView;
@property (weak, nonatomic) IBOutlet UITextView *openingHoursCommentTextView;

@property (weak, nonatomic) IBOutlet UITableViewCell *mapViewCell;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
