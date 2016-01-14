//
//  XinxiViewController.m
//  Yaosuda
//
//  Created by suokun on 15/12/9.
//  Copyright © 2015年 sk. All rights reserved.
//

#import "XinxiViewController.h"
#import "Color+Hex.h"
#import "hongdingyi.h"
#import "AFHTTPRequestOperationManager.h"
#import "SBJsonWriter.h"
#import "WarningBox.h"
#import "lianjie.h"
#import "yonghuziliao.h"
#import "ChaxunViewController.h"

#define ziticolor [UIColor colorWithHexString:@"3c3c3c" alpha:1];
#define zitifont [UIFont systemFontOfSize:15];
@interface XinxiViewController ()
{
    UIView *underView;
    UIButton *passButton;
    UIButton *backButton;
    CGFloat width;
    CGFloat height;
    //分段换控制器
    UISegmentedControl *segmentedControl;
    int index;
    int zhi;
    
    NSArray *orderDetailList;
    
}
@end
@implementation XinxiViewController
-(void)viewWillAppear:(BOOL)animated{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"shen"] intValue]==0) {
        passButton.hidden=YES;
        backButton.hidden=YES;
        underView.hidden=YES;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    self.tableview.backgroundColor = [UIColor clearColor];
    
//解决tableview多出的白条
    self.automaticallyAdjustsScrollViewInsets = NO;
//获取设备宽和高
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
//遵守 tableview 代理协议
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    zhi = 1;

    [self SPxinxi];
    
    [self fenduan];
    [self anniu];
}

//创建分段控制器
-(void)fenduan
{
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"订单信息",@"商品信息",nil];
    //初始化UISegmentedControl
    segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(0,0,width/2,30);
    segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    segmentedControl.tintColor = [UIColor whiteColor];
    self.navigationItem.titleView = segmentedControl;
    [segmentedControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
}
//分段控制器点击方法
-(void)change:(UISegmentedControl *)segmentControl
{
    index = (int)segmentedControl.selectedSegmentIndex;
    if (index == 0 ) {
        zhi = 1;
        [self.tableview reloadData];
    }
    else if(index == 1){
        zhi = 2;
        [self.tableview reloadData];
    }

}
//获取订单信息2.3
-(void)DDxinxi
{
    
    
}
//获取商品信息2.4
-(void)SPxinxi
{
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString *url = @"/order/detailList";
    [WarningBox warningBoxModeIndeterminate:@"加载中..." andView:self.view];
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
    
    //将上传对象转换为json格式字符串
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    
    NSDictionary*datadic1=[NSDictionary dictionaryWithObjectsAndKeys:_orderId,@"orderId",nil];
    NSLog(@"输入值－－－－－%@",datadic1);
    NSString*jsonstring=[writer stringWithObject:datadic1];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    
    //电泳借口需要上传的数据
    NSDictionary*dic1=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    
    
    [manager GET:url1 parameters:dic1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        NSLog(@"shangpin  xinxi---------------------------%@",responseObject);
        if ([[responseObject objectForKey:@"code"] intValue] == 0000) {
            
            
            NSDictionary *data1 = [responseObject valueForKey:@"data"];
            orderDetailList = [data1 objectForKey:@"orderDetailList"];
            
            
            
            [self.tableview reloadData];
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"数据加载失败～" andView:self.view];
        
    }];
}
//tableview 分组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (zhi == 1)
    {
        return 1;
    }
    else
    {
        return orderDetailList.count;
    }
    return 0;
   }
