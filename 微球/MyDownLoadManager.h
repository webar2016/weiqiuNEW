//
//  MyDownLoadManager.h
//  微球
//
//  Created by 贾玉斌 on 16/2/29.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

typedef void(^SuccessBlock)(id representData);
typedef void(^FailureBlock)(NSString *error);
typedef void(^FieldDataBlock)(id<AFMultipartFormData>formData);
typedef void(^ProgressBlock)(NSProgress *FieldDataBlock);




@interface MyDownLoadManager : NSObject

+(void)getNsurl:(NSString *)str whenSuccess:(SuccessBlock)success andFailure:(FailureBlock)failure;

+(void)starRequestWithUrlString:(NSString *)urlStr whenSuccess:(SuccessBlock)success andFailure:(FailureBlock)failure;
//首页数据
//+(void) getMainMenuDataWithPage:(NSInteger)page whenSuccess:(SuccessBlock)success andFailure:(FailureBlock)failure;

+(void)getNsurl:(NSString *)str withParameters:(id)parameters whenSuccess:(SuccessBlock)success andFailure:(FailureBlock)failure;

+(void)postUrl:(NSString *)str withParameters:(id)parameters fileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType whenProgress:(ProgressBlock)progress andSuccess:(SuccessBlock)success andFailure:(FailureBlock)failure;

+(void)postUrl:(NSString *)str withParameters:(id)parameters  whenProgress:(ProgressBlock)progress andSuccess:(SuccessBlock)success andFailure:(FailureBlock)failure;


//
+(void)postUserInfoUrl:(NSString *)str withParameters:(id)parameters fieldData:(FieldDataBlock)fieldData whenProgress:(ProgressBlock)progress andSuccess:(SuccessBlock)success andFailure:(FailureBlock)failure;
@end
