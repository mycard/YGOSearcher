//
//  PandaAdvancedSearchViewController.m
//  YGOSearcher
//
//  Created by Xin Peter on 14-1-22.
//  Copyright (c) 2014年 IamI. All rights reserved.
//

#import "PandaAdvancedSearchViewController.h"
#import "PandaAdvanceDetailViewController.h"
#import "PandaAdvanceEffectViewController.h"
#import "PandaAdvanceTypeViewController.h"
#import "PandaAdvanceValueViewController.h"

@interface PandaAdvancedSearchViewController ()
@property (strong, nonatomic) IBOutlet UIView *containerType;
@property (strong, nonatomic) IBOutlet UIView *containerDetail;
@property (strong, nonatomic) IBOutlet UIView *containerValue;
@property (strong, nonatomic) IBOutlet UIView *containerEffect;
@property (strong, nonatomic) NSDictionary *setting;
@end

@implementation PandaAdvancedSearchViewController

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
    self.setting = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"Property List" ofType: @"plist"]];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)Type
{
    return self.Type;
}
- (void)setType:(int) value
{
    type = value;
    [self.containerType setHidden:YES];
    [self.containerDetail setHidden:YES];
    [self.containerEffect setHidden:YES];
    [self.containerValue setHidden:YES];
    switch (type) {
        case 1:
            [self.containerType setHidden:NO];
            break;
        case 2:
            [self.containerDetail setHidden:NO];
            break;
        case 3:
            [self.containerValue setHidden:NO];
            break;
        case 4:
            [self.containerEffect setHidden:NO];
            break;
        default:
            break;
    }
}

@end