//tableview 行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return 1;

}
//setion高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if(zhi == 1)
    {
        return width/2;
    }
    if (zhi == 2)
    {
        return width/8*6;
    }
    return 0;
}
//section内容
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 15)];
    baseView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    return baseView;
    
    return nil;
}
//编辑cell内容
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id1 = @"cell3";
    UITableViewCell *cell= [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    CGFloat gao2 = width;
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(15, gao2/8, width-30, 1)];
    xian.backgroundColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1];
    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(15, gao2/4, width-30, 1)];
    xian1.backgroundColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1];
    UIView *xian2 = [[UIView alloc]initWithFrame:CGRectMake(15, gao2/8*3, width-30, 1)];
    xian2.backgroundColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1];
    UIView *xian3 = [[UIView alloc]initWithFrame:CGRectMake(15, gao2/2, width-30, 1)];
    xian3.backgroundColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1];
    UIView *xian4 = [[UIView alloc]initWithFrame:CGRectMake(15, gao2/8*5, width-30, 1)];
    xian4.backgroundColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1];
    UIView *xian5 = [[UIView alloc]initWithFrame:CGRectMake(15, gao2/8*6, width-30, 1)];
    xian5.backgroundColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1];

    UILabel *lab0 = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, gao2/8)];
    lab0.font = zitifont;
    lab0.textColor = ziticolor;
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(15, gao2/8, 100, gao2/8)];
    lab1.font = zitifont;
    lab1.textColor = ziticolor;
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(15, gao2/4, 100, gao2/8)];
    lab2.font = zitifont;
    lab2.textColor = ziticolor;
    UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(15, gao2/8*3, 100, gao2/8)];
    lab3.font = zitifont;
    lab3.textColor = ziticolor;
    UILabel *lab4 = [[UILabel alloc]initWithFrame:CGRectMake(15, gao2/2, 100, gao2/8)];
    lab4.font = zitifont;
    lab4.textColor = ziticolor;
    UILabel *lab5 = [[UILabel alloc]initWithFrame:CGRectMake(15, gao2/8*5, 100, gao2/8)];
    lab5.font = zitifont;
    lab5.textColor = ziticolor;
   

    UILabel *you0 = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, width-30, gao2/8)];
    you0.font = zitifont;
    you0.textColor = ziticolor;
    UILabel *you1 = [[UILabel alloc]initWithFrame:CGRectMake(120, gao2/8, width-30, gao2/8)];
    you1.font = zitifont;
    you1.textColor = ziticolor;
    UILabel *you2 = [[UILabel alloc]initWithFrame:CGRectMake(120, gao2/4, width-30, gao2/8)];
    you2.font = zitifont;
    you2.textColor = ziticolor;
    UILabel *you3 = [[UILabel alloc]initWithFrame:CGRectMake(120,  gao2/8*3, width-30, gao2/8)];
    you3.font = zitifont;
    you3.textColor = ziticolor;
    UILabel *you4 = [[UILabel alloc]initWithFrame:CGRectMake(120, gao2/2, width-30, gao2/8)];
    you4.font = zitifont;
    you4.textColor = ziticolor;
    UILabel *you5 = [[UILabel alloc]initWithFrame:CGRectMake(120, gao2/8*5, width-30, gao2/8)];
    you5.font = zitifont;
    you5.textColor = ziticolor;
  
    if (zhi == 1)
    {
        lab0.text = @"订单类型:";
        lab1.text = @"是否开票:";
        lab2.text = @"是否收款:";
        lab3.text = @"是否退货:";
        
        NSString *orderType1;//订单类型
        NSString *isGather1;//是否收款
        NSString *isInvoice1;//是否开票
        NSString *isNewRecord1;//是否退货
        
        if([_orderType isEqualToString:@"0"])
        {
            orderType1 = @"业务联系人";
        }else
        {
            orderType1 = @"业务联系人";
        }
        if([_isGather isEqualToString:@"0"])
        {
            isGather1 = @"未收款";
        }else
        {
            isGather1 = @"已收款";
        }
        if([_isInvoice isEqualToString:@"0"])
        {
            isInvoice1 = @"未开票";
        }else
        {
            isInvoice1 = @"已开票";
        }
        if([_isNewRecord isEqualToString:@"0"])
        {
            isNewRecord1 = @"无退货";
        }else
        {
            isNewRecord1 = @"有退货";
        }

        you0.text = orderType1;
        you1.text = isInvoice1;
        you2.text = isGather1;
        you3.text = isNewRecord1;
        
        [cell.contentView addSubview:xian];
        [cell.contentView addSubview:xian1];
        [cell.contentView addSubview:xian2];
        [cell.contentView addSubview:xian3];
        
    }
    else if(zhi == 2)
    {   lab0.text = @"商品名称:";
        lab1.text = @"订单编码:";
        lab2.text = @"数量:";
        lab3.text = @"联系人价格:";
        lab4.text = @"客户价格:";
        lab5.text = @"总价:";
        
        you0.text = [NSString stringWithFormat:@"%@",[[orderDetailList [indexPath.section] objectForKey:@"productions"] objectForKey:@"proName"] ];
        you1.text = [orderDetailList [indexPath.section] objectForKey:@"orderCode"];
        you2.text = [NSString stringWithFormat:@"%@",[orderDetailList [indexPath.section] objectForKey:@"amount"] ];
        you3.text =  [NSString stringWithFormat:@"%@",[orderDetailList [indexPath.section] objectForKey:@"favorablePrice"] ];
        you4.text =  [NSString stringWithFormat:@"%@",[orderDetailList [indexPath.section] objectForKey:@"costPrice"] ];
        you5.text =  [NSString stringWithFormat:@"%@",[orderDetailList [indexPath.section] objectForKey:@"totalPrice"] ];
        
        [cell.contentView addSubview:xian];
        [cell.contentView addSubview:xian1];
        [cell.contentView addSubview:xian2];
        [cell.contentView addSubview:xian3];
        [cell.contentView addSubview:xian4];

    }
    [cell.contentView addSubview:lab0];
    [cell.contentView addSubview:lab1];
    [cell.contentView addSubview:lab2];
    [cell.contentView addSubview:lab3];
    [cell.contentView addSubview:lab4];
    [cell.contentView addSubview:lab5];
 
    [cell.contentView addSubview:you0];
    [cell.contentView addSubview:you1];
    [cell.contentView addSubview:you2];
    [cell.contentView addSubview:you3];
    [cell.contentView addSubview:you4];
    [cell.contentView addSubview:you5];
   

    cell.backgroundColor=[UIColor whiteColor];
    //cell不可点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    return cell;
}
//创建按钮
-(void)anniu
{
    underView = [[UIView alloc]init];
    underView.frame = CGRectMake(0, height-50, width, 50);
    underView.backgroundColor = [UIColor colorWithHexString:@"aaaaaa" alpha:0.5];
    [self.view bringSubviewToFront:underView];
    
    passButton = [[UIButton alloc]init];
    passButton.frame = CGRectMake(10, 7, width/2-20, 40);
    [passButton setTitle:@"通过" forState:UIControlStateNormal];
    [passButton setTitleColor:[UIColor colorWithHexString:@"ffffff" alpha:1] forState:UIControlStateNormal];
    passButton.backgroundColor = [UIColor colorWithHexString:@"FF7F00" alpha:0.6];
    passButton.layer.cornerRadius = 5.0;
    [passButton addTarget:self action:@selector(tongguo) forControlEvents:UIControlEventTouchUpInside];
    
    backButton = [[UIButton alloc]init];
    backButton.frame = CGRectMake(width-width/2+10, 7, width/2-20, 40);
    [backButton setTitle:@"退回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithHexString:@"ffffff" alpha:1] forState:UIControlStateNormal];
    backButton.backgroundColor = [UIColor colorWithHexString:@"FF7F00" alpha:0.6];
    backButton.layer.cornerRadius = 5.0;
    [backButton addTarget:self action:@selector(tuihui) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:underView];
    [underView addSubview:passButton];
    [underView addSubview:backButton];
}
-(void)tuihui
{
    NSString*loginUserId=[[yonghuziliao getUserInfo] objectForKey:@"id"];
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/order/return";
    [WarningBox warningBoxModeIndeterminate:@"订单退回中..." andView:self.view];
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];

    
    //将上传对象转换为json格式字符串
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter* writer=[[SBJsonWriter alloc] init];
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_orderId,@"orderId",loginUserId,@"loginUserId",@"xixi",@"advic", nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
   
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
   
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    [manager GET:url1 parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
      [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.navigationController.view];
       
        if ([[responseObject objectForKey:@"code"] intValue]==0000) {
            
            
            ChaxunViewController *chaxun = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"chaxun"];
            [self.navigationController pushViewController:chaxun animated:YES];

            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络连接错误～" andView:self.view];
        
    }];

    
}
-(void)tongguo
{
    NSString*loginUserId=[[yonghuziliao getUserInfo] objectForKey:@"id"];
    
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/order/audit";
    [WarningBox warningBoxModeIndeterminate:@"订单审核中..." andView:self.view];
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];

   
    
    //将上传对象转换为json格式字符串
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter* writer=[[SBJsonWriter alloc] init];
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:_orderId,@"orderId",loginUserId,@"loginUserId",@"xius",@"advic", nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie postSign:url :userID :jsonstring :timeSp ];
   
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
   
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    [manager POST:url1 parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.navigationController.view];
  
        if ([[responseObject objectForKey:@"code"] intValue]==0000) {
            
            ChaxunViewController *chaxun = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"chaxun"];
            [self.navigationController pushViewController:chaxun animated:YES];

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:@"网络连接错误～" andView:self.view];
       
    }];

    
}

@end
