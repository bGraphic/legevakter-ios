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
        self.phoneNumberLabel.text = self.detailItem.formattedPhoneNumber;
        self.addressLabel.text = self.detailItem.formattedAddress;
        self.webPageLabel.text = self.detailItem.formattedWebPage;
        self.openingHoursTextView.text = self.detailItem.formattedOpeningHoursAsString;
        self.openingHoursCommentTextView.text = self.detailItem.formattedOpeningHoursComment;
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
    [self setOpeningHoursTextView:nil];
    [self setOpeningHoursCommentTextView:nil];
    [self setPhoneNumberLabel:nil];
    [self setAddressLabel:nil];
    [self setWebPageLabel:nil];
    [super viewDidUnload];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        if (self.detailItem.formattedWebPage.length == 0)
            return 2;
        else
            return 3;
    }
    
    if (section == 1) {
        if(self.detailItem.formattedOpeningHoursComment.length == 0)
            return 1;
        else
            return 2;
    }
    
    return 0;
        
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
