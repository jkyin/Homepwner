//
//  DetailViewController.m
//  Homepwner
//
//  Created by Yin on 14-2-7.
//  Copyright (c) 2014年 Jack Yin. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize item;

#pragma mark - lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [nameField setText:[item itemName]];
    [serialNumberField setText:[item serialNumber]];
    [valueField setText:[NSString stringWithFormat:@"%d",[item valueInDollars]]];
    
    // 创建 NSDateFromatter 对象，用于将 NSDate 对象转换成简单的日期字符串
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    // 将转换后得到的日期字符串设置为 dateLabel 的标题
    [dateLabel setText:[dateFormatter stringFromDate:[item dateCreated]]];
}

@end
