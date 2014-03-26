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
#import "DetailViewController.h"
#import "HomepwnerItemCell.h"
#import "BNRImageStore.h"
#import "ImageViewController.h"

@implementation ItemsViewController

#pragma mark - lifecycle

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        UINavigationItem *n = [self navigationItem];
        
        [n setTitle:@"Homepwner"];
        
        // 创建新的 UIBarButtonItem 对象
        // 将其目标对象设置为当前对象，将其动作方法设置为 addNewItem:
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        
        // 为 UINavigationItem 对象的 rightBarButtonItem 属性复制，
        // 指向新创建的 UIBarButtonItem 对象
        [[self navigationItem] setRightBarButtonItem:bbi];
        
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"HomepwnerItemCell" bundle:nil];
    
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"HomepwnerItemCell"];
}

#pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    
    NSArray *item = [[BNRItemStore sharedStore] allItems];
    BNRItem *selectedItem = [item objectAtIndex:[indexPath row]];
    
    // 将选中国年的 BNRItem 实例赋给 DetailViewController 对象
    [detailViewController setItem:selectedItem];
    [[self navigationController] pushViewController:detailViewController animated:YES];
}

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
    BNRItem *p = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    
    HomepwnerItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepwnerItemCell"];
    
    [cell setController:self];
    [cell setTableView:tableView];
    
    [[cell nameLabel] setText:[p itemName]];
    [[cell serialNumberLabel] setText:[p serialNumber]];
    [[cell valueLabel] setText:[NSString stringWithFormat:@"%d", [p valueInDollars]]];
    
    [[cell thumbnailView] setImage:[p thumbnail]];
    
    return cell;
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

#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [imagePopover dismissPopoverAnimated:YES];
    imagePopover = nil;
}

#pragma mark - selector

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

- (void)showImage:(id)sender atIndexPath:(NSIndexPath *)ip
{
    NSLog(@"显示 %@ 位置的图片", ip);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // 根据 NSIndexPath 对象获取 BNRItem 实例
        BNRItem *i = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[ip row]];
        
        NSString *imageKey = [i imageKey];
        
        // 如果 BRNItem 实例没有图片，就直接返回
        UIImage *img = [[BNRImageStore sharedStore] imageForKey:imageKey];
        if (!img) {
            return;
        }
        
        // 根据 UITableView 对象的坐标系，获取 UIButton 对象的位置和大小
        CGRect rect = [[self view] convertRect:[sender bounds] fromView:sender];
        
        // 创建 ImageViewController 对象并为 image 属性赋值
        ImageViewController *ivc = [[ImageViewController alloc] init];
        [ivc setImage:img];
        
        // 根据之前得到的按钮位置和大小，显示一个大小为 600*600 点的 UIPopoverController 对象
        imagePopover = [[UIPopoverController alloc] initWithContentViewController:ivc];
        [imagePopover setDelegate:self];
        [imagePopover setPopoverContentSize:CGSizeMake(600, 600)];
        [imagePopover presentPopoverFromRect:rect inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}













@end
