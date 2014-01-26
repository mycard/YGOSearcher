//
//  PandaHighSearchViewController.m
//  YGOSearcher
//
//  Created by Xin Peter on 14-1-23.
//  Copyright (c) 2014年 IamI. All rights reserved.
//

#import "PandaHighSearchViewController.h"
#import "PandaSearchCondition.h"
#import "PandaHighAnswerViewController.h"
#import <sqlite3.h>

@interface PandaHighSearchViewController ()
{
    NSArray *pickerText;
    NSDictionary *usingPicker;
    UIButton *usingButton;
    SEL running;
    sqlite3_stmt *answer;
}
@property (strong, nonatomic) IBOutlet UITextField *cardName;
@property (strong, nonatomic) IBOutlet UIButton *btPrefix;
@property (strong, nonatomic) IBOutlet UIButton *btType;
@property (strong, nonatomic) IBOutlet UIButton *btAttribute;
@property (strong, nonatomic) IBOutlet UIButton *btRace;
@property (strong, nonatomic) IBOutlet UIButton *btSub;
@property (strong, nonatomic) IBOutlet UIButton *btEffect;
@property (weak, nonatomic) IBOutlet UIButton *btSearch;
@property (strong, nonatomic) IBOutlet UITextField *cardLevel;
@property (strong, nonatomic) IBOutlet UITextField *cardAttack;
@property (strong, nonatomic) IBOutlet UITextField *cardDefense;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UISwitch *swAtkNaN;
@property (strong, nonatomic) IBOutlet UISwitch *swDefNaN;
@property (strong, nonatomic) IBOutlet UILabel *lbGone;
@property (strong, nonatomic) NSDictionary *setting;
@end

@implementation PandaHighSearchViewController
@synthesize btAttribute;
@synthesize btEffect;
@synthesize btPrefix;
@synthesize btRace;
@synthesize btSub;
@synthesize btType;
@synthesize cardAttack;
@synthesize cardDefense;
@synthesize cardLevel;
@synthesize cardName;
@synthesize picker;
@synthesize swAtkNaN;
@synthesize swDefNaN;
@synthesize setting;
@synthesize condition;
@synthesize sql;

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
    cardName.text = condition.key;
    [cardName reloadInputViews];
    picker.frame = CGRectMake(0, 480, 320, 260);
    self.setting = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"Property List" ofType: @"plist"]];
    cardAttack.delegate = self;
    cardDefense.delegate = self;
    cardLevel.delegate = self;
    cardName.delegate = self;
    picker.delegate = self;
    picker.dataSource = self;
    NSString *stringForAnswer =
   @"SELECT t.id "
    "FROM texts t "
    "INNER JOIN datas d "
    "ON d.id = t.id "
    "WHERE "
    "( "
    "CAST(t.id AS TEXT) LIKE ? "
    "OR t.name LIKE ? "
    "OR t.DESC LIKE ? "
    ") "
    "AND ((d.atk BETWEEN ? AND ?) OR (? AND d.atk == -2)) "
    "AND ((d.def BETWEEN ? AND ?) OR (? AND d.def == -2)) "
    "AND d.level BETWEEN ? AND ? "
    "AND d.type & ? == ? "
    "AND d.race & ? == ? "
    "AND d.attribute & ? == ? "
    "AND d.category & ? == ? ";
    sqlite3_prepare_v2(sql, [stringForAnswer UTF8String], -1, &answer, NULL);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)prefixClicked:(id)sender {
    NSDictionary *prefix = (NSDictionary *)setting[@"Type"][@"Prefix"];
    int _type = condition.type & 0x7;
    NSDictionary *list;
    int value = 0;
    if (_type == 1)
    {
        list = (NSDictionary *)[prefix valueForKey:@"Monster"];
        value = condition.type & 0x8020F0;
    }
    else if (_type == 2)
    {
        list = (NSDictionary *)[prefix valueForKey:@"Spell"];
        value = condition.type & 0xF0080;
    }
    else if (_type == 4)
    {
        list = (NSDictionary *)[prefix valueForKey:@"Trap"];
        value = condition.type & 0x120000;
    }
    else list = (NSDictionary *)[prefix valueForKey:@"Any"];
    running = @selector(afterPrefixClicked);
    [self buttonClicked:btPrefix withData:list targetValue:value];
}
- (IBAction)typeClicked:(id)sender {
    NSDictionary *type2 = (NSDictionary *)setting[@"Type"][@"Type"];
    int _type = condition.type & 0x7;
    running = @selector(afterTypeClicked);
    [self buttonClicked:btType withData:type2 targetValue:_type];
}
- (IBAction)attributeClicked:(id)sender {
    NSDictionary *attributes = (NSDictionary *)setting[@"Detail"][@"Attribute"];
    running = @selector(afterAttributeClciked);
    [self buttonClicked:btAttribute withData:attributes targetValue:condition.attribute];
    ;}
