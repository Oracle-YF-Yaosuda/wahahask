//
//  XinxiViewController.m
//  Yaosuda
//
//  Created by suokun on 15/12/9.
//  Copyright © 2015年 sk. All rights reserved.
//

#import "XinxiViewController.h"
#import "Color+Hex.h"
@interface XinxiViewController ()
{
    CGFloat width;
    CGFloat height;
    
    NSMutableArray *shuzu;
    NSMutableArray *shuju;
    
    int zhi;
}
@end
@implementation XinxiViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
//解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
//获取设备宽和高
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
//遵守 tableview 代理协议
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    [self array];
    [self fenduan];
    [self anniu];
}
//创建分段控制器
-(void)fenduan{
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"订单信息",@"商品信息",nil];
    //初始化UISegmentedControl
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(0,0,width/2,30);
    segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    segmentedControl.tintColor = [UIColor whiteColor];
    self.navigationItem.titleView = segmentedControl;
}
//创建按钮
-(void)anniu{
    UIView *underView = [[UIView alloc]init];
    underView.frame = CGRectMake(0, height-40, width, 40);
    underView.backgroundColor = [UIColor colorWithHexString:@"aaaaaa" alpha:0.5];
    [self.view bringSubviewToFront:underView];
    
    UIButton *passButton = [[UIButton alloc]init];
    passButton.frame = CGRectMake(10, 7, width/2-20, 30);
    [passButton setTitle:@"通过" forState:UIControlStateNormal];
    [passButton setTitleColor:[UIColor colorWithHexString:@"ffffff" alpha:1] forState:UIControlStateNormal];
    passButton.backgroundColor = [UIColor colorWithHexString:@"FF7F00" alpha:0.6];
    passButton.layer.cornerRadius = 5.0;
    
    
    UIButton *backButton = [[UIButton alloc]init];
    backButton.frame = CGRectMake(width-width/2+10, 7, width/2-20, 30);
    [backButton setTitle:@"退回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithHexString:@"ffffff" alpha:1] forState:UIControlStateNormal];
    backButton.backgroundColor = [UIColor colorWithHexString:@"FF7F00" alpha:0.6];
    backButton.layer.cornerRadius = 5.0;

    
    [self.view addSubview:underView];
    [underView addSubview:passButton];
    [underView addSubview:backButton];
}
//需要改得地方
-(void)array{
    shuzu = [[NSMutableArray alloc]init];
    [shuzu addObject:@"订单详情:"];
    [shuzu addObject:@"订单详情:"];
    [shuzu addObject:@"订单详情:"];
    [shuzu addObject:@"订单详情:"];
    [shuzu addObject:@"订单详情:"];
    [shuzu addObject:@"订单详情:"];
    [shuzu addObject:@"订单详情:"];
    [shuzu addObject:@"订单详情:"];
    [shuzu addObject:@"订单详情:"];
    [shuzu addObject:@"订单详情:"];
    [shuzu addObject:@"订单详情:"];
    [shuzu addObject:@"订单详情:"];
    [shuzu addObject:@"订单详情:"];
    [shuzu addObject:@"订单详情:"];
    [shuzu addObject:@"订单详情:"];
    
    shuju = [[NSMutableArray alloc]init];
    [shuju addObject:@"121212122222"];
    [shuju addObject:@"121212122222"];
    [shuju addObject:@"121212122222"];
    [shuju addObject:@"121212122222"];
    [shuju addObject:@"121212122222"];
    [shuju addObject:@"121212122222"];
    [shuju addObject:@"121212122222"];
    [shuju addObject:@"121212122222"];
    [shuju addObject:@"121212122222"];
    [shuju addObject:@"121212122222"];
    [shuju addObject:@"121212122222"];
    [shuju addObject:@"121212122222"];
    [shuju addObject:@"121212122222"];
    [shuju addObject:@"121212122222"];
    [shuju addObject:@"121212122222"];

}

//tableview 分组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//tableview 行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return shuzu.count;
}
//setion高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 40;
}
//section内容
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
//编辑cell内容
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *id1 = @"cell3";
    UITableViewCell *cell= [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    UILabel *leftlabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, 60, 30)];
    leftlabel.textColor= [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    leftlabel.font = [UIFont systemFontOfSize:13];
    leftlabel.text = shuzu[indexPath.row];
    
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(15, 39, width-30, 1)];
    xian.backgroundColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1];
    
    UILabel *rightLable = [[UILabel alloc]initWithFrame:CGRectMake(80, 7, width-80, 30)];
    rightLable.textColor= [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    rightLable.font = [UIFont systemFontOfSize:13];
    rightLable.text = shuju[indexPath.row];
    rightLable.textAlignment = NSTextAlignmentCenter;
    
    
    
    
    [cell.contentView addSubview:xian];
    [cell.contentView addSubview:leftlabel];
    [cell.contentView addSubview:rightLable];
    
    
   
    
    //cell不可点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    return cell;
}
@end
