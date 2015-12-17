//
//  XiangqingViewController.h
//  Yaosuda
//
//  Created by oracle on 15/12/1.
//  Copyright © 2015年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XiangqingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property( strong , nonatomic)NSString*shangID;
@property (weak, nonatomic) IBOutlet UIButton *dijiaotianjia;
- (IBAction)tianjia:(id)sender;

@end
