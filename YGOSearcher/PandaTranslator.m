//
//  PandaTranslator.m
//  YGOSearcher
//
//  Created by Xin Peter on 14-1-6.
//  Copyright (c) 2014年 IamI. All rights reserved.
//

#import "PandaTranslator.h"

@implementation PandaTranslator
/*
 --Types
1           TYPE_MONSTER		=0x1		--
2           TYPE_SPELL			=0x2		--
4           TYPE_TRAP			=0x4		--
16          TYPE_NORMAL			=0x10		--
32          TYPE_EFFECT			=0x20		--
64          TYPE_FUSION			=0x40		--
128         TYPE_RITUAL			=0x80		--
256         TYPE_TRAPMONSTER	=0x100		--
512         TYPE_SPIRIT			=0x200		--
1024        TYPE_UNION			=0x400		--
2048        TYPE_DUAL			=0x800		--
4096        TYPE_TUNER			=0x1000		--
8192        TYPE_SYNCHRO		=0x2000		--
16384       TYPE_TOKEN			=0x4000		--
65536       TYPE_QUICKPLAY		=0x10000	--
131072      TYPE_CONTINUOUS		=0x20000	--
262144      TYPE_EQUIP			=0x40000	--
524288      TYPE_FIELD			=0x80000	--
1048576     TYPE_COUNTER		=0x100000	--
2097152     TYPE_FLIP			=0x200000	--
4194304     TYPE_TOON			=0x400000	--
8388608     TYPE_XYZ			=0x800000	--
 */
+ (NSMutableString*) getADescription: (int) type
{
     NSMutableString* answer = [NSMutableString stringWithString:@""];
     if (type & 0x800000 && [answer length] == 0) [answer appendString: @"超量"];
     if (type & 0x2000 && [answer length] == 0) [answer appendString: @"同调 "];
     if (type & 0x200000 && [answer length] == 0) [answer appendString: @"反转"];
     if (type & 0x100000 && [answer length] == 0) [answer appendString: @"反击"];
     if (type & 0x80000  && [answer length] == 0) [answer appendString: @"场地"];
     if (type & 0x40000  && [answer length] == 0) [answer appendString: @"装备"];
     if (type & 0x20000  && [answer length] == 0) [answer appendString: @"永续"];
     if (type & 0x10000  && [answer length] == 0) [answer appendString: @"速攻"];
     if (type & 0x80     && [answer length] == 0) [answer appendString: @"仪式"];
     if (type & 0x40     && [answer length] == 0) [answer appendString: @"融合"];
     if (type & 0x20     && [answer length] == 0) [answer appendString: @"效果"];
     if (type & 0x10     && [answer length] == 0) [answer appendString: @"通常"];
     if (type & 0x1) [answer appendString: @"怪兽 "];
     if ([answer length] == 0) [answer appendString: @"通常"];
     if (type & 0x2) [answer appendString: @"魔法"];
     if (type & 0x4) [answer appendString: @"陷阱"];
     if (type & 0x4000) [answer appendString: @"衍生物 "];
     if (type & 0x1000) [answer appendString: @"调整 "];
     if (type & 0x800) [answer appendString: @"二重 "];
     if (type & 0x400) [answer appendString: @"同盟 "];
     if (type & 0x200) [answer appendString: @"灵魂 "];
     if (type & 0x100) [answer appendString: @"反转 "];
     if (type & 0x400000) [answer appendString: @"卡通"];
     return answer;
}

+(NSString*) getDescription: (int) type
{
    NSMutableString* answer = [NSMutableString stringWithString:@""];
    if (type & 0x800000 && [answer length] == 0) [answer appendString: @"超量"];
    if (type & 0x2000 && [answer length] == 0) [answer appendString: @"同调"];
    if (type & 0x200000 && [answer length] == 0) [answer appendString: @"反转"];
    if (type & 0x100000 && [answer length] == 0) [answer appendString: @"反击"];
    if (type & 0x80000  && [answer length] == 0) [answer appendString: @"场地"];
    if (type & 0x40000  && [answer length] == 0) [answer appendString: @"装备"];
    if (type & 0x20000  && [answer length] == 0) [answer appendString: @"永续"];
    if (type & 0x10000  && [answer length] == 0) [answer appendString: @"速攻"];
    if (type & 0x80     && [answer length] == 0) [answer appendString: @"仪式"];
    if (type & 0x40     && [answer length] == 0) [answer appendString: @"融合"];
    if (type & 0x20     && [answer length] == 0) [answer appendString: @"效果"];
    if (type & 0x10     && [answer length] == 0) [answer appendString: @"通常"];
    if (type & 0x1) [answer appendString: @"怪兽 "];
    if ([answer length] == 0) [answer appendString: @"通常"];
    if (type & 0x2) [answer appendString: @"魔法"];
    if (type & 0x4) [answer appendString: @"陷阱"];
    return answer;
}


