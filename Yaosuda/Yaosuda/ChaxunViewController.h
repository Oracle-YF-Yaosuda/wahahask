//
//  ChaxunViewController.h
//  Yaosuda
//
//  Created by oracle on 15/11/30.
//  Copyright © 2015年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChaxunViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UISegmentedControl *fenduan;
- (IBAction)fenduan:(id)sender;

- (IBAction)Zuo:(id)sender;

@property (weak, nonatomic) IBOutlet UIDatePicker *picker;
- (IBAction)queding:(id)sender;
- (IBAction)quxiao:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *qian;

@property (weak, nonatomic) IBOutlet UITextField *hou;

- (IBAction)chaxun:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *chaxun;



@property (weak, nonatomic) IBOutlet UIView *beijing;

@end