- (IBAction)raceClicked:(id)sender {
    NSDictionary *races = (NSDictionary *)setting[@"Detail"][@"Race"];
    running = @selector(afterRaceClicked);
    [self buttonClicked:btRace withData:races targetValue:condition.race];
}
- (IBAction)subClicked:(id)sender {
    NSDictionary *subs = (NSDictionary *)setting[@"Detail"][@"Additional"];
    running = @selector(afterSubClicked);
    int value = condition.type & 0x605F00;
    [self buttonClicked:btSub withData:subs targetValue:value];
}
- (IBAction)effectClicked:(id)sender{
    NSDictionary *category = (NSDictionary *)setting[@"Category"];
    running = @selector(afterEffectClicked);
    [self buttonClicked:btEffect withData:category targetValue:condition.category];
}
- (void)buttonClicked: (UIButton *) button withData: (NSDictionary *) data targetValue: (int)value
{
    [self ResetPos];
    pickerText =[data allValues];
    usingPicker = data;
    usingButton = button;
    [picker reloadAllComponents];
    int index = [[data allKeys] indexOfObject: [NSString stringWithFormat:@"%d", value]];
    [picker selectRow:index inComponent:0 animated:YES];
    [self ViewAnimation: picker willHidden: NO];
    
}
- (void)afterPrefixClicked {
    
    int selected = [picker selectedRowInComponent:0];
    NSString *key = [usingPicker allKeys][selected];
    [btPrefix setTitle: (NSString *)[usingPicker valueForKey:key] forState: UIControlStateNormal];
    int target = key.intValue;
    condition.type = [self setBit:condition.type Replace:target withMask:0x605F07];
}
- (void)afterTypeClicked {
    int selected = [picker selectedRowInComponent:0];
    NSString *key = [usingPicker allKeys][selected];
    [btType setTitle: (NSString *)[usingPicker valueForKey:key] forState: UIControlStateNormal];
    int target = key.intValue;
    condition.type = [self setBit: condition.type Replace:target withMask:~0x7];
    if ([key isEqual: @"1"])
    {
        [self setButton:btRace willAble: YES];
        [self setButton:btAttribute willAble: YES];
        [self setButton:btSub willAble: YES];
        cardAttack.enabled = YES;
        cardDefense.enabled = YES;
        cardLevel.enabled = YES;
        swAtkNaN.enabled = YES;
        swDefNaN.enabled = YES;
    }
    else
    {
        [self setButton:btRace willAble: NO];
        [self setButton:btAttribute willAble: NO];
        [self setButton:btSub willAble: NO];
        cardAttack.enabled = NO;
        cardDefense.enabled = NO;
        cardLevel.enabled = NO;
        swAtkNaN.enabled = NO;
        swDefNaN.enabled = NO;
    }
}
- (void)afterAttributeClciked {
    condition.attribute = [self afterButtonClicked];
}
- (void)afterRaceClicked {
    condition.race = [self afterButtonClicked];
}
- (void)afterSubClicked {
    int value = [self afterButtonClicked];
    condition.type = [self setBit:condition.type Replace:value withMask:~0x605F00];
}
- (void)afterEffectClicked {
    condition.category = [self afterButtonClicked];
    
}
- (int)afterButtonClicked
{
    int selected = [picker selectedRowInComponent:0];
    NSString *key = [usingPicker allKeys][selected];
    [usingButton setTitle: (NSString *)[usingPicker valueForKey:key] forState: UIControlStateNormal];
    int target = key.intValue;
    return target;
}

- (IBAction)atkNaNChanged:(id)sender {
    condition.atkNaN = swAtkNaN.isOn;
}
- (IBAction)defNaNChanged:(id)sender {
    condition.defNaN = swDefNaN.isOn;
}
- (IBAction)cardNameChanged:(id)sender {
    if (cardName.text != nil)
        condition.key = cardName.text;
}
- (IBAction)cardLevelChanged:(id)sender {
    condition.level = [PandaRange getRange: cardLevel.text];
}
- (IBAction)cardAtkChanged:(id)sender {
    condition.atk = [PandaRange getRange: cardAttack.text];
}
- (IBAction)cardDefChanged:(id)sender {
    condition.def = [PandaRange getRange: cardDefense.text];
}
- (IBAction)backgroundTap:(id)sender {
    [self ResetPos];
    if (!(picker.hidden))
        [self ViewAnimation:picker willHidden: YES];
    running = nil;
}
- (void) ResetPos
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [cardName resignFirstResponder];
    [cardAttack resignFirstResponder];
    [cardDefense resignFirstResponder];
    [cardLevel resignFirstResponder];
}

