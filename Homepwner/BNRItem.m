//
//  BNRItem.m
//  RandomPossessions
//
//  Created by Yin on 14-1-13.
//  Copyright (c) 2014年 Jack Yin. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem
@synthesize itemName;
@synthesize imageKey;
@synthesize containedItem, container, serialNumber, valueInDollars,dateCreated;
@synthesize thumbnail,thumbnailData;

- (UIImage *)thumbnail
{
    // 如果 thumbnailData 为 nil，表示没有缩略图
    if (!thumbnailData) {
        return nil;
    }
    if (!thumbnail) {
        thumbnail = [UIImage imageWithData:thumbnailData];
    }
    return thumbnail;
}

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

+ (id)randomItem
{
    // 创建数组对象，包括三个形容词
    NSArray *randomAdjectiveList = [NSArray arrayWithObjects:@"毛茸茸的", @"生锈的", @"光亮的", nil];
    
    // 创建数组对象，包括三个名词
    NSArray *randomNounList = [NSArray arrayWithObjects:@"熊", @"餐叉", @"电脑", nil];
    
    // 根据数组对象所含对象的个数，得到随机索引
    // 注意：运算符 % 是模运算符，运算后得到余数
    // 因此 adjectiveIndex 是一个 0 到 2（包括2）的随机数
    NSInteger adjectiveIndex = rand() % [randomAdjectiveList count];
    NSInteger nounIndex = rand() % [randomNounList count];
    
    // 注意，类型为 NSInteger 的变量不是对象
    // NSInteger 是一种针对 unsigned long（无符号长整数）的类型定义
    
    NSString *randomName = [NSString stringWithFormat:@"%@ %@", [randomAdjectiveList objectAtIndex:adjectiveIndex], [randomNounList objectAtIndex:nounIndex]];
    
    int randomValue = rand() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10];
    
    BNRItem *newItem = [[self alloc] initWithItemName:randomName valueInDollars:randomValue serialNumber:randomSerialNumber];
    
    return newItem;
}

#pragma mark - lifecycle

- (id)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber
{
    // 调用父类的指定初始化方法
    self = [super init];
    
    // 判断 self 是否为 nil，即父类是否成功初始化
    if (self) {
        // 为实例变量设定初始值
        [self setItemName:name];
        [self setSerialNumber:sNumber];
        [self setValueInDollars:value];
        dateCreated = [[NSDate alloc] init];
    }
    
    // 返回初始化后的对象的地址
    return self;
}

- (id)init
{
    return [self initWithItemName:@"名称:" valueInDollars:0 serialNumber:@""];
}

- (NSString *)description
{
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"%@ (%@): 价值 $%d, 记录日期为: %@", itemName, serialNumber, valueInDollars, dateCreated];
    return descriptionString;
}

- (id)initWithitemName:(NSString *)name serialNumber:(NSString *)sNumber
{
    return [self initWithItemName:name valueInDollars:0 serialNumber:sNumber];
}

- (void)setContainedItem:(BNRItem *)i
{
    containedItem = i;
    [i setContainer:self];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:itemName forKey:@"itemName"];
    [aCoder encodeObject:serialNumber forKey:@"serialNumber"];
    [aCoder encodeObject:dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:imageKey forKey:@"imageKey"];
    
    [aCoder encodeInt:valueInDollars forKey:@"valueInDollars"];
    
    [aCoder encodeObject:thumbnailData forKey:@"thumnailData"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setItemName:[aDecoder decodeObjectForKey:@"itemName"]];
        [self setSerialNumber:[aDecoder decodeObjectForKey:@"serialNumber"]];
        [self setImageKey:[aDecoder decodeObjectForKey:@"imageKey"]];
        
        [self setValueInDollars:[aDecoder decodeIntForKey:@"valueInDollars"]];
        
        dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        
        thumbnailData = [aDecoder decodeObjectForKey:@"thumnailData"];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"释放指针: %@", self);
}

@end

















