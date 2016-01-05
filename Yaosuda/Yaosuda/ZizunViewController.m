//
//  ZizunViewController.m
//  Yaosuda
//
//  Created by oracle on 15/12/4.
//  Copyright © 2015年 sk. All rights reserved.
//

#import "ZizunViewController.h"
#import "Color+Hex.h"
#define XianColor [UIColor colorWithHexString:@"dcdcdc" alpha:1]
@interface ZizunViewController ()
{
    
    CGFloat width;
    CGFloat height;
    
    
}

@end

@implementation ZizunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    self.navigationItem.title = @"产品资质";
    
    //解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self myTableView];
    
   }

//创建TableView
-(void)myTableView
{
    //创建tableview
    self.tableview = [[UITableView alloc]init];
    self.tableview.frame = CGRectMake(0, 79, width, height-79);
    self.tableview.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    //遵守代理
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    //显示在self.view上
    [self.view addSubview:self.tableview];
}

//返回组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//返回行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 347;
}
//setion高度
//cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 =@"cell125";
    
    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    //创建三条线
    UIView *shang = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 1)];
    shang.backgroundColor = XianColor;
    UIView *zhong = [[UIView alloc]initWithFrame:CGRectMake(0, 299, width, 1)];
    zhong.backgroundColor = XianColor;
    UIView *xia = [[UIView alloc]initWithFrame:CGRectMake(0, 346, width, 1)];
    xia.backgroundColor = XianColor;
    //创建image
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, width, 298)];
    image.image = [UIImage imageNamed:@""];
    //创建label
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 301, width-20, 40)];
    lab.textColor =[UIColor colorWithHexString:@"1e1e1e" alpha:1];
    lab.font = [UIFont systemFontOfSize:13];
    lab.numberOfLines = 0;
    lab.text = @"";
    
    
    //label
    [cell.contentView addSubview:lab];
    //image
    [cell.contentView addSubview:image];
    //线
    [cell.contentView addSubview:shang];
    [cell.contentView addSubview:zhong];
    [cell.contentView addSubview:xia];
    
    //cell不边灰
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    return cell;
}


//navigation返回按钮
- (IBAction)fanhui:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

}
@end