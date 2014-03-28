//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Yin on 14-1-19.
//  Copyright (c) 2014年 Jack Yin. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@implementation BNRItemStore

+ (BNRItemStore *)sharedStore
{
    static BNRItemStore *shareStore = nil;
    
    if (!shareStore) {
        shareStore = [[super allocWithZone:nil] init];
    }
    return shareStore;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedStore];
}

- (id)init
{
    self = [super init];
    if (self) {
        // 读取 Homepwner.xcdatamodeld
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        // 设置 SQLite 文件路径
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
        }
        // 创建 NSManagedObjectContext 对象
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:psc];
        
        // NSManagedObjectContext 对象可以管理撤销（undo）操作，而 Homepwner 不需要该功能
        [context setUndoManager:nil];
        
        [self loadAllItems];
        
    }
    return self;
}

#pragma mark - 实例方法

- (void)moveItemAtIndex:(int)from toIndex:(int)to
{
    if (from == to) {
        return;
    }
    
    // 得到要移动的对象的指针，以便稍后能将其插入新的位置
    BNRItem *p = [allItems objectAtIndex:from];
    
    // 将 p 从 allItems 数组中移除
    [allItems removeObjectAtIndex:from];
    
    // 根据新的索引位置，将 p 插回 allItems 数组
    [allItems insertObject:p atIndex:to];
    
    // 为移动的 BNRItem 实现计算新的 orderValue
    double lowerBound = 0.0;
    
    // 在数组中，该对象之前是否有其他对象？
    if (to > 0) {
        lowerBound = [[allItems objectAtIndex:to - 1] orderingValue];
    } else {
        lowerBound = [[allItems objectAtIndex:1] orderingValue] - 2.0;
    }
    
    double upperBound = 0.0;
    
    // 在数组中，该对象之后是否有其他对象
    if (to < [allItems count] - 1) {
        upperBound = [[allItems objectAtIndex:to + 1] orderingValue];
    } else {
        upperBound = [[allItems objectAtIndex:to - 1] orderingValue] + 2.0;
    }
    
    double newOrderValue = (lowerBound + upperBound) / 2.0;
    
    NSLog(@"moving to order %f", newOrderValue);
    [p setOrderingValue:newOrderValue];
}

- (NSArray *)allItems
{
    return allItems;
}

- (BNRItem *)createItem
{
    double order;
    if ([allItems count]== 0) {
        order = 1.0;
    } else {
        order = [[allItems lastObject] orderingValue] + 1.0;
    }
    NSLog(@"Adding after %d items, order %.2f", [allItems count], order);
    
    BNRItem *p = [NSEntityDescription insertNewObjectForEntityForName:@"BNRItem" inManagedObjectContext:context];
    
    [p setOrderingValue:order];
    
    [allItems addObject:p];
    
    return p;
}

- (void)removeItem:(BNRItem *)p
{
    NSString *key = [p imageKey];
    [[BNRImageStore sharedStore] deleteImageForKey:key];
    [context deleteObject:p];
    [allItems removeObjectIdenticalTo:p];
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // 从 documentDirectories 数组获取文档目录路径（documentDirectories 只包含一个对象）
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (BOOL)saveChanges
{
    NSError *err = nil;
    BOOL successful = [context save:&err];
    if (!successful) {
        NSLog(@"Error saving: %@", [err localizedDescription]);
    }
    return successful;
}

- (void)loadAllItems
{
    if (!allItems) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [[model entitiesByName] objectForKey:@"BNRItem"];
        [request setEntity:e];
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObject:sd]];
        
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: &@", [error localizedDescription]];
        }
        allItems = [[NSMutableArray alloc] initWithArray:result];
    }
}

@end
















