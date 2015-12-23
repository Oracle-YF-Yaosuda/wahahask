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
#define ziticolor [UIColor colorWithHexString:@"3c3c3c" alpha:1];
#define zitifont [UIFont systemFontOfSize:13];
@interface XinxiViewController ()
{
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
-(void)DDxinxi{
    
    
}
//获取商品信息2.4
-(void)SPxinxi{
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString *url = @"/order/detailList";
    
    //时间戳
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    NSDate *datenow = [NSDate date];
    NSString *nowtimeStr = [formatter stringFromDate:datenow];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)nowtimeStr];
    //NSLog(@"时间戳:%@",timeSp); //时间戳的值
    
    //将上传对象转换为json格式字符串
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    //出入参数：
    
    NSDictionary*datadic1=[NSDictionary dictionaryWithObjectsAndKeys:_orderId,@"orderId",nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic1];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    
    //电泳借口需要上传的数据
    NSDictionary*dic1=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    
    
    [manager GET:url1 parameters:dic1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue] == 0000) {
            //NSLog(@"右边返回数据--------%@",responseObject);
            
            NSDictionary *data1 = [responseObject valueForKey:@"data"];
            orderDetailList = [data1 objectForKey:@"orderDetailList"];
            NSLog(@"-------------%@",orderDetailList);
            
            
            [self.tableview reloadData];
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",error] andView:self.view];
        
        NSLog(@"%@",error);
        
    }];
}


//tableview 分组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
   }
