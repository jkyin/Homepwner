//
//  BNRItemStore.h
//  Homepwner
//
//  Created by Yin on 14-1-19.
//  Copyright (c) 2014年 Jack Yin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class BNRItem;

@interface BNRItemStore : NSObject
{
    NSMutableArray *allItems;
    NSMutableArray *allAssetTypes;
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
}
+ (BNRItemStore *)sharedStore;

- (NSArray *)allItems;
- (BNRItem *)createItem;
- (void)removeItem:(BNRItem *)p;
- (void)moveItemAtIndex:(int)from toIndex:(int)to;
- (NSString *)itemArchivePath;
- (BOOL)saveChanges;
- (void)loadAllItems;
@end
