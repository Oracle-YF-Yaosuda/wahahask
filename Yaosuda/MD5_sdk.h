//
//  MD5_sdk.h
//  安邦盟信线上订单系统
//
//  Created by 小狼 on 15/11/26.
//  Copyright © 2015年 sk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
@interface MD5_sdk : NSObject
+ (NSString *)md5HexDigest:(NSString *)url ;

@end
