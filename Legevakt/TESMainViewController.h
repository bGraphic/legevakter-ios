//
//  TESMainViewController.h
//  Legevakt
//
//  Created by Benedicte Raae on 09.04.13.
//  Copyright (c) 2013 Tom Erik St√∏wer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TESMainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *tableView;
@property (weak, nonatomic) IBOutlet UIView *mapView;

- (IBAction)mainViewChanged:(id)sender;

@end
