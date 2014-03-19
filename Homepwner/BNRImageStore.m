//
//  BNRImageStore.m
//  Homepwner
//
//  Created by Yin on 14-2-8.
//  Copyright (c) 2014年 Jack Yin. All rights reserved.
//

#import "BNRImageStore.h"

@implementation BNRImageStore

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

+ (BNRImageStore *)sharedStore
{
    static BNRImageStore *sharedStore = nil;
    if (!sharedStore) {
        // 创建单例
        sharedStore = [[super allocWithZone:NULL] init];
    }
    return  sharedStore;
}

- (id)init
{
    self = [super init];
    if (self) {
        dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setImage:(UIImage *)i forKey:(NSString *)s
{
    [dictionary setObject:i forKey:s];
    
    // 获取保存图片的全路径
    NSString *imagePath = [self imagePathForKey:s];
    
    // 从图片提取 JPEG 格式的数据
    NSData *d = UIImageJPEGRepresentation(i, 0.5);
    
    // 将 JPEG 格式的数据写入文件
    [d writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)s
{
    // 先尝试通过字典对象获取图片
    UIImage *result = [dictionary objectForKey:s];
    
    if (!result) {
        // 通过文件创建图片
        result = [UIImage imageWithContentsOfFile:[self imagePathForKey:s]];
        
        // 如果能够通过文件创建图片，就将其放入缓存
        if (result) {
            [dictionary setObject:result forKey:s];
        } else {
            NSLog(@"错误：无法找到 %@", [self imagePathForKey:s]);
        }
    }
    return result;
}

- (void)deleteImageForKey:(NSString *)s
{
    if (!s) {
        return;
        [dictionary removeObjectForKey:s];
        
        NSString *path = [self imagePathForKey:s];
        [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    }
}

- (NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:key];
}





@end









