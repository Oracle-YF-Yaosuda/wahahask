//
//  ViewController.m
//  Yaosuda
//
//  Created by oracle on 15/11/30.
//  Copyright © 2015年 sk. All rights reserved.
//

#import "ViewController.h"

#import "navigation.h"
#import "WarningBox.h"
#import "lianjie.h"
#import "hongdingyi.h"
#import "SBJsonWriter.h"
#import "AFHTTPRequestOperationManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user.delegate = self;
    self.pass.delegate = self;
//设置圆角
    self.diview.layer.cornerRadius = 5.0;
    self.denglu.layer.cornerRadius = 5.0;
    
  
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma make - textfield Delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
   
    if (textField == self.pass){
        
        int len = (int)self.pass.text.length;
        if (len >10 && string.length > 0) {
            if (![self validatePass:self.pass.text]) {
                [WarningBox warningBoxModeText:@"请输入长度为6-10之间的密码" andView:self.view];
            }
            return NO;
        }
        return YES;
    }
    return YES;
}
//判断密码
- (BOOL) validatePass:(NSString *)pass{
    
    NSString *password = @"^[a-zA-Z0-9]{5,16}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", password];
    BOOL isMatch = [pred evaluateWithObject:pass];
    return isMatch;
    
}

-(BOOL)panduanshuzi:(NSString *)panduan{
    
    NSCharacterSet *xs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filter = [[panduan componentsSeparatedByCharactersInSet:xs] componentsJoinedByString:@""];
    BOOL basic = [panduan isEqualToString:filter];
    return basic;
    
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma make - 两个按钮实现的功能


- (IBAction)denglu:(UIButton *)sender {
    //键盘消失
    [self.view endEditing:YES];
   
 
        
    [WarningBox warningBoxModeIndeterminate:@"登录中..." andView:self.view];
        
        
    
    //获取设备唯一码
    NSString *imei = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSLog(@"imei－－－－》%@",imei);
    
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
    NSDictionary*datadic=[NSDictionary dictionaryWithObjectsAndKeys:@"chengdu",@"loginName",@"admin",@"password",@"867246020234069"/*imei*/,@"imei", nil];
    
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
        [WarningBox warningBoxHide:YES andView:self.view];
        
        
        NSLog(@"%@",[responseObject objectForKey:@"msg"]);
        
        
        NSLog(@"%@",[ NSString stringWithFormat:@"%@",responseObject]);
        
        [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] andView:self.view];
        
        if ([[responseObject objectForKey:@"code"] intValue]==0000) {
            NSString*path=[NSString stringWithFormat:@"%@/Documents/userInfo.plist",NSHomeDirectory()];
            NSLog(@"%@",[NSString stringWithFormat:@"%@",NSHomeDirectory()]);
            
            NSDictionary*datadic=[responseObject valueForKey:@"data"];
            [datadic writeToFile:path atomically:YES];
            
           navigation*chaxun=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"navigation"];
            [self presentViewController:chaxun animated:YES completion:^{
               [self setModalTransitionStyle: UIModalTransitionStyleCrossDissolve];
            }];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WarningBox warningBoxHide:YES andView:self.view];
        [WarningBox warningBoxModeText:[NSString stringWithFormat:@"%@",error] andView:self.view];
        NSLog(@"%@",[NSString stringWithFormat:@"%@", error]);
       
    }];
    
}

- (IBAction)genghuan:(UIButton *)sender {
    [self.view endEditing:YES];
    
    UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"更换登录设备,需要联系系统管理员,是否要拨打电话?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction*action1=[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //调用手机拨打电话
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://18828888888"]];
    }];
    UIAlertAction*action2=[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [WarningBox warningBoxModeText:@"不打电话你乱按啥！！！" andView:self.view];
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    
}

@end
