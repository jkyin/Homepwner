//
//  BNRItem.m
//  RandomPossessions
//
//  Created by Yin on 14-1-13.
//  Copyright (c) 2014年 Jack Yin. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem
@synthesize itemName;
@synthesize containedItem, container, serialNumber, valueInDollars,dateCreated;

+ (id)randomItem
{
    // 创建数组对象，包括三个形容词
    NSArray *randomAdjectiveList = [NSArray arrayWithObjects:@"Fluffy", @"Rusty", @"Shiny", nil];
    
    // 创建数组对象，包括三个名词
    NSArray *randomNounList = [NSArray arrayWithObjects:@"Bear", @"Spork", @"Mac", nil];
    
    // 根据数组对象所含对象的个数，得到随机索引
    // 注意：运算符 % 是模运算符，运算后得到余数
    // 因此 adjectiveIndex 是一个 0 到 2（包括2）的随机数
    NSInteger adjectiveIndex = rand() % [randomAdjectiveList count];
    NSInteger nounIndex = rand() % [randomNounList count];
    
    // 注意，类型为 NSInteger 的变量不是对象
    // NSInteger 是一种针对 unsigned long（无符号长整数）的类型定义
    
    NSString *randomName = [NSString stringWithFormat:@"%@ %@", [randomAdjectiveList objectAtIndex:adjectiveIndex], [randomNounList objectAtIndex:nounIndex]];
    
    int randomValue = rand() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10];
    
    BNRItem *newItem = [[self alloc] initWithItemName:randomName valueInDollars:randomValue serialNumber:randomSerialNumber];
    
    return newItem;
}

- (id)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber
{
    // 调用父类的指定初始化方法
    self = [super init];
    
    // 判断 self 是否为 nil，即父类是否成功初始化
    if (self) {
        // 为实例变量设定初始值
        [self setItemName:name];
        [self setSerialNumber:sNumber];
        [self setValueInDollars:value];
        dateCreated = [[NSDate alloc] init];
    }
    
    // 返回初始化后的对象的地址
    return self;
}

- (id)init
{
    return [self initWithItemName:@"item" valueInDollars:0 serialNumber:@""];
}

- (NSString *)description
{
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, record on %@", itemName, serialNumber, valueInDollars, dateCreated];
    return descriptionString;
}

- (id)initWithitemName:(NSString *)name serialNumber:(NSString *)sNumber
{
    return [self initWithItemName:name valueInDollars:0 serialNumber:sNumber];
}

- (void)setContainedItem:(BNRItem *)i
{
    containedItem = i;
    [i setContainer:self];
}

- (void)dealloc
{
    NSLog(@"Destroyed: %@", self);
}

@end
