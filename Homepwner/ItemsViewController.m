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
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

#pragma mark - 协议

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:[sourceIndexPath row] toIndex:[destinationIndexPath row]];
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

- (UIView *)tableView:(UITableView *)tv viewForHeaderInSection:(NSInteger)sec
{
    return [self headerView];
}

- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)sec
{
    // 根据 XIB 文件中的顶层 UIView 对象的高度，返回 headerView 的高度
    return [[self headerView] bounds].size.height;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"移除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 如果UITableView 对象请求确认的是删除操作...
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BNRItemStore *ps = [BNRItemStore sharedStore];
        NSArray *items = [ps allItems];
        BNRItem *p = [items objectAtIndex:[indexPath row]];
        [ps removeItem:p];
        NSLog(@"\n 删除了: %@", p);
        // 还要删除表格视图中的相应表格行（带动画效果）
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (UIView *)headerView
{
    if (!headerView) {
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:Nil];
    }
    return headerView;
}

- (IBAction)toggleEditingMode:(id)sender
{
    // 如果当前的视图控制器对象已经处在编辑模式...
    if ([self isEditing]) {
        // 修改按钮文字，提示用户当前的表格状态
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        // 关闭编辑模式
        [self setEditing:NO animated:YES];
    }else {
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        [self setEditing:YES animated:YES];
    }
}

- (IBAction)addNewItem:(id)sender
{
    // 创建新的 BNRItem 实例，然后将新创建的实例加入 BNRItemStore 实例
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    NSLog(@"\n成功新建 %@", newItem);
    
    // 获取新创建的实例在 allItems 数组中的索引
    int lastRow = [[[BNRItemStore sharedStore] allItems] indexOfObject:newItem];
    // 创建 NSIndexPath 对象，代表的位置是：第一个表格段，最后一个表格行
    NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    // 将新行插入 UITableview 对象
    [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObjects:ip, nil] withRowAnimation:UITableViewRowAnimationTop];
}














@end
