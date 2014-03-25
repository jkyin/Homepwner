//
//  HomepwnerItemCell.m
//  Homepwner
//
//  Created by Yin on 14-3-23.
//  Copyright (c) 2014年 Jack Yin. All rights reserved.
//

#import "HomepwnerItemCell.h"

@implementation HomepwnerItemCell
@synthesize controller, tableView;

- (IBAction)showImage:(id)sender
{
    // 获取当前方法的方法名，即 "showImage:"
    NSString *selector = NSStringFromSelector(_cmd);
    
    // 将字符串修改为 "showImage:atIndexPath"
    selector = [selector stringByAppendingString:@"atIndexPath:"];
    
    // 将新生成的字符串转换回选择器
    SEL newSelector = NSSelectorFromString(selector);
    
    NSIndexPath *indexPath = [[self tableView] indexPathForCell:self];
    
    if (indexPath) {
        if ([[self controller] respondsToSelector:newSelector]) {
            
            // Xcode 会 warning，忽略
            [[self controller] performSelector:newSelector withObject:sender withObject:indexPath];
        }
    }
}
@end
