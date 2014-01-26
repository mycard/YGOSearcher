//
//  PandaSearchCondition.h
//  YGOSearcher
//
//  Created by Xin Peter on 14-1-22.
//  Copyright (c) 2014年 IamI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PandaRange : NSObject
@property int min;
@property int max;
+ (PandaRange *)getRange:(NSString* ) str;
@end

@interface PandaSearchCondition : NSObject
@property NSString *key;
@property int type;
@property int attribute;
@property int race;
@property PandaRange* level;
@property PandaRange* atk;
@property PandaRange* def;
@property BOOL atkNaN;
@property BOOL defNaN;
@property int category;
@property NSString *type_str;
@property NSString *detail_str;
@property NSString *value_str;
@property NSString *effect_str;
@end