//tableview 行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (zhi == 1)
    {
        return 1;
    }
    else
    {
        return 1;
    }
    return 0;

}
//setion高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(zhi == 1)
    {
        return 10;
    }
    if (zhi == 2)
    {
        return 486;
    }
    return 0;
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
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(15, 40, width-30, 1)];
    xian.backgroundColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1];
    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(15, 80, width-30, 1)];
    xian1.backgroundColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1];
    UIView *xian2 = [[UIView alloc]initWithFrame:CGRectMake(15, 120, width-30, 1)];
    xian2.backgroundColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1];
    UIView *xian3 = [[UIView alloc]initWithFrame:CGRectMake(15, 160, width-30, 1)];
    xian3.backgroundColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1];
    UIView *xian4 = [[UIView alloc]initWithFrame:CGRectMake(15, 200, width-30, 1)];
    xian4.backgroundColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1];
    UIView *xian5 = [[UIView alloc]initWithFrame:CGRectMake(15, 240, width-30, 1)];
    xian5.backgroundColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1];
    UIView *xian6 = [[UIView alloc]initWithFrame:CGRectMake(15, 280, width-30, 1)];
    xian6.backgroundColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1];
    UIView *xian7 = [[UIView alloc]initWithFrame:CGRectMake(15, 320, width-30, 1)];
    xian7.backgroundColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1];
    UIView *xian8 = [[UIView alloc]initWithFrame:CGRectMake(15, 360, width-30, 1)];
    xian8.backgroundColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1];
    UIView *xian9 = [[UIView alloc]initWithFrame:CGRectMake(15, 400, width-30, 1)];
    xian9.backgroundColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1];
    UIView *xian10 = [[UIView alloc]initWithFrame:CGRectMake(15, 440, width-30, 1)];
    xian10.backgroundColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1];
    
    
    
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 100, 40)];
    lab1.font = zitifont;
    lab1.textColor = ziticolor;
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 45, 100, 40)];
    lab2.font = zitifont;
    lab2.textColor = ziticolor;
    UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(15, 85, 100, 40)];
    lab3.font = zitifont;
    lab3.textColor = ziticolor;
    UILabel *lab4 = [[UILabel alloc]initWithFrame:CGRectMake(15, 125, 100, 40)];
    lab4.font = zitifont;
    lab4.textColor = ziticolor;
    UILabel *lab5 = [[UILabel alloc]initWithFrame:CGRectMake(15, 165, 100, 40)];
    lab5.font = zitifont;
    lab5.textColor = ziticolor;
    UILabel *lab6 = [[UILabel alloc]initWithFrame:CGRectMake(15, 205, 100, 40)];
    lab6.font = zitifont;
    lab6.textColor = ziticolor;
    UILabel *lab7 = [[UILabel alloc]initWithFrame:CGRectMake(15, 245, 100, 40)];
    lab7.font = zitifont;
    lab7.textColor = ziticolor;
    UILabel *lab8 = [[UILabel alloc]initWithFrame:CGRectMake(15, 285, 100, 40)];
    lab8.font = zitifont;
    lab8.textColor = ziticolor;
    UILabel *lab9 = [[UILabel alloc]initWithFrame:CGRectMake(15, 325, 100, 40)];
    lab9.font = zitifont;
    lab9.textColor = ziticolor;
    UILabel *lab10 = [[UILabel alloc]initWithFrame:CGRectMake(15, 365, 100, 40)];
    lab10.font = zitifont;
    lab10.textColor = ziticolor;
    UILabel *lab11 = [[UILabel alloc]initWithFrame:CGRectMake(15, 405, 100, 40)];
    lab11.font = zitifont;
    lab11.textColor = ziticolor;
    UILabel *lab12 = [[UILabel alloc]initWithFrame:CGRectMake(15, 445, 100, 40)];
    lab12.font = zitifont;
    lab12.textColor = ziticolor;

  
    UILabel *you1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, width-30, 40)];
    you1.font = zitifont;
    you1.textColor = ziticolor;
    UILabel *you2 = [[UILabel alloc]initWithFrame:CGRectMake(120, 45, width-30, 40)];
    you2.font = zitifont;
    you2.textColor = ziticolor;
    UILabel *you3 = [[UILabel alloc]initWithFrame:CGRectMake(120, 85, width-30, 40)];
    you3.font = zitifont;
    you3.textColor = ziticolor;
    UILabel *you4 = [[UILabel alloc]initWithFrame:CGRectMake(120, 125, width-30, 40)];
    you4.font = zitifont;
    you4.textColor = ziticolor;
    UILabel *you5 = [[UILabel alloc]initWithFrame:CGRectMake(120, 165, width-30, 40)];
    you5.font = zitifont;
    you5.textColor = ziticolor;
    UILabel *you6 = [[UILabel alloc]initWithFrame:CGRectMake(120, 205, width-30, 40)];
    you6.font = zitifont;
    you6.textColor = ziticolor;
    UILabel *you7 = [[UILabel alloc]initWithFrame:CGRectMake(120, 245, width-30, 40)];
    you7.font = zitifont;
    you7.textColor = ziticolor;
    UILabel *you8 = [[UILabel alloc]initWithFrame:CGRectMake(120, 285, width-30, 40)];
    you8.font = zitifont;
    you8.textColor = ziticolor;
    UILabel *you9 = [[UILabel alloc]initWithFrame:CGRectMake(120, 325, width-30, 40)];
    you9.font = zitifont;
    you9.textColor = ziticolor;
    UILabel *you10 = [[UILabel alloc]initWithFrame:CGRectMake(120, 365, width-30, 40)];
    you10.font = zitifont;
    you10.textColor = ziticolor;
    UILabel *you11 = [[UILabel alloc]initWithFrame:CGRectMake(120, 405, width-30, 40)];
    you11.font = zitifont;
    you11.textColor = ziticolor;
    UILabel *you12 = [[UILabel alloc]initWithFrame:CGRectMake(120, 445, width-30, 40)];
    you12.font = zitifont;
    you12.textColor = ziticolor;

   

    if (zhi == 1)
    {
        
        
    }
    else if(zhi == 2)
    {
        lab1.text = @"产品id";
        lab2.text = @"产品erpid";
        lab3.text = @"产品名称";
        lab4.text = @"数量";
        lab5.text = @"退货数量";
        lab6.text = @"完成数量";
        lab7.text = @"取消数量";
        lab8.text = @"执行数量";
        lab9.text = @"申请预留数量";
        lab10.text = @"联系人价格";
        lab11.text = @"客户价格";
        lab12.text = @"总价";
        
        you1.text = [NSString stringWithFormat:@"%@",[orderDetailList [indexPath.row] objectForKey:@"productionsId"] ];
        you2.text = @"无返回数据";
        you3.text = [orderDetailList [indexPath.row] objectForKey:@"orderCode"];
        you4.text = [NSString stringWithFormat:@"%@",[orderDetailList [indexPath.row] objectForKey:@"amount"] ];
        you5.text = @"无返回数据";
        you6.text = @"无返回数据";
        you7.text = @"无返回数据";
        you8.text = @"无返回数据";
        you9.text = @"无返回数据";
        you10.text = [NSString stringWithFormat:@"%@",[orderDetailList [indexPath.row] objectForKey:@"favorablePrice"] ];
        you11.text = [NSString stringWithFormat:@"%@",[orderDetailList [indexPath.row] objectForKey:@"costPrice"] ];
        you12.text = [NSString stringWithFormat:@"%@",[orderDetailList [indexPath.row] objectForKey:@"totalPrice"] ];

    }

    [cell.contentView addSubview:lab1];
    [cell.contentView addSubview:lab2];
    [cell.contentView addSubview:lab3];
    [cell.contentView addSubview:lab4];
    [cell.contentView addSubview:lab5];
    [cell.contentView addSubview:lab6];
    [cell.contentView addSubview:lab7];
    [cell.contentView addSubview:lab8];
    [cell.contentView addSubview:lab9];
    [cell.contentView addSubview:lab10];
    [cell.contentView addSubview:lab11];
    [cell.contentView addSubview:lab12];
    
    [cell.contentView addSubview:you1];
    [cell.contentView addSubview:you2];
    [cell.contentView addSubview:you3];
    [cell.contentView addSubview:you4];
    [cell.contentView addSubview:you5];
    [cell.contentView addSubview:you6];
    [cell.contentView addSubview:you7];
    [cell.contentView addSubview:you8];
    [cell.contentView addSubview:you9];
    [cell.contentView addSubview:you10];
    [cell.contentView addSubview:you11];
    [cell.contentView addSubview:you12];
    
    
    
    
    
    
    [cell.contentView addSubview:xian];
    [cell.contentView addSubview:xian1];
    [cell.contentView addSubview:xian2];
    [cell.contentView addSubview:xian3];
    [cell.contentView addSubview:xian4];
    [cell.contentView addSubview:xian5];
    [cell.contentView addSubview:xian6];
    [cell.contentView addSubview:xian7];
    [cell.contentView addSubview:xian8];
    [cell.contentView addSubview:xian9];
    [cell.contentView addSubview:xian10];
    
    
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
    [passButton addTarget:self action:@selector(tongguo) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *backButton = [[UIButton alloc]init];
    backButton.frame = CGRectMake(width-width/2+10, 7, width/2-20, 30);
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
    
    //时间戳
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    NSDate *datenow = [NSDate date];
    NSString *nowtimeStr = [formatter stringFromDate:datenow];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)nowtimeStr];
    
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
      [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.navigationController.view];
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] intValue]==0000) {
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",error] andView:self.view];
        
    }];

    
}
-(void)tongguo
{
    NSString*loginUserId=[[yonghuziliao getUserInfo] objectForKey:@"id"];
    
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/order/audit";
    
    //时间戳
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    NSDate *datenow = [NSDate date];
    NSString *nowtimeStr = [formatter stringFromDate:datenow];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)nowtimeStr];
   
    
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
        
        [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.navigationController.view];
  
        if ([[responseObject objectForKey:@"code"] intValue]==0000) {
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",error] andView:self.view];
       
    }];

    
}

@end
