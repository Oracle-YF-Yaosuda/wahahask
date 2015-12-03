//
//  yonghuziliao.m
//  Yaosuda
//
//  Created by 小狼 on 15/12/3.
//  Copyright © 2015年 sk. All rights reserved.
//

#import "yonghuziliao.h"

@implementation yonghuziliao
+(NSDictionary*)getUserInfo{
    NSString*path=[NSString stringWithFormat:@"%@/Documents/userInfo.plist",NSHomeDirectory()];
   
    NSDictionary*huyong=[NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary*UserInfo=[huyong valueForKey:@"user"];
    return UserInfo;
}
+(NSDictionary*)getZiJinzhanghao{
    NSString*path=[NSString stringWithFormat:@"%@/Documents/userInfo.plist",NSHomeDirectory()];
    
    NSDictionary*huyong=[NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary*zijinInfo=[huyong valueForKey:@"fundAccount"];
    return zijinInfo;
}

@end
