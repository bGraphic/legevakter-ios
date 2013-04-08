//
//  TESDetailViewController.m
//  Legevakt
//
//  Created by Benedicte Raae on 08.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "TESDetailViewController.h"

@interface TESDetailViewController ()

@end

@implementation TESDetailViewController

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        self.phoneNumberCell.textLabel.text = self.detailItem.formattedPhoneNumber;
        self.AdressCell.textLabel.text = self.detailItem.formattedAddress;
        self.WebpageCell.textLabel.text = self.detailItem.formattedWebPage;
        self.OpeningHoursCell.textLabel.text = self.detailItem.formattedOpeningHoursAsString;
        self.OpeningHoursCommentCell.textLabel.text = self.detailItem.formattedOpeningHoursComment;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPhoneNumberCell:nil];
    [self setAdressCell:nil];
    [self setWebpageCell:nil];
    [self setOpeningHoursCell:nil];
    [self setOpeningHoursCommentCell:nil];
    [super viewDidUnload];
}
@end
