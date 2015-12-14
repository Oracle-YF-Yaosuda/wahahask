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
#import "XinxiViewController.h"
#import "lianjie.h"
#import "hongdingyi.h"
#import "AFHTTPRequestOperationManager.h"
#import "SBJson.h"
#import "WarningBox.h"
#import "yonghuziliao.h"

@interface ChaxunViewController ()
{
    CGFloat width;
    CGFloat height;
    NSArray*zuobian;
    NSArray*youbian;
    int zhi;
    
    int index;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UISegmentedControl *fenduan;
- (IBAction)fenduan:(id)sender;
@property(strong,nonatomic) UITextField *qian;
@property(strong,nonatomic) UITextField *hou;
@property(strong,nonatomic) UIButton *chaxun;
- (IBAction)queding:(id)sender;
- (IBAction)quxiao:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *picker;
@property (weak, nonatomic) IBOutlet UIView *beijing;

@end

@implementation ChaxunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//遵守 tableview 代理
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
//获取设备 宽和高
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;

//初始view隐藏
    self.beijing.hidden = YES;
    
    zhi = 1;
    
    [self huoququanbu];
   
}
//获取全部订单网络数据
-(void)huoququanbu
{
 NSString*loginUserID=[[yonghuziliao getUserInfo] objectForKey:@"id"];
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
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:loginUserID,@"loginUserId",@"2015-11-11",@"startDate",@"2015-11-21",@"endDate", @"2",@"state", @"1",@"pageNo",@"10",@"pageSize",nil];

    NSString*jsonstring=[writer stringWithObject:datadic];

    //获取签名
    NSString*sign= [lianjie postSign:url :userID :jsonstring :timeSp ];

    
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];

    NSLog(@"%@",url1);
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
 
    NSLog(@"dic============%@",dic);

    [manager POST:url1 parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"rerererere%@",responseObject);
        if ([[responseObject objectForKey:@"code"] intValue] == 0000) {
        
            NSDictionary *datadic = [responseObject valueForKey:@"data"];
            zuobian=[datadic objectForKey:@"orderList"];
            [_tableview reloadData];
         //   NSLog(@"zuo%@",zuobian);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",error] andView:self.view];

        NSLog(@"%@",error);
    }];
    
}
//获取待审核数据
-(void)huoqudaishenhe
{
    NSString*businesspersonId=[[yonghuziliao getUserInfo] objectForKey:@"businesspersonId"];
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString *url = @"/order/auditList";
    
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

    NSDictionary*datadic1=[NSDictionary dictionaryWithObjectsAndKeys:businesspersonId,@"businesspersonId",nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic1];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
    //NSLog(@"%@",sign);
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    //NSLog(@"url1%@",url1);
    //电泳借口需要上传的数据
    NSDictionary*dic1=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    

    [manager GET:url1 parameters:dic1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] intValue] == 0000) {
        
            NSDictionary *data1 = [responseObject valueForKey:@"data"];
            youbian=[data1 objectForKey:@"orderList"];
            [_tableview reloadData];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",error] andView:self.view];
        
        NSLog(@"%@",error);

    }];
    
    
}
//section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//2是返回的数据
    if (zhi == 1) {
        return zuobian.count;
    }
    else if (zhi == 2){
        return youbian.count;
    }
    return 0;
}
//cell
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (zhi == 1)
    {
        if (indexPath.section == 0)
        {
            return 80;
        }
        else
            return 325;
    }
    else if(zhi == 2)
    {
        return 325;
    }
    return 0;
}
//section 高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (zhi == 1) {
        if (section == 0) {
            return 15;
        }
        else
            return 30;
    }
    else if(zhi == 2){
        return 30;
    }
        return 0;
}
//编辑section内容
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
    baseView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4" alpha:1];
    
    UILabel *groupName = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 35)];
    groupName.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    groupName.text =@"订单信息";
    groupName.font = [UIFont systemFontOfSize:13];

    UIButton *tu = [[UIButton alloc] initWithFrame:CGRectMake(width-80, 10, 15, 15)];
    [tu setBackgroundImage:[UIImage imageNamed:@"@2x_dd_22_18.png"] forState:UIControlStateNormal];

    UILabel *shenhe = [[UILabel alloc]initWithFrame:CGRectMake(width-10-50, 0, 50, 35)];
    shenhe.text = @"已审核";
    shenhe.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    shenhe.font = [UIFont systemFontOfSize:13];

    
    [baseView addSubview:shenhe];
    [baseView addSubview:groupName];
    [baseView addSubview:tu];

    
    if (zhi == 1)
    {
        if (section == 0)
        {
            return nil;
        }else if(zhi == 2)
        {
            return baseView;
        }
    }
            return baseView;
}