#pragma mark picker 调整
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerText == nil ? 0 : [pickerText count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return pickerText == nil ? 0 : 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return pickerText[row];
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (running != nil) [self performSelector:running];
}

#pragma mark TextField 调整
- (void)keyboardWillShow:(NSNotification *)noti
{
    //键盘输入的界面调整
    //键盘的高度
    float height = 216.0;
    CGRect frame = self.view.frame;
    frame.size = CGSizeMake(frame.size.width, frame.size.height - height);
    [UIView beginAnimations:@"Curl"context:nil];//动画开始
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationDelegate:self];
    [self.view setFrame:frame];
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        self.view.frame = rect;
    }
    [UIView commitAnimations];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}
# pragma mark -

- (void)ViewAnimation:(UIView*)view willHidden:(BOOL)hidden {
    
    [UIView animateWithDuration:0.3 animations:^{
        if (hidden) {
            view.frame = CGRectMake(0, 480, 320, 260);
        } else {
            [view setHidden:hidden];
            view.frame = CGRectMake(0, 245, 320, 260);
        }
    } completion:^(BOOL finished) {
        [view setHidden:hidden];
    }];
}

- (void)setButton: (UIButton*) button willAble: (BOOL)enable
{
    button.enabled = enable;
    [button setTitleColor:[btType titleLabel].textColor forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
}

- (int)setBit: (int) A Replace: (int) B withMask: (int) mask
{
    A = A & mask;
    B = B & ~mask;
    A = A | B;
    return A;
}
- (IBAction)userSwipeLeft:(id)sender {
}
- (IBAction)userSwipeRight:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 最终处理

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // 此为界面出口
    // 最后检查
    int type = condition.type & 7;
    if (type != 1)
    {
        condition.atk = [[PandaRange alloc] init];
        condition.def = [[PandaRange alloc] init];
        condition.level = [[PandaRange alloc] init];
        condition.race = 0;
        condition.attribute = 0;
    }
    if (type == 4) // 陷阱
        condition.type = condition.type & (1048576 + 131072 + 4);
    else if (type == 2) // 魔法
        condition.type = condition.type & (128 + 65536 + 131072 + 262144 + 524288 + 2);
    else if (type == 1) // 怪兽
        condition.type = condition.type & (~(65536 + 131072 + 262144 + 524288 + 1048576));
    else // 任意
        condition.type = 0;
    // 启动查询
    sqlite3_reset(answer);
    NSMutableString *name = [NSMutableString stringWithString: @"%"];
    [name appendString: condition.key];
    [name appendString: @"%"];
    char * trueStr = "1";
    char * falseStr = "0";
    sqlite3_bind_text(answer, 1, [name UTF8String], -1, NULL);
    sqlite3_bind_text(answer, 2, [name UTF8String], -1, NULL);
    sqlite3_bind_text(answer, 3, [name UTF8String], -1, NULL);
    sqlite3_bind_int(answer, 4, condition.atk.min);
    sqlite3_bind_int(answer, 5, condition.atk.max);
    sqlite3_bind_text(answer, 6, condition.atkNaN ? trueStr : falseStr, -1, NULL);
    sqlite3_bind_int(answer, 7, condition.def.min);
    sqlite3_bind_int(answer, 8, condition.def.max);
    sqlite3_bind_text(answer, 9, condition.defNaN ? trueStr : falseStr, -1, NULL);
    sqlite3_bind_int(answer, 10, condition.level.min);
    sqlite3_bind_int(answer, 11, condition.level.max);
    sqlite3_bind_int(answer, 12, condition.type);
    sqlite3_bind_int(answer, 13, condition.type);
    sqlite3_bind_int(answer, 14, condition.race);
    sqlite3_bind_int(answer, 15, condition.race);
    sqlite3_bind_int(answer, 16, condition.attribute);
    sqlite3_bind_int(answer, 17, condition.attribute);
    sqlite3_bind_int(answer, 18, condition.category);
    sqlite3_bind_int(answer, 19, condition.category);
    
    NSMutableArray * searchResults = [NSMutableArray arrayWithObjects: nil];
    while (sqlite3_step(answer) == SQLITE_ROW)
        [searchResults addObject: [NSNumber numberWithInt: sqlite3_column_int(answer, 0)]];
    // 传值
    PandaHighAnswerViewController *destination = (PandaHighAnswerViewController *)[segue destinationViewController];
    destination.searchResult = searchResults;
    destination.sql = sql;
}
@end
