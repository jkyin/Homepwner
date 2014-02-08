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

- (void)setItem:(BNRItem *)i
{
    // UINavigationBar 显示选中的 BNRItem 实例的 name 属性
    item = i;
    [[self navigationItem] setTitle:[i itemName]];
}

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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 取消当前的第一响应对象
    [[self view] endEditing:YES];
    
    // 将修改「保存」至 BNRItem 实例
    [item setItemName:[nameField text]];
    [item setSerialNumber:[serialNumberField text]];
    [item setValueInDollars:[[valueField text] intValue]];
}

// 这段代码能够在用户触摸背景区的时候使数字键盘消息
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [valueField resignFirstResponder];
}

- (IBAction)takePicture:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // 如果设备支持相机，就使用拍照模式
    // 否则让用户从相片库选择相片
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [imagePicker setDelegate:self];
    
    // 显示 UIImagePickerController 对象的视图
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 通过 info 对象得到用户选取的图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // 将图片附给 UIImageView 对象并显示出来
    [imageView setImage:image];
    
    // 要关闭 UIImagePickerController 对象，必需调用 dismissViewControllerAnimated:completion: 方法
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end










