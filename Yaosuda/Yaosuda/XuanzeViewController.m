//
//  XuanzeViewController.m
//  Yaosuda
//
//  Created by oracle on 15/12/1.
//  Copyright © 2015年 sk. All rights reserved.
//

#import "XuanzeViewController.h"
#import "Color+Hex.h"
#import "XiangqingViewController.h"
#import "hongdingyi.h"
#import "AFHTTPRequestOperationManager.h"
#import "SBJsonWriter.h"
#import "WarningBox.h"
#import "lianjie.h"
#import "UIImageView+WebCache.h"
#import "XiadanViewController.h"


@interface XuanzeViewController ()
{
    
    CGFloat width;
    CGFloat height;
    UIButton *jian;
    UIButton *tianjia;
    UITextField *shuru;
    NSMutableArray*chuande;
    UITableViewCell *cell;
    NSArray*productionsList;
    
}
@property(strong , nonatomic)UIImageView *imagr;
@end

@implementation XuanzeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    chuande=[NSMutableArray array];
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(fanhui)];
    self.navigationItem.leftBarButtonItem = left;
  
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/prod/productionsList";
    
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
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"qtype",@"",@"proName",@"",@"proCatalog",@"1",@"pageNo",@"100",@"pageSize", nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
   
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    NSLog(@"url1==========================%@",url1);
    //电泳借口需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    NSLog(@"dic============%@",dic);
    [manager GET:url1 parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [WarningBox warningBoxHide:YES andView:self.view];
        
        
        //[WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
        
        if ([[responseObject objectForKey:@"code"] intValue]==0000) {
            NSDictionary*data=[responseObject valueForKey:@"data"];
            productionsList=[data objectForKey:@"productionsList"];
            
            [_tableview reloadData];
            
            
        }else{
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",error] andView:self.view];
        
    }];
    
    
    
}

