//
//  GerenViewController.h
//  Yaosuda
//
//  Created by oracle on 15/12/1.
//  Copyright © 2015年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GerenViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *fanhui;
- (IBAction)fanhui:(id)sender;

@end
