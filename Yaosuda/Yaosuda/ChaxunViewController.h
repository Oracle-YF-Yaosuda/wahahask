//
//  ChaxunViewController.h
//  Yaosuda
//
//  Created by oracle on 15/11/30.
//  Copyright © 2015年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChaxunViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UISegmentedControl *fenduan;
- (IBAction)fenduan:(id)sender;

- (IBAction)Zuo:(id)sender;
- (IBAction)You:(id)sender;


@end
