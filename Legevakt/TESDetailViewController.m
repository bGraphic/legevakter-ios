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
#import "TESHealthServiceActionManager.h"
#import "TESMapDelegate.h"

@interface TESDetailViewController ()

@property (nonatomic, strong) TESMapDelegate *mapDelegate;

@end

@implementation TESDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = NSLocalizedString(@"detail_view_controller_title", nil);
    
    self.mapView.layer.masksToBounds = YES;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        self.mapView.layer.cornerRadius = 7.f;
    }
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView = [BGCommonGraphics backgroundView];
    
    self.mapView.delegate = self;
    
    [self configureView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.mapView.alpha = 1.0f;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    [self setOpenInMapButton:nil];
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
        
        self.mapDelegate = [[TESMapDelegate alloc] init];
        self.mapView.delegate = self.mapDelegate;
        
        [self.mapView addAnnotation:[TESMapAnnotation mapAnnotationForHealthService:self.healthService]];
        [self.mapView setCenterCoordinate:self.healthService.location.coordinate];
        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.healthService.location.coordinate, 2000.f, 2000.f)];

        if(self.healthService.location)
        {
            self.openInMapButton.hidden = NO;
        }
        else
        {
            self.openInMapButton.hidden = YES;
        }
    }
}


#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showMapFromButton"] || [segue.identifier isEqualToString:@"showMapFromMap"])
    {
        self.mapView.alpha = 0.4f;
        
        [[segue destinationViewController] setHealthService:self.healthService];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.healthService.location)
        return 3;
    else
        return 2;
}

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
        CGSize size = [self.openingHoursTextView sizeThatFits:CGSizeMake(self.openingHoursTextView.frame.size.width, FLT_MAX)];
        
        return size.height+20.f;
    }
    
    if(indexPath.section == 1 && indexPath.row == 1)
    {
        CGSize size = [self.openingHoursCommentTextView sizeThatFits:CGSizeMake(self.openingHoursCommentTextView.frame.size.width, FLT_MAX)];
        
        return  size.height+20.f;
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}


- (IBAction)placeCallAction:(UIButton *)sender
{
    [TESHealthServiceActionManager placeCallTo:self.healthService.formattedPhoneNumber];
}

- (IBAction)openWebPage:(UIButton *)sender
{
    [TESHealthServiceActionManager openWebPage:self.healthService.formattedWebPage];
}

@end
