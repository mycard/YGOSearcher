//
//  PandaTranslator.h
//  YGOSearcher
//
//  Created by Xin Peter on 14-1-6.
//  Copyright (c) 2014年 IamI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PandaTranslator : NSObject
+ (NSMutableString *) getADescription : (int) value;
+ (NSMutableString *) getDescription : (int) value;
+ (NSString*) getRace: (int) race;
+ (NSString*) getAttribute: (int) attribute;
+ (NSString*) getLevel: (int)level type: (int)type;
+ (NSString*) getNumber: (int)atk;
+ (NSString*) getParameter: (int) type;
@end
