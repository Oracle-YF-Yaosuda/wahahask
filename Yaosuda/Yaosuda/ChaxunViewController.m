//
//  ChaxunViewController.m
//  Yaosuda
//
//  Created by oracle on 15/11/30.
//  Copyright © 2015年 sk. All rights reserved.
//

#import "ChaxunViewController.h"
#import "Color+Hex.h"
#import "XiadanViewController.h"
#import "XinxiTableViewController.h"
#import "lianjie.h"
#import "hongdingyi.h"
#import "AFHTTPRequestOperationManager.h"
#import "SBJson.h"
#import "WarningBox.h"

@interface ChaxunViewController ()
{
    CGFloat width;
    CGFloat height;
    
    UITableViewCell *cell;
    
    int a;
    int index;
}
@end

@implementation ChaxunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.width;

    a=1;
    
    [self huoqu];
}

-(void)huoqu{
    
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString *url = @"/order/list";
    
    //时间戳
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    NSDate *datenow = [NSDate date];
    NSString *nowtimeStr = [formatter stringFromDate:datenow];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)nowtimeStr];
    NSLog(@"时间戳:%@",timeSp); //时间戳的值

    //将上传对象转换为json格式字符串
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"1008",@"loginUserId",@"2015-11-11",@"startDate",@"2015-11-21",@"endDate", @"2",@"state", @"1",@"pageNo",@"10",@"pageSize",nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];

    //获取签名
    NSString*sign= [lianjie postSign:url :userID :jsonstring :timeSp ];
    NSLog(@"%@",sign);
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    NSLog(@"url1==========================%@",url1);
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    NSLog(@"dic============%@",dic);
    [manager POST:url1 parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];

        
        if ([[responseObject objectForKey:@"code"] intValue] == 0000) {
        
            NSDictionary *datadic = [responseObject valueForKey:@"data"];
            NSLog(@"++++++++%@",datadic);
//            NSDictionary *dic= [responseObject valueForKey:@"orderList"];
//            NSLog(@"----------------%@",dic);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",error] andView:self.view];

        NSLog(@"%@",error);
    }];
    
    
    
    
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 325;//cell高度
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;//section高度
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *viewForHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 40)];
    
    UILabel *groupName = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 35)];
    groupName.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    groupName.text =@"订单1信息";
    groupName.font = [UIFont systemFontOfSize:13];
    
    UIButton *tu = [[UIButton alloc] initWithFrame:CGRectMake(width-80, 10, 15, 15)];
    [tu setBackgroundImage:[UIImage imageNamed:@"@2x_dd_22_18.png"] forState:UIControlStateNormal];

    UILabel *shenhe = [[UILabel alloc]initWithFrame:CGRectMake(width-10-50, 0, 50, 35)];
    shenhe.text = @"已审核";
    shenhe.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    shenhe.font = [UIFont systemFontOfSize:13];
    
    
    viewForHeader.backgroundColor=[UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    
    [viewForHeader addSubview:shenhe];
    [viewForHeader addSubview:groupName];
    [viewForHeader addSubview:tu];
    return viewForHeader;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *id1 =@"mycell";
    
    cell = [tableView cellForRowAtIndexPath:indexPath ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }

    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 80, 30)];
    lab1.text = @"订单编号:";
    lab1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab1.font = [UIFont systemFontOfSize:13];
    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(20, 35, width-40, 1)];
    xian1.backgroundColor = [UIColor colorWithHexString:@"e4e4e4" alpha:1];
    UILabel *lab11 = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, width-40-80, 30)];
    lab11.text = @"还没显示";
    lab11.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab11.font = [UIFont systemFontOfSize:13];
    lab11.textAlignment = UITextAlignmentCenter;

    
    
    UILabel *lab2 = [[UILabel  alloc]initWithFrame:CGRectMake(20, 45, 80, 30)];
    lab2.text = @"订单名称:";
    lab2.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab2.font = [UIFont systemFontOfSize:13];
    UIView *xian2 = [[UIView alloc]initWithFrame:CGRectMake(20, 75, width-40, 1)];
    xian2.backgroundColor = [UIColor colorWithHexString:@"e4e4e4" alpha:1];
    UILabel *lab21 = [[UILabel alloc]initWithFrame:CGRectMake(100, 45, width-40-80, 30)];
    lab21.text = @"还没显示";
    lab21.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab21.font = [UIFont systemFontOfSize:13];
    lab21.textAlignment = UITextAlignmentCenter;

    
    
    
    
    UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 85, 80, 30)];
    lab3.text = @"客户姓名:";
    lab3.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab3.font = [UIFont systemFontOfSize:13];
    UIView *xian3 = [[UIView alloc]initWithFrame:CGRectMake(20, 115, width-40, 1)];
    xian3.backgroundColor = [UIColor colorWithHexString:@"e4e4e4" alpha:1];
    UILabel *lab31 = [[UILabel alloc]initWithFrame:CGRectMake(100, 85, width-40-80, 30)];
    lab31.text = @"还没显示";
    lab31.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab31.font = [UIFont systemFontOfSize:13];
    lab31.textAlignment = UITextAlignmentCenter;

    
    
    
    
    
    UILabel *lab4 = [[UILabel alloc]initWithFrame:CGRectMake(20, 125, 80, 30)];
    lab4.text = @"商品数量:";
    lab4.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab4.font = [UIFont systemFontOfSize:13];
    UIView *xian4 = [[UIView alloc]initWithFrame:CGRectMake(20, 155, width-40, 1)];
    xian4.backgroundColor = [UIColor colorWithHexString:@"e4e4e4" alpha:1];
    UILabel *lab41 = [[UILabel alloc]initWithFrame:CGRectMake(100, 125, width-40-80, 30)];
    lab41.text = @"还没显示";
    lab41.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab41.font = [UIFont systemFontOfSize:13];
    lab41.textAlignment = UITextAlignmentCenter;

    
    
    
    
    
    
    UILabel *lab5 = [[UILabel alloc]initWithFrame:CGRectMake(20, 165, 80, 30)];
    lab5.text = @"订单金额:";
    lab5.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab5.font = [UIFont systemFontOfSize:13];
    UIView *xian5 = [[UIView alloc]initWithFrame:CGRectMake(20, 195, width-40, 1)];
    xian5.backgroundColor = [UIColor colorWithHexString:@"e4e4e4" alpha:1];
    UILabel *lab51 = [[UILabel alloc]initWithFrame:CGRectMake(100, 165, width-40-80, 30)];
    lab51.text = @"还没显示";
    lab51.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab51.font = [UIFont systemFontOfSize:13];
    lab51.textAlignment = UITextAlignmentCenter;

    
    
    
    
    
    UILabel *lab6 = [[UILabel alloc]initWithFrame:CGRectMake(20, 205, 80, 30)];
    lab6.text = @"优惠金额:";
    lab6.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab6.font = [UIFont systemFontOfSize:13];
    UIView *xian6 = [[UIView alloc]initWithFrame:CGRectMake(20, 235, width-40, 1)];
    xian6.backgroundColor = [UIColor colorWithHexString:@"e4e4e4" alpha:1];
    UILabel *lab61 = [[UILabel alloc]initWithFrame:CGRectMake(100, 205, width-40-80, 30)];
    lab61.text = @"还没显示";
    lab61.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab61.font = [UIFont systemFontOfSize:13];
    lab61.textAlignment = UITextAlignmentCenter;

    
    
    
    
    
    UILabel *lab7 = [[UILabel alloc]initWithFrame:CGRectMake(20, 245, 80, 30)];
    lab7.text = @"下单时间:";
    lab7.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab7.font = [UIFont systemFontOfSize:13];
    UIView *xian7 = [[UIView alloc]initWithFrame:CGRectMake(20, 275, width-40, 1)];
    xian7.backgroundColor = [UIColor colorWithHexString:@"e4e4e4" alpha:1];
    UILabel *lab71 = [[UILabel alloc]initWithFrame:CGRectMake(100, 245, width-40-80, 30)];
    lab71.text = @"还没显示";
    lab71.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab71.font = [UIFont systemFontOfSize:13];
    lab71.textAlignment = UITextAlignmentCenter;

    
    
    
    
    
    
    
    UILabel *lab8 = [[UILabel alloc]initWithFrame:CGRectMake(20, 285, 80, 30)];
    lab8.text = @"业务人员:";
    lab8.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab8.font = [UIFont systemFontOfSize:13];
    UILabel *lab81 = [[UILabel alloc]initWithFrame:CGRectMake(100, 285, width-40-80, 30)];
    lab81.text = @"还没显示";
    lab81.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab81.font = [UIFont systemFontOfSize:13];
    lab81.textAlignment = UITextAlignmentCenter;

    
    
    
    if (a == 1) {
        UIImageView *imag = [[UIImageView alloc]initWithFrame:CGRectMake(5, 4, width-10, 317)];
        imag.image = [UIImage imageNamed:@"b.png"];
        
        UIImageView *imag1 = [[UIImageView alloc]initWithFrame:CGRectMake(width-60, 320-50, 60, 55)];
        imag1.image = [UIImage imageNamed:@"@2x_dd_22_22.png"];
        [cell.contentView addSubview:imag];
        [cell.contentView addSubview:imag1];
    }else if(a == 2){
        UIImageView *imag = [[UIImageView alloc]initWithFrame:CGRectMake(5, 4, width-10, 317)];
        imag.image = [UIImage imageNamed:@"a.png"];
        
        UIImageView *imag1 = [[UIImageView alloc]initWithFrame:CGRectMake(width-60, 320-50, 60, 55)];
        imag1.image = [UIImage imageNamed:@"@2x_dd_22_22_22.png"];
        [cell.contentView addSubview:imag];
        [cell.contentView addSubview:imag1];


    }
    
    
    
    
    
    [cell.contentView addSubview:lab1];
    [cell.contentView addSubview:xian1];
    [cell.contentView addSubview:lab11];
    
    [cell.contentView addSubview:lab2];
    [cell.contentView addSubview:xian2];
    [cell.contentView addSubview:lab21];
    
    [cell.contentView addSubview:lab3];
    [cell.contentView addSubview:xian3];
    [cell.contentView addSubview:lab31];
    
    [cell.contentView addSubview:lab4];
    [cell.contentView addSubview:xian4];
    [cell.contentView addSubview:lab41];
    
    [cell.contentView addSubview:lab5];
    [cell.contentView addSubview:xian5];
    [cell.contentView addSubview:lab51];
    
    [cell.contentView addSubview:lab6];
    [cell.contentView addSubview:xian6];
    [cell.contentView addSubview:lab61];
    
    [cell.contentView addSubview:lab7];
    [cell.contentView addSubview:xian7];
    [cell.contentView addSubview:lab71];
    
    [cell.contentView addSubview:lab8];
    [cell.contentView addSubview:lab81];
    
  
    
    //cell不可点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (a == 2) {
        
        XinxiTableViewController*xinxi =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Xinxi"];
        [self.navigationController pushViewController:xinxi animated:YES];
        
    }
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)fenduan:(id)sender {
    
    index = (int)_fenduan.selectedSegmentIndex;
    if (index == 0 ) {
        a = 1;
        [self.tableview reloadData];
    }
    else if(index == 1){
        a = 2;
        [self.tableview reloadData];
    }
}

- (IBAction)Zuo:(id)sender {
}

- (IBAction)You:(id)sender {
}
@end
