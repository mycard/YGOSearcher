//
//  PandaAdvanceTypeViewController.m
//  YGOSearcher
//
//  Created by Xin Peter on 14-1-23.
//  Copyright (c) 2014年 IamI. All rights reserved.
//

#import "PandaAdvanceTypeViewController.h"

@interface PandaAdvanceTypeViewController ()
@property (strong, nonatomic) IBOutlet UIButton *buttonPrefix;
@property (strong, nonatomic) IBOutlet UIButton *buttonCard;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;

@end

@implementation PandaAdvanceTypeViewController
@synthesize condition;
@synthesize setting;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)prefixClicked:(id)sender {
}
- (IBAction)typeClicked:(id)sender {
}

@end