-(void)fanhui{
 
       // 放到返回上一页面
        XiadanViewController*memeda=[[XiadanViewController alloc] init];
        self.trendDelegate= memeda;
        [self.trendDelegate passTrendValue:chuande];
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return productionsList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;//cell高度
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *id1 =@"mycell2";
    
    cell = [tableView cellForRowAtIndexPath:indexPath ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    _imagr = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,115 , 115)];
   
        
    NSString*tupian=[NSString stringWithFormat:@"%@",[productionsList[indexPath.row] objectForKey:@"pics"]];
        
   
        
    
    NSArray*arr=[tupian componentsSeparatedByString:@"|"];
    
    
    
    if (tupian.length<10) {
    
     _imagr.image=[UIImage imageNamed:@"1.jpg"];
    
    }
     else{
                 NSString*lian=[NSString stringWithFormat:@"%@",service_host];
         NSURL*url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",lian,arr[1]]];
         
         [_imagr sd_setImageWithURL:url  placeholderImage:[UIImage imageNamed:@"1.jpg"]];
     }
 
    
   
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(120, 5,60, 15)];
    name.font= [UIFont systemFontOfSize:12];
    name.text = @"商品名称:";
    name.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    UILabel *name1 = [[UILabel alloc]initWithFrame:CGRectMake(180, 5, width-180, 15)];
    name1.font= [UIFont systemFontOfSize:12];
    name1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];

    
    UILabel *changjia = [[UILabel alloc]initWithFrame:CGRectMake(120, 25, 60, 15)];
    changjia.font= [UIFont systemFontOfSize:12];
    changjia.text = @"生产厂家:";
    changjia.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    UILabel *changjia1 = [[UILabel alloc]initWithFrame:CGRectMake(180, 26, width-180, 15)];
    changjia1.font= [UIFont systemFontOfSize:12];
    changjia1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];

    
    
    
    
    UILabel *guige = [[UILabel alloc]initWithFrame:CGRectMake(120, 45, 60, 15)];
    guige.font= [UIFont systemFontOfSize:12];
    guige.text = @"规       格:";
    guige.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    UILabel *guige1 = [[UILabel alloc]initWithFrame:CGRectMake(180, 45, 60, 15)];
    guige1.font= [UIFont systemFontOfSize:12];
    guige1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];

    
    
    tianjia = [[UIButton alloc]initWithFrame:CGRectMake(width-60, 45, 50, 30)];
    [tianjia setTag:indexPath.row+2000];
    [tianjia setImage:[UIImage imageNamed:@"@2x_sp_07.png"] forState:UIControlStateNormal];
    [tianjia addTarget:self action:@selector(tianjia) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *danwei = [[UILabel alloc]initWithFrame:CGRectMake(120, 65, 60, 15)];
    danwei.font= [UIFont systemFontOfSize:12];
    danwei.text = @"单       位:";
    danwei.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    UILabel *danwei1 = [[UILabel alloc]initWithFrame:CGRectMake(180, 65, 60, 15)];
    danwei1.font= [UIFont systemFontOfSize:12];
    danwei1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    
    
    
    
    
    UILabel *shuliang = [[UILabel alloc]initWithFrame:CGRectMake(120, 90, 60, 15)];
    shuliang.font= [UIFont systemFontOfSize:12];
    shuliang.text = @"下单数量:";
    shuliang.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    jian = [[UIButton alloc]initWithFrame:CGRectMake(180, 87, 20, 20)];
    [jian setImage:[UIImage imageNamed:@"@2x_sp_11.png"] forState:UIControlStateNormal];
    [jian addTarget:self action:@selector(jian) forControlEvents:UIControlEventTouchUpInside];
    UIButton *jia = [[UIButton alloc]initWithFrame:CGRectMake(225, 87, 20, 20)];
    [jia setImage:[UIImage imageNamed:@"@2x_sp_13.png"] forState:UIControlStateNormal];
    [jia addTarget:self action:@selector(jia) forControlEvents:UIControlEventTouchUpInside];
    shuru = [[UITextField alloc]initWithFrame:CGRectMake(201, 87, 23,20)];
    shuru.text = @"0";
    [shuru setTag:indexPath.row+1000];
    shuru.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    shuru.textAlignment = NSTextAlignmentCenter;
    shuru.borderStyle=UITextBorderStyleNone;
    
    
    UIButton *gengduo= [[UIButton alloc]initWithFrame:CGRectMake(271, 87, 30, 20)];
   
    [gengduo setImage:[UIImage imageNamed:@"@2x_sp_16.png"] forState:UIControlStateNormal];
   
    name1.text = [NSString stringWithFormat:@"%@",[productionsList[indexPath.row] objectForKey:@"proName" ]];
    changjia1.text = [NSString stringWithFormat:@"%@",[productionsList[indexPath.row] objectForKey:@"proEnterprise" ]];
    guige1.text =[NSString stringWithFormat:@"%@",[productionsList[indexPath.row] objectForKey:@"etalon" ]];
    danwei1.text = [NSString stringWithFormat:@"%@",[productionsList[indexPath.row] objectForKey:@"unit" ]];
    
    
    
    
    
    [cell.contentView addSubview:_imagr];

    [cell.contentView addSubview:name];
    [cell.contentView addSubview:changjia];
    [cell.contentView addSubview:guige];
    [cell.contentView addSubview:danwei];
    [cell.contentView addSubview:shuliang];
    
    [cell.contentView addSubview:name1];
    [cell.contentView addSubview:changjia1];
    [cell.contentView addSubview:guige1];
    [cell.contentView addSubview:danwei1];

    [cell.contentView addSubview:tianjia];
    
    [cell.contentView addSubview:jia];
    [cell.contentView addSubview:jian];
    
    [cell.contentView addSubview:shuru];
    
    [cell.contentView addSubview:gengduo];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XiangqingViewController *xiangqing = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"xiangqing"];
    xiangqing.shangID=[NSString stringWithFormat:@"%ld",indexPath.row];
    [self.navigationController pushViewController:xiangqing animated:YES];
}
#pragma mark - button点击事件
-(void)tianjia{
    NSMutableDictionary*dd=[NSMutableDictionary dictionaryWithDictionary:productionsList[tianjia.tag-2000]];
    UITextField*xixi=(UITextField*)[cell viewWithTag :shuru.tag-1000];
    [dd setValue:shuru.text forKey:@"shuliang"];
    NSLog(@"%@",xixi.text);
    [chuande addObject:dd];
}
-(void)jia{
    
    
    
    
}

-(void)jian{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
