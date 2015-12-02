//
//  MD5_sdk.m
//  安邦盟信线上订单系统
//
//  Created by 小狼 on 15/11/26.
//  Copyright © 2015年 sk. All rights reserved.
//

#import "MD5_sdk.h"

@implementation MD5_sdk
+ (NSString *)md5HexDigest:(NSString *)url
{
    const char *original_str = [url UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
    
}
@end
