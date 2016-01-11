//
//  ViewController.h
//  Yaosuda
//
//  Created by oracle on 15/11/30.
//  Copyright © 2015年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *diview;
@property (weak, nonatomic) IBOutlet UITextField *user;
@property (weak, nonatomic) IBOutlet UITextField *pass;
@property (weak, nonatomic) IBOutlet UIButton *denglu;
- (IBAction)denglu:(id)sender;
- (IBAction)genghuan:(id)sender;
- (IBAction)jizhu:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *diandian;

@end

