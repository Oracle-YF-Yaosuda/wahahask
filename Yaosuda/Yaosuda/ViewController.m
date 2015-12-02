//
//  ViewController.m
//  Yaosuda
//
//  Created by oracle on 15/11/30.
//  Copyright © 2015年 sk. All rights reserved.
//

#import "ViewController.h"
#import "WarningBox.h"
#import "SBJsonWriter.h"
#import "AFHTTPRequestOperationManager.h"
#import "MD5_sdk.h"
#import "ChaxunViewController.h"


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
    
    
    if (textField == self.user) {
        
        int len = (int)self.user.text.length;
        if (len > 10 && string.length >0) {
            if (![self isMobileNumberClassification:self.user.text]) {
                [self.view endEditing:YES];
                [WarningBox warningBoxModeText:@"请输入正确的手机号" andView:self.view];
            }
            return NO;
        }
        BOOL basic = [self panduanshuzi:string];
        return basic;
    }
    else if (textField == self.pass){
        
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
    
    NSString *password = @"^[a-zA-Z0-9]{6,16}";
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


//判断手机号是否正确
-(BOOL)isMobileNumberClassification:(NSString *)mobile{
    if (mobile.length != 11){
        
        return NO;
        
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        
        //        //手机号正则表达式
        //        NSString *mm = @"[1][34578]\\d{9}";
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma make - 两个按钮实现的功能


- (IBAction)denglu:(UIButton *)sender {
    [self.view endEditing:YES];
    /**
     *  获取手机唯一标识～
     */
    /**/
    CFUUIDRef cfuuid =CFUUIDCreate(kCFAllocatorDefault);
    NSString *cfuuidString =(NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));/**/
    
    
    
    NSLog(@"获取手机唯一标识为:%@",cfuuidString);
    
    
    //    if (self.xluser.text.length > 0 && self.xlmima.text.length > 0) {
    if (![self isMobileNumberClassification:self.user.text])
    {
        [WarningBox warningBoxModeText:@"请输入正确的手机号!" andView:self.view];
    }
    else if(![self validatePass:self.pass.text])
    {
        [WarningBox warningBoxModeText:@"密码格式不对哟-.-!" andView:self.view];
    }
    else
    {
        
        [WarningBox warningBoxModeIndeterminate:@"登录中..." andView:self.view];
        
        
        
        
        
        
        
        
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:self.user.text,@"loginName",/*密码加密*/[MD5_sdk md5HexDigest: self.pass.text],@"password", nil];
        
        SBJsonWriter *write = [[SBJsonWriter alloc]init];
        NSString *jsonString = [write stringWithObject:data];
        
        NSString *url = [NSString stringWithFormat:@"   %@",jsonString];
        NSString *url2 = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
        
        manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain",@"text/html",nil];
        
        
        
        [manger POST:url2 parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [WarningBox warningBoxHide:YES andView:self.view];
            if ([[responseObject valueForKey:@"flag"] integerValue] == 1) {
                
                
                
                
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {[WarningBox warningBoxHide:YES andView:self.view];
            
            [WarningBox warningBoxModeText:@"登录失败" andView:self.view];
            
            
        }];
        
        
        
        
        /**
         *  放在接口返回成功的地方
         */
        ChaxunViewController*chaxun=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"chaxun"];
        [self.navigationController pushViewController:chaxun animated:YES];
        
    }
    //    }
    //    else
    //    {
    //        [WarningBox warningBoxModeText:@"输入的内容不能为空" andView:self.view];
    //    }
}

- (IBAction)genghuan:(UIButton *)sender {
    [self.view endEditing:YES];
    
    UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"更换登录设备,需要联系系统管理员,是否要拨打电话?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction*action1=[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
