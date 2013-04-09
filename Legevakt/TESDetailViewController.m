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

@interface TESDetailViewController ()

@end

@implementation TESDetailViewController

- (void)setHealthService:(id)newHealthService
{
    if (_healthService != newHealthService) {
        _healthService = newHealthService;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.healthService) {
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.mapView.layer.masksToBounds = YES;
    self.mapView.layer.cornerRadius = 7.f;
    
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
    [super viewDidUnload];
}

#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showMap"])
    {
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


@end
