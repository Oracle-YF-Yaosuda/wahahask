//
//  QuerenViewController.m
//  Yaosuda
//
//  Created by suokun on 15/12/14.
//  Copyright © 2015年 sk. All rights reserved.
//

#import "QuerenViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "SBJsonWriter.h"
#import "hongdingyi.h"
#import "yonghuziliao.h"
#import "WarningBox.h"
#import "lianjie.h"

@interface QuerenViewController (){
    NSMutableArray*shangid;
    NSMutableArray*shuliangji;
    NSString*businesspersonId;
    NSString*customerId;
    NSString*loginUserId;
}
- (IBAction)tijiao:(id)sender;
@end


@implementation QuerenViewController
- (void)viewDidLoad {
     [super viewDidLoad];
    _yingfu.text=_meme;
    _shouhuoren.text=_haha;
   
   
    loginUserId= [NSString stringWithFormat:@"%@",[[yonghuziliao getUserInfo] objectForKey:@"id"]];
    businesspersonId=[NSString stringWithFormat:@"%@",[[yonghuziliao getUserInfo] objectForKey:@"businesspersonId"]];
    shangid=[NSMutableArray array];
    shuliangji=[NSMutableArray array];
    NSString*path=[NSString stringWithFormat:@"%@/Documents/xiadanmingxi.plist",NSHomeDirectory()];
    NSArray*arr=[NSArray arrayWithContentsOfFile:path];
    for (int i=0; i<arr.count; i++) {
       [ shangid addObject:[NSString stringWithFormat:@"%@",[arr[i] objectForKey:@"id"]]];
        [shuliangji addObject:[arr[i] objectForKey:@"shuliang"]];
    }
    NSString*pathkehu=[NSString stringWithFormat:@"%@/Documents/kehuxinxi.plist",NSHomeDirectory()];
    NSDictionary*kehu=[NSDictionary dictionaryWithContentsOfFile:pathkehu];
    customerId=[NSString stringWithFormat:@"%@",[kehu objectForKey:@"id"]];
 
}
- (IBAction)tijiao:(id)sender {
    
       
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/order/submit";
    
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
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"orderType",businesspersonId,@"businesspersonId",@"1",@"fromWhere",customerId,@"customerId",shangid,@"ids",loginUserId,@"loginUserId",shuliangji,@"nums", nil];
    
    NSString*jsonstring=[writer stringWithObject:datadic];
    
    //获取签名
    NSString*sign= [lianjie postSign:url :userID :jsonstring :timeSp ];
  
    NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];
    
    
    //需要上传的数据
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
    NSLog(@"***************%@",dic);
    [manager POST:url1 parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
       if ([[responseObject objectForKey:@"code"] intValue]==0000) {
            [WarningBox warningBoxModeText:@"下单成功" andView:self.view];
            NSFileManager *defaultManager;
            defaultManager = [NSFileManager defaultManager];
            NSString*path=[NSString stringWithFormat:@"%@/Documents/kehuxinxi.plist",NSHomeDirectory()];
            NSString*path1=[NSString stringWithFormat:@"%@/Documents/xiadanmingxi.plist",NSHomeDirectory()];
            [defaultManager removeItemAtPath:path error:NULL];
            [defaultManager removeItemAtPath:path1 error:NULL];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",error] andView:self.view];
        NSLog(@"%@",[NSString stringWithFormat:@"%@",error]);
    }];
}
- (IBAction)fanhui:(id)sender {
    
      [self.navigationController popViewControllerAnimated:YES];
}
@end