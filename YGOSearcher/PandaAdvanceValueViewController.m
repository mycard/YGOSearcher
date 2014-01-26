//
//  PandaAdvanceValueViewController.m
//  YGOSearcher
//
//  Created by Xin Peter on 14-1-23.
//  Copyright (c) 2014年 IamI. All rights reserved.
//

#import "PandaAdvanceValueViewController.h"

@interface PandaAdvanceValueViewController ()
@property (strong, nonatomic) IBOutlet UITextField *textLevel;
@property (strong, nonatomic) IBOutlet UITextField *textAtk;
@property (strong, nonatomic) IBOutlet UITextField *textDef;
@property (strong, nonatomic) IBOutlet UISwitch *ableAtkNaN;
@property (strong, nonatomic) IBOutlet UISwitch *ableDefNaN;

@end

@implementation PandaAdvanceValueViewController
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
- (IBAction)Reset:(id)sender {
}

@end
