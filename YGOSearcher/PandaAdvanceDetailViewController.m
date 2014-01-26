//
//  PandaAdvanceDetailViewController.m
//  YGOSearcher
//
//  Created by Xin Peter on 14-1-23.
//  Copyright (c) 2014年 IamI. All rights reserved.
//

#import "PandaAdvanceDetailViewController.h"

@interface PandaAdvanceDetailViewController ()
@property (strong, nonatomic) IBOutlet UIButton *buttonSub;
@property (strong, nonatomic) IBOutlet UIButton *buttonAttribute;
@property (strong, nonatomic) IBOutlet UIButton *buttonRace;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;

@end

@implementation PandaAdvanceDetailViewController
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
- (IBAction)subClicked:(id)sender {
}
- (IBAction)attributeClicked:(id)sender {
}
- (IBAction)raceClicked:(id)sender {
}

@end
