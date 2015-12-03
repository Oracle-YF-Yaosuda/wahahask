//
//  XiugaiViewController.h
//  Yaosuda
//
//  Created by oracle on 15/12/1.
//  Copyright © 2015年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XiugaiViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldpass;

@property (weak, nonatomic) IBOutlet UITextField *newpass;

@property (weak, nonatomic) IBOutlet  UITextField*newpass1;

@property (weak, nonatomic) IBOutlet UIButton *queren;

- (IBAction)queren:(id)sender;

@end
