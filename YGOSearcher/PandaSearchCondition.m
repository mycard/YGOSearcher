//
//  PandaSearchCondition.m
//  YGOSearcher
//
//  Created by Xin Peter on 14-1-22.
//  Copyright (c) 2014年 IamI. All rights reserved.
//

#import "PandaSearchCondition.h"

@implementation PandaRange
@synthesize max;
@synthesize min;
- (PandaRange*)init
{
    self.min = 0;
    self.max = NSIntegerMax;
    return self;
}
+ (PandaRange *)getRange:(NSString *)str
{
    PandaRange *answer = [[PandaRange alloc] init];
    if ([str length] == 0) return [[PandaRange alloc] init];
    NSArray* array = [str componentsSeparatedByString:@"-"];
    int length = [array count];
    NSString* minimum = (NSString*)array[0];
    NSString* maximum = (NSString*)array[length - 1];
    answer.min = [minimum intValue];
    answer.max = [maximum intValue];
    if (answer.max == 0 && (![maximum isEqualToString: @"0"])) answer.max = NSIntegerMax;
    return answer;
}
@end

@implementation PandaSearchCondition
@synthesize atk;
@synthesize def;
@synthesize atkNaN;
@synthesize defNaN;
@synthesize type;
@synthesize attribute;
@synthesize race;
@synthesize level;
@synthesize category;
@synthesize type_str;
@synthesize detail_str;
@synthesize value_str;
@synthesize effect_str;
@synthesize key;
- (PandaSearchCondition *) init
{
    key = @"";
    atk = [[PandaRange alloc] init];
    def = [[PandaRange alloc] init];
    atkNaN = NO;
    defNaN = NO;
    type = 0;
    attribute = 0;
    race = 0;
    level = [[PandaRange alloc] init];
    category = 0;
    type_str = @"";
    detail_str = @"";
    value_str = @"";
    effect_str = @"";
    return self;
}
@end