+ (NSString*) getParameter: (int) type
{
    NSMutableString *answer = [NSMutableString stringWithString:@""];
    if (type & 0x400) [answer appendString: @"同盟·"];
    if (type & 0x20     && [answer length] == 0) [answer appendString: @"效果·"];
    if (type & 0x4000) [answer appendString: @"衍生物·"];
    if (type & 0x800) [answer appendString: @"二重·"];
    if (type & 0x1000) [answer appendString: @"调整·"];
    if (type & 0x400000) [answer appendString: @"卡通·"];
    if (type & 0x200) [answer appendString: @"灵魂·"];
    if (type & 0x100) [answer appendString: @"反转·"];
    NSString *target;
    if ([answer length] != 0)
       target = [answer substringToIndex: [answer length] - 1];
    else target = answer;
    return target;
}
/*
 
 --Attributes
 ATTRIBUTE_EARTH		=0x01		--
 ATTRIBUTE_WATER		=0x02		--
 ATTRIBUTE_FIRE		=0x04		--
 ATTRIBUTE_WIND		=0x08		--
 ATTRIBUTE_LIGHT		=0x10		--
 ATTRIBUTE_DARK		=0x20		--
 ATTRIBUTE_DEVINE	=0x40		--
 */
 + (NSString*) getAttribute: (int) attribute
 {
     if (attribute & 0x01) return @"地";
     if (attribute & 0x02) return @"水";
     if (attribute & 0x04) return @"火";
     if (attribute & 0x08) return @"风";
     if (attribute & 0x10) return @"光";
     if (attribute & 0x20) return @"暗";
     if (attribute & 0x40) return @"神";
     return @"NTG";
 }
/*
RACE_WARRIOR		=0x1		--
RACE_SPELLCASTER	=0x2		--
RACE_FAIRY			=0x4		--
RACE_FIEND			=0x8		--
RACE_ZOMBIE			=0x10		--
RACE_MACHINE		=0x20		--
RACE_AQUA			=0x40		--
RACE_PYRO			=0x80		--
RACE_ROCK			=0x100		--
RACE_WINDBEAST		=0x200		--
RACE_PLANT			=0x400		--
RACE_INSECT			=0x800		--
RACE_THUNDER		=0x1000		--
RACE_DRAGON			=0x2000		--
RACE_BEAST			=0x4000		--
RACE_BEASTWARRIOR	=0x8000		--
RACE_DINOSAUR		=0x10000	--
RACE_FISH			=0x20000	--
RACE_SEASERPENT		=0x40000	--
RACE_REPTILE		=0x80000	--
RACE_PSYCHO			=0x100000	--
RACE_DEVINE			=0x200000	--
RACE_CREATORGOD		=0x400000	--
 
 */
+ (NSString*) getRace: (int) race
{
    if (race & 0x1) return @"战士";
    if (race & 0x2) return @"魔法使";
    if (race & 0x4) return @"天使";
    if (race & 0x8) return @"恶魔";
    if (race & 0x10) return @"不死";
    if (race & 0x20) return @"机械";
    if (race & 0x40) return @"水";
    if (race & 0x80) return @"炎";
    if (race & 0x100) return @"岩石";
    if (race & 0x200) return @"鸟兽";
    if (race & 0x400) return @"植物";
    if (race & 0x800) return @"昆虫";
    if (race & 0x1000) return @"雷";
    if (race & 0x2000) return @"龙";
    if (race & 0x4000) return @"兽";
    if (race & 0x8000) return @"兽战士";
    if (race & 0x10000) return @"恐龙";
    if (race & 0x20000) return @"鱼";
    if (race & 0x40000) return @"海龙";
    if (race & 0x80000) return @"爬行";
    if (race & 0x100000) return @"念动力";
    if (race & 0x200000) return @"幻兽神";
    if (race & 0x400000) return @"创世神";
    return @"NTG";
}

+ (NSString*) getNumber: (int)atk
{
    if (atk == -1) return @"∞";
    else if (atk == -2) return @"?";
    else return  [NSString stringWithFormat: @"%d", atk];
}

+ (NSString*) getLevel: (int)level type: (int)type
{
    if (type & 0x800000) return [NSString stringWithFormat: @"Rank.%d", level];
    else return [NSString stringWithFormat:@"Lv.%d", level];
}
@end