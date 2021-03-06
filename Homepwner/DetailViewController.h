//
//  DetailViewController.h
//  Homepwner
//
//  Created by Yin on 14-2-7.
//  Copyright (c) 2014年 Jack Yin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface DetailViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
{
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialNumberField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UIImageView *imageView;
}
@property (nonatomic, strong) BNRItem *item;

- (IBAction)takePicture:(id)sender;

- (IBAction)backgroundTapped:(id)sender;

@end
