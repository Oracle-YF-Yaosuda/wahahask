//
//  XiadanViewController.m
//  Yaosuda
//
//  Created by oracle on 15/11/30.
//  Copyright © 2015年 sk. All rights reserved.
//

#import "XiadanViewController.h"
#import "Color+Hex.h"
#import "XiadanbianjiViewController.h"
#import "KehuViewController.h"
#import "QuerenViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "WarningBox.h"
#import "yonghuziliao.h"
#import "SBJsonWriter.h"
#import "lianjie.h"
#import "hongdingyi.h"


@interface XiadanViewController ()
{
    CGFloat width;
    CGFloat height;
    NSArray*jieshou;
    UITableViewCell *cell;
    NSMutableArray*jiage;
}

@end

@implementation XiadanViewController
-(void)passTrendValue:(NSArray *)values{
    
    NSString *path =[NSHomeDirectory() stringByAppendingString:@"/Documents/xiadanmingxi.plist"];
    NSFileManager*fm=[NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        [values writeToFile:path atomically:YES];
    }
    
    else{
        
        NSMutableArray*arr=[NSMutableArray arrayWithContentsOfFile:path];
        NSArray*guo=[NSArray arrayWithArray:values];
        for (NSDictionary*d in guo) {
            [arr addObject:d];
        }
        [arr writeToFile:path atomically:YES];
    }
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewDidLoad];
    //接取商品价格
    jiage=[NSMutableArray array];
    //接受订单数据
    NSString*path=[NSString stringWithFormat:@"%@/Documents/xiadanmingxi.plist",NSHomeDirectory()];
    jieshou=[[NSMutableArray alloc] init];
    jieshou=[NSArray arrayWithContentsOfFile:path];
    //接受客户数据
    NSString*pathkehu=[NSString stringWithFormat:@"%@/Documents/kehuxinxi.plist",NSHomeDirectory()];
    NSDictionary*kehuxinxi=[NSDictionary dictionaryWithContentsOfFile:pathkehu];
    
    
    NSFileManager*fm=[NSFileManager defaultManager];
    if (![fm fileExistsAtPath:pathkehu]) {
        jieshou=[NSArray array];
    }
    else{
        _kehumingzi.text=[[NSDictionary dictionaryWithContentsOfFile:pathkehu] objectForKey:@"customerName"];
    
     
    //用户id
    NSString*businesspersonId=[[yonghuziliao getUserInfo] objectForKey:@"businesspersonId"];
    //提取客户id
    NSString*kehuID=[NSString stringWithFormat:@"%@",[kehuxinxi objectForKey:@"id"]];
    if (kehuID!=nil&&![kehuID isEqual:[NSNull null]]) {
        
    
    for (int i=0; i<jieshou.count; i++) {
      
        //userID    暂时不用改
        NSString * userID=@"0";
        
        //请求地址   地址不同 必须要改
        NSString * url =@"/prod/priceByNum";
        
        //时间戳
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        NSDate *datenow = [NSDate date];
        NSString *nowtimeStr = [formatter stringFromDate:datenow];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)nowtimeStr];
        
        
        //将上传对象转换为json格式字符串
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
        SBJsonWriter* writer=[[SBJsonWriter alloc] init];
        //数量
        NSString*acount=[NSString stringWithFormat:@"%@",[jieshou[i] objectForKey:@"shuliang"]];
        //商品id
        NSString*shangpinID= [ NSString stringWithFormat:@"%@",[jieshou[i] objectForKey:@"id"]];
        //出入参数：
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",businesspersonId],@"businesspersonId",acount,@"acount",kehuID,@"customerId",shangpinID,@"productionsId", nil];
        
        NSString*jsonstring=[writer stringWithObject:datadic];
        
        //获取签名
        NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
        NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
        
        //需要上传的数据
        NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
        [manager GET:url1 parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                NSDictionary*data=[responseObject valueForKey:@"data"];
                [jiage addObject:[data objectForKey:@"customerPrice"]];
                         }
            [_tableview reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [WarningBox warningBoxHide:YES andView:self.view];
            [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",error] andView:self.view];
                   }];
       }
      }
     }
     
}
- (void)viewDidLoad {
    
    [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(tiao)];
    self.navigationItem.rightBarButtonItem = right;
    
}

