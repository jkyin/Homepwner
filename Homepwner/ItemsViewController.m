//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Yin on 14-1-19.
//  Copyright (c) 2014年 Jack Yin. All rights reserved.
//

#import "ItemsViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"

@implementation ItemsViewController
{
    
}

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        for (int i = 0; i < 5; i++) {
            [[BNRItemStore sharedStore] createItem];
        }
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 先检查是否有可以重用的 UITableViewCell 对象，有就使用之
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    // 针对某种类型，如果没有可以重用的 UITableViewCell 对象，就创建新的
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    // 获取 allItems 的第 n 个 BNRItem 实例，然后将该 BNRItem 实例的描述信息赋给 UITableViewCell 对象的 textLabel
    // 这里的 n 是该 UITableViewCell 对象所对应的表格行索引
    BNRItem *p = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:[p description]];
    
    return cell;
}

@end
