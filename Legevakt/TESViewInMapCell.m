//
//  TESViewInMapCell.m
//  Legevakt
//
//  Created by Benedicte Raae on 12.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import "TESViewInMapCell.h"

@implementation TESViewInMapCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureCellIsSearchResult:(BOOL) searchResult
{
    if (searchResult)
        self.label.text = NSLocalizedString(@"search_results_in_map", nil);
    else
        self.label.text = NSLocalizedString(@"health_services_in_map", nil);
}

@end
