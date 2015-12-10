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

@interface XinxiViewController ()
{
    CGFloat width;
    CGFloat height;
    
    NSMutableArray *DDxinxi;
    NSMutableArray *DDshuju;
    
    NSMutableArray *SPxinxi;
    NSMutableArray *SPshuju;
    
    UISegmentedControl *segmentedControl;
    
    int index;
    int zhi;
    
    NSArray *productions;
    
    NSDictionary *data;
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
    
    [self huoqudingdanxinxi];
    [self huoqushangpinxinxi];
    [self array];
    [self fenduan];
    [self anniu];
    
}
//获取订单数据
-(void)huoqudingdanxinxi{
    
}
//获取商品信息数据
-(void)huoqushangpinxinxi{
    //userID    暂时不用改
    NSString *userID = @"0";
    //请求地址   地址不同 必须要改
    NSString *url = @"/prod/productions";
    //时间戳
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSDate *datenow = [NSDate date];
    NSString *nowtimeStr = [formatter stringFromDate:datenow];
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)nowtimeStr];
    //将上传对象转换为json格式字符串
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter *write = [[SBJsonWriter alloc]init];
    //出入参数：
    NSDictionary *datadic = [NSDictionary dictionaryWithObjectsAndKeys:@"52",@"productionsId", nil];
    
    NSString *jsonstring = [write stringWithObject:datadic];
    //获取签名
    NSString *sign = [lianjie getSign:url :userID :jsonstring :timeSp];
    NSString *url1 = [NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    NSLog(@"url111111111111111111%@",url1);
    //调用接口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    NSLog(@"dic============%@",dic);

    [manager GET:url1 parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        if ([[responseObject objectForKey:@"code"] intValue] == 0000) {
            data = [responseObject valueForKey:@"data"];
        
            productions = [data objectForKey:@"productions"];
            
            
            [SPshuju addObject:[[[responseObject objectForKey:@"data"] objectForKey:@"productions"] objectForKey:@"proName"]];
            [SPshuju addObject:[[[responseObject objectForKey:@"data"] objectForKey:@"productions"] objectForKey:@"erpProId"]];
            [SPshuju addObject:[[[responseObject objectForKey:@"data"] objectForKey:@"productions"] objectForKey:@"dosageForm"]];
            [SPshuju addObject:[[[responseObject objectForKey:@"data"] objectForKey:@"productions"] objectForKey:@"etalon"]];
            [SPshuju addObject:[[[responseObject objectForKey:@"data"] objectForKey:@"productions"] objectForKey:@"unit"]];
//            [SPshuju addObject:[[[responseObject objectForKey:@"data"] objectForKey:@"productions"] objectForKey:@"commonName"]];
//            [SPshuju addObject:[[[responseObject objectForKey:@"data"] objectForKey:@"productions"] objectForKey:@"commonCode"]];
//             [SPshuju addObject:[[[responseObject objectForKey:@"data"] objectForKey:@"productions"] objectForKey:@"provider"]];
            
            [self.tableview reloadData];
            
            NSLog(@"返回数据***********%@***********返回数据",data);
        }else{
            
            NSLog(@"%@",responseObject);
            NSLog(@"-----------------------%@",[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"msg"]]);

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",error] andView:self.view];
    }];
}
//创建分段控制器
-(void)fenduan{
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
-(void)change:(UISegmentedControl *)segmentControl{
    index = (int)segmentedControl.selectedSegmentIndex;
    if (index == 0 ) {
        zhi = 1;
        [self.tableview reloadData];
        NSLog(@"%d",zhi);
        
    }
    else if(index == 1){
        zhi = 2;
        [self.tableview reloadData];
        NSLog(@"%d",zhi);
    }

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
    
    DDxinxi = [[NSMutableArray alloc]init];
    [DDxinxi addObject:@"订单详情:"];
    [DDxinxi addObject:@"订单详情:"];
    [DDxinxi addObject:@"订单详情:"];
    [DDxinxi addObject:@"订单详情:"];
    [DDxinxi addObject:@"订单详情:"];
    
    DDshuju = [[NSMutableArray alloc]init];
    [DDshuju addObject:@"121212122222"];
    [DDshuju addObject:@"121212122222"];
    [DDshuju addObject:@"121212122222"];
    [DDshuju addObject:@"121212122222"];
    [DDshuju addObject:@"121212122222"];
   
   
    SPxinxi = [[NSMutableArray alloc]init];
    [SPxinxi addObject:@"商 品 名 称:"];
    [SPxinxi addObject:@"商 品 编 码:"];
    [SPxinxi addObject:@"剂         型:"];
    [SPxinxi addObject:@"规         格:"];
    [SPxinxi addObject:@"单         位:"];
//    [SPxinxi addObject:@"通   用   名:"];
//    [SPxinxi addObject:@"通用名编码:"];
//    [SPxinxi addObject:@"供   应   商:"];
    SPshuju = [[NSMutableArray alloc]init];
    
}
//tableview 分组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//tableview 行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (zhi == 1)
    {
        return DDxinxi.count;
    }
    else if (zhi == 2)
    {
        return SPxinxi.count;
    }
    return 0;
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

 
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(15, 39, width-30, 1)];
    xian.backgroundColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1];

    if (zhi == 1)//订单信息
    {
        UILabel *leftlabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, 100, 30)];
        leftlabel.textColor= [UIColor colorWithHexString:@"3c3c3c" alpha:1];
        leftlabel.font = [UIFont systemFontOfSize:13];
        leftlabel.text = DDxinxi[indexPath.row];
        
        UILabel *rightLable = [[UILabel alloc]initWithFrame:CGRectMake(80, 7, width-120, 30)];
        rightLable.textColor= [UIColor colorWithHexString:@"3c3c3c" alpha:1];
        rightLable.font = [UIFont systemFontOfSize:13];
        rightLable.text = DDshuju[indexPath.row];
        rightLable.textAlignment = NSTextAlignmentCenter;

        [cell.contentView addSubview:xian];
        [cell.contentView addSubview:leftlabel];
        [cell.contentView addSubview:rightLable];
    }
    else if (zhi == 2)  //商品信息
    {
        UILabel *leftlabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, 120, 30)];
        leftlabel1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
        leftlabel1.font = [UIFont systemFontOfSize:13];
        leftlabel1.text = SPxinxi[indexPath.row];
        
        UILabel *rightLable1 = [[UILabel alloc]initWithFrame:CGRectMake(80, 7, width-80, 30)];
        rightLable1.textColor= [UIColor colorWithHexString:@"3c3c3c" alpha:1];
        rightLable1.font = [UIFont systemFontOfSize:13];
        rightLable1.text = SPshuju[indexPath.row];
        rightLable1.textAlignment = NSTextAlignmentCenter;

        [cell.contentView addSubview:xian];
        [cell.contentView addSubview:leftlabel1];
        [cell.contentView addSubview:rightLable1];
    }
      
    //cell不可点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    return cell;
}
@end