//编辑cell内容
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *id1 =@"cell1";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 80, 30)];
    lab1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab1.font = [UIFont systemFontOfSize:13];
    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(20, 35, width-40, 1)];
    xian1.backgroundColor = [UIColor colorWithHexString:@"e4e4e4" alpha:1];
    UILabel *lab11 = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, width-40-80, 30)];
    lab11.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab11.font = [UIFont systemFontOfSize:13];
    lab11.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lab2 = [[UILabel  alloc]initWithFrame:CGRectMake(20, 45, 80, 30)];
    lab2.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab2.font = [UIFont systemFontOfSize:13];
    UIView *xian2 = [[UIView alloc]initWithFrame:CGRectMake(20, 75, width-40, 1)];
    xian2.backgroundColor = [UIColor colorWithHexString:@"e4e4e4" alpha:1];
    UILabel *lab21 = [[UILabel alloc]initWithFrame:CGRectMake(100, 45, width-40-80, 30)];
    lab21.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab21.font = [UIFont systemFontOfSize:13];
    lab21.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 85, 80, 30)];
    lab3.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab3.font = [UIFont systemFontOfSize:13];
    UIView *xian3 = [[UIView alloc]initWithFrame:CGRectMake(20, 115, width-40, 1)];
    xian3.backgroundColor = [UIColor colorWithHexString:@"e4e4e4" alpha:1];
    UILabel *lab31 = [[UILabel alloc]initWithFrame:CGRectMake(100, 85, width-40-80, 30)];
    lab31.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab31.font = [UIFont systemFontOfSize:13];
    lab31.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lab4 = [[UILabel alloc]initWithFrame:CGRectMake(20, 125, 80, 30)];
    lab4.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab4.font = [UIFont systemFontOfSize:13];
    UIView *xian4 = [[UIView alloc]initWithFrame:CGRectMake(20, 155, width-40, 1)];
    xian4.backgroundColor = [UIColor colorWithHexString:@"e4e4e4" alpha:1];
    UILabel *lab41 = [[UILabel alloc]initWithFrame:CGRectMake(100, 125, width-40-80, 30)];
    lab41.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab41.font = [UIFont systemFontOfSize:13];
    lab41.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lab5 = [[UILabel alloc]initWithFrame:CGRectMake(20, 165, 80, 30)];
    lab5.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab5.font = [UIFont systemFontOfSize:13];
    UIView *xian5 = [[UIView alloc]initWithFrame:CGRectMake(20, 195, width-40, 1)];
    xian5.backgroundColor = [UIColor colorWithHexString:@"e4e4e4" alpha:1];
    UILabel *lab51 = [[UILabel alloc]initWithFrame:CGRectMake(100, 165, width-40-80, 30)];
    lab51.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab51.font = [UIFont systemFontOfSize:13];
    lab51.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lab6 = [[UILabel alloc]initWithFrame:CGRectMake(20, 205, 80, 30)];
    lab6.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab6.font = [UIFont systemFontOfSize:13];
    UIView *xian6 = [[UIView alloc]initWithFrame:CGRectMake(20, 235, width-40, 1)];
    xian6.backgroundColor = [UIColor colorWithHexString:@"e4e4e4" alpha:1];
    UILabel *lab61 = [[UILabel alloc]initWithFrame:CGRectMake(100, 205, width-40-80, 30)];
    lab61.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab61.font = [UIFont systemFontOfSize:13];
    lab61.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lab7 = [[UILabel alloc]initWithFrame:CGRectMake(20, 245, 80, 30)];
    lab7.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab7.font = [UIFont systemFontOfSize:13];
    UIView *xian7 = [[UIView alloc]initWithFrame:CGRectMake(20, 275, width-40, 1)];
    xian7.backgroundColor = [UIColor colorWithHexString:@"e4e4e4" alpha:1];
    UILabel *lab71 = [[UILabel alloc]initWithFrame:CGRectMake(100, 245, width-40-80, 30)];
    lab71.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab71.font = [UIFont systemFontOfSize:13];
    lab71.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lab8 = [[UILabel alloc]initWithFrame:CGRectMake(20, 285, 80, 30)];
    lab8.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab8.font = [UIFont systemFontOfSize:13];
    UILabel *lab81 = [[UILabel alloc]initWithFrame:CGRectMake(100, 285, width-40-80, 30)];
    lab81.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    lab81.font = [UIFont systemFontOfSize:13];
    lab81.textAlignment = NSTextAlignmentCenter;

    lab1.text = @"订单编号:";
    lab11.text = @"还没显示";
    lab2.text = @"订单名称:";
    lab21.text = @"还没显示";
    lab3.text = @"客户姓名:";
    lab31.text = @"还没显示";
    lab4.text = @"商品数量:";
    lab41.text = @"还没显示";
    lab5.text = @"订单金额:";
    lab51.text = @"还没显示";
    lab6.text = @"优惠金额:";
    lab61.text = @"还没显示";
    lab7.text = @"下单时间:";
    lab71.text = @"还没显示";
    lab8.text = @"业务人员:";
    lab81.text = @"还没显示";

    
    if(zhi == 1)
    {
        if (indexPath.section == 0)
        {
            UILabel *CXSH = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, width, 21)];
            CXSH.text = @"查询时间";
            CXSH.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
            CXSH.font = [UIFont systemFontOfSize:14];
            
            self.qian = [[UITextField alloc]initWithFrame:CGRectMake(15, 42, (width- 60)/3, 30)];
            self.qian.placeholder = @" 请选择日期";
            self.qian.font = [UIFont systemFontOfSize:13];
            self.qian.layer.borderColor = [[UIColor colorWithHexString:@"0CB7FF" alpha:1] CGColor];
            self.qian.layer.borderWidth =1;
            self.qian.layer.cornerRadius = 5.0;
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(22+(width- 60)/3, 47, 20, 21)];
            label.text = @"至";
            label.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
            label.font = [UIFont systemFontOfSize:15];
            
            self.hou = [[UITextField alloc]initWithFrame:CGRectMake(45+(width- 60)/3, 42,  (width- 60)/3, 30)];
            self.hou.placeholder = @" 请选择日期";
            self.hou.font = [UIFont systemFontOfSize:13];
            self.hou.layer.borderColor = [[UIColor colorWithHexString:@"0CB7FF" alpha:1] CGColor];
            self.hou.layer.borderWidth =1;
            self.hou.layer.cornerRadius = 5.0;
            
            
            
            self.chaxun = [[UIButton alloc]initWithFrame:CGRectMake(45+(width- 60)/3*2+20, 42, (width- 60)/3-20, 30)];
            self.chaxun.backgroundColor = [UIColor colorWithHexString:@"0CB7FF" alpha:1];
            [self.chaxun setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.chaxun setTitle:@"查询" forState:UIControlStateNormal];
            self.chaxun.layer.cornerRadius = 5.0;
            self.chaxun.titleLabel.font = [UIFont systemFontOfSize:15];
            
            //textfield代理
            self.qian.delegate = self;
            self.hou.delegate = self;
            
            [cell.contentView addSubview:CXSH];
            [cell.contentView addSubview:self.qian];
            [cell.contentView addSubview:label];
            [cell.contentView addSubview:self.hou];
            [cell.contentView addSubview:self.chaxun];
            
            
        }else
        {
            UIImageView *imag = [[UIImageView alloc]initWithFrame:CGRectMake(5, 4, width-10, 317)];
            imag.image = [UIImage imageNamed:@"b.png"];
            
            UIImageView *imag1 = [[UIImageView alloc]initWithFrame:CGRectMake(width-60, 320-50, 60, 55)];
            imag1.image = [UIImage imageNamed:@"@2x_dd_22_22.png"];
            [cell.contentView addSubview:imag];
            [cell.contentView addSubview:imag1];

            
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
        }
    }
    else if (zhi == 2)
    {
        UIImageView *imag = [[UIImageView alloc]initWithFrame:CGRectMake(5, 4, width-10, 317)];
        imag.image = [UIImage imageNamed:@"a.png"];
        
        UIImageView *imag1 = [[UIImageView alloc]initWithFrame:CGRectMake(width-60, 320-50, 60, 55)];
        imag1.image = [UIImage imageNamed:@"@2x_dd_22_22_22.png"];
        [cell.contentView addSubview:imag];
        [cell.contentView addSubview:imag1];
//cell  赋值
        lab11.text=[NSString stringWithFormat:@"%@",[youbian[indexPath.section] objectForKey:@"orderCode"]];
        lab21.text=[NSString stringWithFormat:@"%@",[youbian[indexPath.section] objectForKey:@"orderName"]];
        lab31.text=[NSString stringWithFormat:@"%@",[[youbian[indexPath.section] objectForKey:@"customer"] objectForKey:@"customerName"]];
        lab41.text=[NSString stringWithFormat:@"%@",[youbian[indexPath.section] objectForKey:@"total"]];
        lab51.text=[NSString stringWithFormat:@"%@",[youbian[indexPath.section] objectForKey:@"amount"]];
        lab61.text=[NSString stringWithFormat:@"%@",[youbian[indexPath.section] objectForKey:@"discountAmount"]];
        lab71.text=[NSString stringWithFormat:@"%@",[youbian[indexPath.section] objectForKey:@"create_date"]];
        lab81.text=[NSString stringWithFormat:@"%@",[[youbian[indexPath.section] objectForKey:@"businessperson"] objectForKey:@"name"]];

       
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

    }
   
    //cell不可点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;

    
    return cell;
}
//cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (zhi == 2) {
        
        XinxiViewController*xinxi =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"xinxi"];
        xinxi.orderId=[NSString stringWithFormat:@"%@",[youbian[indexPath.section] objectForKey:@"id"]];
        [self.navigationController pushViewController:xinxi animated:YES];
        
    }
}
//textfield点击事件
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.qian){
        self.beijing.hidden = NO;
        zhi=3;
        return NO;
    }
    else if (textField == self.hou){
        self.beijing.hidden = NO;
        zhi=4;
        return NO;
    }
    
    return YES;
}


- (IBAction)fenduan:(id)sender {
    
    index = (int)_fenduan.selectedSegmentIndex;
    if (index == 0 ) {
        zhi = 1;
        self.qian.text=nil;
        self.hou.text=nil;
        [self.tableview reloadData];
    }
    else if(index == 1){
        zhi = 2;
        [self huoqudaishenhe];
        self.qian.text=nil;
        self.hou.text=nil;
        [self.tableview reloadData];
    }

}
- (IBAction)queding:(id)sender {
    //获取用户设置的时间
    NSDate *selected = [self.picker date];
    //创建一个日期格式器
    NSDateFormatter *dataFoematter = [[NSDateFormatter alloc]init];
    //为日期格式器设置格式字符串
    [dataFoematter setDateFormat:@"  yyyy-MM-dd"];
    //使用日期格式器格式化时间
    NSString *destDateString = [dataFoematter stringFromDate:selected];
    
    NSLog(@"%@",destDateString);
    
    self.beijing.hidden = YES;
    if (zhi == 3) {
        self.qian.text = destDateString;
    }
    else if (zhi == 4){
        self.hou.text = destDateString;
    }
}
- (IBAction)quxiao:(id)sender {
     self.beijing.hidden = YES;
}
@end