-(void)tiao{
    
    XiadanbianjiViewController*xiadan =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"xiadanbianji"];
    [self.navigationController pushViewController:xiadan animated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   
    return jieshou.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;//section高度
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;//cell高度
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *id1 =@"mycell";
   
    
    cell = [tableView cellForRowAtIndexPath:indexPath ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id1];
    }
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 80, 30)];
    name.text = @"商品名称:";
    name.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    name.font = [UIFont systemFontOfSize:15];
    
    UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(0, 35, width, 1)];
    xian.backgroundColor = [UIColor colorWithHexString:@"e4e4e4" alpha:1];
    
    UILabel *name1 = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, width-40-80, 30 )];
    name1.text = [NSString stringWithFormat:@"%@", [jieshou[indexPath.section] objectForKey:@"proName"]];
    name1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    name1.font = [UIFont systemFontOfSize:15];
    name1.textAlignment = NSTextAlignmentCenter;
    
    
    
    
    UILabel *shuliang = [[UILabel alloc]initWithFrame:CGRectMake(20, 45, 80, 30)];
    shuliang.text = @"商品数量:";
    shuliang.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    shuliang.font = [UIFont systemFontOfSize:15];
    
    UIView *xian1 = [[UIView alloc]initWithFrame:CGRectMake(0, 75, width, 1)];
    xian1.backgroundColor = [UIColor colorWithHexString:@"e4e4e4" alpha:1];
    
    UILabel *shuliang1 = [[UILabel alloc]initWithFrame:CGRectMake(100, 45, width-40-80, 30 )];
    shuliang1.text = [NSString stringWithFormat:@"%@",[jieshou[indexPath.section] objectForKey:@"shuliang"]];
    shuliang1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    shuliang1.font = [UIFont systemFontOfSize:15];
    shuliang1.textAlignment = NSTextAlignmentCenter;
    
    
    
    
    
    
    
    UILabel *danjia = [[UILabel alloc]initWithFrame:CGRectMake(20, 85, 80, 30)];
    danjia.text = @"商品总价:";
    danjia.textColor = [UIColor colorWithHexString:@"646464" alpha:1];
    danjia.font = [UIFont systemFontOfSize:15];
    
    UILabel *danjia1 = [[UILabel alloc]initWithFrame:CGRectMake(100, 85, width-40-80, 30 )];
  
    if (jiage.count!=jieshou.count) {
          danjia1.text=@"?";
    }
    else
    danjia1.text = [NSString stringWithFormat:@"%@",jiage[indexPath.section]];
    danjia1.textColor = [UIColor colorWithHexString:@"3c3c3c" alpha:1];
    danjia1.font = [UIFont systemFontOfSize:15];
    danjia1.textAlignment = NSTextAlignmentCenter;
    
    
    [cell.contentView addSubview:name];
    [cell.contentView addSubview:name1];
    [cell.contentView addSubview:xian];
    
    [cell.contentView addSubview:shuliang];
    [cell.contentView addSubview:shuliang1];
    [cell.contentView addSubview:xian1];
    
    [cell.contentView addSubview:danjia];
    [cell.contentView addSubview:danjia1];
    
    //cell不可点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //线消失
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏滑动条
    self.tableview.showsVerticalScrollIndicator =NO;
    
    return cell;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)fanhui:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)queren:(id)sender {
    if (jiage.count==0) {
        [WarningBox warningBoxModeText:@"请选择商品及客户！" andView:self.view];
    }else{
    float m;
    for (int i=0; i<jiage.count; i++) {
        m+=[jiage[i] floatValue];
       
    }
    QuerenViewController *qu = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"queren"];
    qu.meme =[NSString stringWithFormat:@"%.2f元",m];
    [self.navigationController pushViewController:qu animated:YES];
    }
}
@end
