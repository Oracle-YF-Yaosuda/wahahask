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
#import "yonghuziliao.h"
#import "KeyboardToolBar.h"

@interface XiugaiViewController ()

@end

@implementation XiugaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //键盘添加完成
    [KeyboardToolBar registerKeyboardToolBar:self.oldpass];
    [KeyboardToolBar registerKeyboardToolBar:self.newpass];
    [KeyboardToolBar registerKeyboardToolBar:self.newpass1];
    
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==_oldpass) {
        [_oldpass resignFirstResponder];
        [_newpass becomeFirstResponder];
    }
    else if (textField==_newpass){
        [_newpass resignFirstResponder];
        [_newpass1 becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
    }
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
    //键盘消失
    [self.view endEditing:YES];
    if (![self Oldpassword:self.oldpass.text]) {
        [WarningBox warningBoxModeText:@"请输入旧密码" andView:self.view];
    }
    else if(![self NewpassWord:self.newpass.text]){
        [WarningBox warningBoxModeText:@"请输入新密码！" andView:self.view ];
    }
    else if (![self NewpassWord1:self.newpass1.text]){
        [WarningBox warningBoxModeText:@"请输入确认新密码！" andView:self.view ];
    }
    else if(![_newpass.text isEqualToString:_newpass1.text]){
        [WarningBox warningBoxModeText:@"新设密码不一致！" andView:self.view ];
    }
    
    
    else{
        NSString*loginName=[[yonghuziliao getUserInfo] objectForKey:@"loginName"];
        
        //userID    暂时不用改
        NSString * userID=@"0";
        
        //请求地址   地址不同 必须要改
        NSString * url =@"/modifypwd";
        [WarningBox warningBoxModeIndeterminate:@"正在修改密码..." andView:self.view];
        //时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString *timeSp = [NSString stringWithFormat:@"%.0f",a];
        
        //将上传对象转换为json格式字符串
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html", nil];
        SBJsonWriter* writer=[[SBJsonWriter alloc] init];
        //出入参数：
        NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:loginName,@"loginName",_oldpass.text,@"oldpassword",_newpass.text,@"newspassword", nil];
        
        NSString*jsonstring=[writer stringWithObject:datadic];
        
        //获取签名
        NSString*sign= [lianjie getSign:url :userID :jsonstring :timeSp ];
        
        NSString *url1=[NSString stringWithFormat:@"%@%@%@%@",service_host,app_name,api_url,url];

        NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:jsonstring,@"params",appkey, @"appkey",userID,@"userid",sign,@"sign",timeSp,@"timestamp", nil];
        [manager GET:url1 parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [WarningBox warningBoxHide:YES andView:self.view];
            @try
            {
                [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.navigationController. view];
                
                if ([[responseObject objectForKey:@"code"] intValue]==0000) {
                    [self.navigationController popViewControllerAnimated:YES];
                }

                
            }
            @catch (NSException * e) {
               
                [WarningBox warningBoxModeText:@"请检查你的网络连接!" andView:self.view];
               
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [WarningBox warningBoxHide:YES andView:self.view];
            
        }];
        
    }
    
}

- (IBAction)fanhui:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
