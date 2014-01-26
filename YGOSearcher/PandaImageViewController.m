//
//  PandaImageViewController.m
//  YGOSearcher
//
//  Created by Xin Peter on 14-1-7.
//  Copyright (c) 2014年 IamI. All rights reserved.
//

#import "PandaImageViewController.h"

@interface PandaImageViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UIButton *lab;

@end

@implementation PandaImageViewController
@synthesize targetId;
@synthesize lab;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)clicked:(id)sender
{
    if (self.lab.hidden) return;
    [lab setTitle: @"作死中……" forState: UIControlStateNormal];
    NSString *url2= [NSString stringWithFormat: @"http://my-card.in/cards/%d.png", targetId];
    UIImageFromURL( [NSURL URLWithString:url2], ^( UIImage * image )
                   {
                       lab.hidden = YES;
                       self.image.image = image;
                       NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                       NSString *path = (NSString *)[paths objectAtIndex:0];
                       path = [path stringByAppendingPathComponent:@"Image/"];
                       [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
                       NSString *imagePath = [path stringByAppendingPathComponent: [NSString stringWithFormat: @"%d.png", self.targetId]];
                       [UIImagePNGRepresentation(image)writeToFile: imagePath atomically:YES];
                       NSLog(@"%@",image);
                   }, ^(void){
                       NSLog(@"error!");
                       [lab setTitle: @"已作死" forState: UIControlStateNormal];
                   });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.targetId <= 0) return;
    // 尝试获取图片资源
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *path = (NSString *)[paths objectAtIndex:0];
    NSString *imagePath = [path stringByAppendingPathComponent: [NSString stringWithFormat: @"Image/%d.png", self.targetId]];
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath: imagePath];
    if (exist)
    {
        self.lab.hidden = YES;
        NSData *data=[NSData dataWithContentsOfFile:imagePath];
        [self.image setImage:[UIImage imageWithData:data]];
        [self navigationController].toolbarHidden = YES;
    }
    else
    {
        self.lab.hidden = NO;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
void UIImageFromURL( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) )
{
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                   {
                       NSData * data = [[NSData alloc] initWithContentsOfURL:URL];
                       UIImage * image = [[UIImage alloc] initWithData:data];
                       dispatch_async( dispatch_get_main_queue(), ^(void){
                           if( image != nil )
                           {
                               imageBlock( image );
                           } else {
                               errorBlock();
                           }
                       });
                   });
}
- (IBAction)UserTapped:(id)sender {
    if (lab.hidden == YES)
    {
        [self setTabBarHidden: !(self.tabBarController.tabBar.hidden)];
    }
}
- (IBAction)UserSwipeRight:(id)sender {
    [self moveTab:0];
}
- (IBAction)UserSwipeLeft:(id)sender {
    [self moveTab:2];
}
- (void)setTabBarHidden:(BOOL)hidden{
    UIView *tab = self.tabBarController.view;
    
    if ([tab.subviews count] < 2) {
        return;
    }
    UIView *view;
    
    if ([[tab.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]]) {
        view = [tab.subviews objectAtIndex:1];
    } else {
        view = [tab.subviews objectAtIndex:0];
    }
    
    if (hidden) {
        view.frame = tab.bounds;
    } else {
        view.frame = CGRectMake(tab.bounds.origin.x, tab.bounds.origin.y, tab.bounds.size.width, tab.bounds.size.height);
    }
    self.tabBarController.tabBar.hidden = hidden;
}

-(void) moveTab:(int) tabBarIndex
{
    UIView * fromView = self.tabBarController.selectedViewController.view;
    UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:tabBarIndex] view];
    
    // Get the size of the view area.
    CGRect viewSize = fromView.frame;
    BOOL scrollRight = tabBarIndex > self.tabBarController.selectedIndex;
    
    // Add the to view to the tab bar view.
    [fromView.superview addSubview:toView];
    
    // Position it off screen.
    toView.frame = CGRectMake((scrollRight ? 320 : -320), viewSize.origin.y, 320, viewSize.size.height);
    
    [UIView animateWithDuration:0.3
        animations: ^{
            // Animate the views on and off the screen. This will appear to slide.
            fromView.frame =CGRectMake((scrollRight ? -320 : 320), viewSize.origin.y, 320, viewSize.size.height);
            toView.frame =CGRectMake(0, viewSize.origin.y, 320, viewSize.size.height);
        }
        completion:^(BOOL finished) {
            if (finished) {
                // Remove the old view from the tabbar view.
                [fromView removeFromSuperview];
                self.tabBarController.selectedIndex = tabBarIndex;
            }
        }];
}
@end
