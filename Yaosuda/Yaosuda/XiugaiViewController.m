//
//  XiugaiViewController.m
//  Yaosuda
//
//  Created by oracle on 15/12/1.
//  Copyright © 2015年 sk. All rights reserved.
//

#import "XiugaiViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "SBJsonWriter.h"
#import "lianjie.h"
#import "hongdingyi.h"
#import "WarningBox.h"

@interface XiugaiViewController ()

@end

@implementation XiugaiViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self daili];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//代理协议
-(void)daili{
    
    self.oldpass.delegate = self;
    self.newpass.delegate = self;
    self.newpass1.delegate = self;
//button圆角
    self.queren.layer.cornerRadius = 5.0;
}

-(void)waringBox:(NSString*)tt{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES ];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = tt;
    hud.yOffset = 0;
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud hide:YES afterDelay:2];
    
}

-(BOOL)Oldpassword:(NSString *)chusheng{
    
    if (self.oldpass.text.length==0) {
        return NO;
    }
    return YES;
    
}
-(BOOL)NewpassWord:(NSString *)newpass{
    if (self.newpass.text.length==0) {
        return NO;
    }
    return YES;
}
-(BOOL)NewpassWord1:(NSString *)newpass1{
    if (self.newpass1.text.length==0) {
        return NO;
    }
    return YES;
}

- (IBAction)queren:(id)sender {
    
//    if (self.oldpass.text.length > 0 && self.newpass.text.length > 0 && self.newpass1.text.length > 0) {
//        if (![self Oldpassword:self.oldpass.text]) {
//            [self waringBox:@"请输入旧密码"];
//        }
//        else if(![self NewpassWord:self.newpass.text]){
//            [self waringBox:@"请输入新密码"];
//        }
//        else if(![self NewpassWord1:self.newpass1.text]){
//            [self waringBox:@"请再次输入新密码"];
//        }
//    }else if([self Oldpassword:self.oldpass.text] && [self NewpassWord:self.newpass.text] && [self NewpassWord1:self.newpass1.text]){
//    
//        if (self.oldpass.text!=nil && self.newpass.text!=nil && self.newpass1.text!=nil) {
    
    //键盘消失
    [self.view endEditing:YES];
    
    //userID    暂时不用改
    NSString * userID=@"0";
    
    //请求地址   地址不同 必须要改
    NSString * url =@"/login";
    
    //时间戳
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    NSDate *datenow = [NSDate date];
    NSString *nowtimeStr = [formatter stringFromDate:datenow];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)nowtimeStr];
    NSLog(@"时间戳:%@",timeSp); //时间戳的值

    //将上传对象转换为json格式字符串
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
    SBJsonWriter* writer=[[SBJsonWriter alloc] init];
    //出入参数：
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"1008",@"loginName",@"admin",@"oldpassword",@"111111",@"newspassword", nil];

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
        if ([[responseObject objectForKey:@"code"] intValue] == 0000) {
            [WarningBox warningBoxHide:YES andView:self.view];
            
            
            NSLog(@"%@",[responseObject objectForKey:@"msg"]);
            
            
            NSLog(@"%@",[ NSString stringWithFormat:@"%@",responseObject]);
            
            [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
        }
        else
            NSLog(@"%@",[responseObject objectForKey:@"msg"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",error] andView:self.view];
    }];
       // }
//    }
//    else{
//        [self waringBox:@"请输入密码"];

 //   }
}
@end
