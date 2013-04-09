//
//  TESDetailViewController.m
//  Legevakt
//
//  Created by Benedicte Raae on 08.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "TESDetailViewController.h"
#import <QuartzCore/CoreAnimation.h>
#import "TESMapAnnotation.h"
#import "TESMapViewController.h"
#import "BGCommonGraphics.h"
#import "TESLegevaktActionManager.h"
#import "TESMapAnnotationView.h"

@interface TESDetailViewController ()

@end

@implementation TESDetailViewController

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.healthService)
    {
        self.displayNameLabel.text = self.healthService.displayName;
        self.phoneNumberLabel.text = self.healthService.formattedPhoneNumber;
        self.addressLabel.text = self.healthService.formattedAddress;
        self.webPageLabel.text = self.healthService.formattedWebPage;
        self.openingHoursTextView.text = self.healthService.formattedOpeningHoursAsString;
        self.openingHoursCommentTextView.text = self.healthService.formattedOpeningHoursComment;
        
        [self.mapView addAnnotation:[TESMapAnnotation mapAnnotationForHealthService:self.healthService]];
        [self.mapView setCenterCoordinate:self.healthService.location.coordinate];
        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.healthService.location.coordinate, 2000.f, 2000.f)];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.mapView.alpha = 1.0f;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.mapView.layer.masksToBounds = YES;
    self.mapView.layer.cornerRadius = 7.f;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView = [BGCommonGraphics backgroundView];
    
//    self.mapView.delegate = self;
    
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setOpeningHoursTextView:nil];
    [self setOpeningHoursCommentTextView:nil];
    [self setPhoneNumberLabel:nil];
    [self setAddressLabel:nil];
    [self setWebPageLabel:nil];
    [self setMapView:nil];
    [self setMapViewCell:nil];
    [self setMapViewCell:nil];
    [self setDisplayNameLabel:nil];
    [super viewDidUnload];
}

- (void)setHealthService:(id)newHealthService
{
    if (_healthService != newHealthService) {
        _healthService = newHealthService;
        
        // Update the view.
        [self configureView];
    }
}


#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showMap"])
    {
        self.mapView.alpha = 0.4f;
        
        [[segue destinationViewController] setHealthService:self.healthService];
    }
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        if (self.healthService.formattedWebPage.length == 0)
            return 2;
        else
            return 3;
    }
    
    if (section == 1) {
        if(self.healthService.formattedOpeningHoursComment.length == 0)
            return 1;
        else
            return 2;
    }
    
    return [super tableView:tableView numberOfRowsInSection:section];
        
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        CGRect frame = self.openingHoursTextView.frame;
        frame.size.height = self.openingHoursTextView.contentSize.height;
        frame.origin.y = frame.origin.y + 10.f;
        self.openingHoursTextView.frame = frame;
        
        return self.openingHoursTextView.frame.size.height + 20.f;
    }
    
    if(indexPath.section == 1 && indexPath.row == 1)
    {
        CGRect frame = self.openingHoursCommentTextView.frame;
        frame.size.height = self.openingHoursCommentTextView.contentSize.height;
        frame.origin.y = frame.origin.y + 10.f;
        self.openingHoursCommentTextView.frame = frame;
        
        return  self.openingHoursCommentTextView.frame.size.height + 20.f;;
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}


- (IBAction)placeCallAction:(UIButton *)sender
{
    [TESLegevaktActionManager placeCallTo:self.healthService.formattedPhoneNumber];
}

- (IBAction)openWebPage:(UIButton *)sender
{
    [TESLegevaktActionManager openWebPage:self.healthService.formattedWebPage];
}

#pragma mark - MapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    TESMapAnnotationView *mapPin = nil;
    if(annotation != map.userLocation)
    {
        static NSString *defaultPinID = @"defaultPin";
        mapPin = (TESMapAnnotationView *)[map dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        
        if (mapPin == nil )
        {
            mapPin = [[TESMapAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:defaultPinID];
        }
        else
            mapPin.annotation = annotation;
        
    }
    return mapPin;
}

@end
