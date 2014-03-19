//
//  BNRItem.h
//  RandomPossessions
//
//  Created by Yin on 14-1-13.
//  Copyright (c) 2014年 Jack Yin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject <NSCoding>

+ (id)randomItem;

- (id)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber;

- (id)initWithitemName:(NSString *)name serialNumber:(NSString *)sNumber;

- (void)dealloc;

@property (nonatomic, strong) BNRItem *containedItem;
@property (nonatomic, weak) BNRItem *container;

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, readonly, strong) NSDate *dateCreated;

@property (nonatomic, copy) NSString *imageKey;

@end
