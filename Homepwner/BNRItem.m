//
//  BNRItem.m
//  Homepwner
//
//  Created by Yin on 14-3-28.
//  Copyright (c) 2014年 Jack Yin. All rights reserved.
//

#import "BNRItem.h"


@implementation BNRItem

@dynamic itemName;
@dynamic serialNumber;
@dynamic valueInDollars;
@dynamic dateCreated;
@dynamic imageKey;
@dynamic thumbnailData;
@dynamic thumbnail;
@dynamic orderingValue;
@dynamic assetType;

- (void)setThumbnailDataFromImage:(UIImage *)image
{
    CGSize origImageSize = [image size];
    
    // 缩略图的大小
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    
    // 确定缩放倍数并保持宽高比不变
    float ratio = MAX(newRect.size.width / origImageSize.width, newRect.size.height / origImageSize.height);
    
    // 根据当前设备的屏幕 scaling factor，创建透明的位图上下文
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    // 创建代表圆角矩形的 UIBezierPath 对象
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    
    // 根据 UIBezierPath 对象裁剪绘图区域
    [path addClip];
    
    // 计算图片的居中显示位置
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    // 从上下文中绘制图片
    [image drawInRect:projectRect];
    
    // 通过图片上下文得到 UIImage 对象，并将其赋给 thumbnail 属性
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    [self setThumbnail:smallImage];
    
    // 从 UIImage 随心提取 PNG 格式的数据，并将得到的 NSData 对象赋给 thumbnailData 属性
    NSData *data = UIImagePNGRepresentation(smallImage);
    [self setThumbnailData:data];
    
    // 清理上下文
    UIGraphicsEndImageContext();
}

- (void)awakeFromFetch
{
    [super awakeFromFetch];
    
    UIImage *tn = [UIImage imageWithData:[self thumbnailData]];
    [self setPrimitiveValue:tn forKey:@"thumbnail"];
}

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    NSTimeInterval t = [[NSDate date] timeIntervalSinceReferenceDate];
    [self setDateCreated:t];
}

@end
