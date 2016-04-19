//
//  MyDownLoadManager.m
//  微球
//
//  Created by 贾玉斌 on 16/2/29.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "MyDownLoadManager.h"





@implementation MyDownLoadManager


+(void)getNsurl:(NSString *)str whenSuccess:(SuccessBlock)success andFailure:(FailureBlock)failure
{
    NSString *urlString=str;
    [MyDownLoadManager starRequestWithUrlString:urlString whenSuccess:success andFailure:failure];
    
}

+(void)starRequestWithUrlString:(NSString *)urlStr whenSuccess:(SuccessBlock)success andFailure:(FailureBlock)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:[WBUserDefaults deviceToken] forHTTPHeaderField:@"Authorization"];
   // NSLog(@"deviceToken %@",[WBUserDefaults deviceToken]);
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        
        success(responseObject);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
    
}

+(void)getNsurl:(NSString *)str withParameters:(id)parameters whenSuccess:(SuccessBlock)success andFailure:(FailureBlock)failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:[WBUserDefaults deviceToken] forHTTPHeaderField:@"Authorization"];
    [manager GET:str parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}



+(void)postUrl:(NSString *)str withParameters:(id)parameters fileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType whenProgress:(ProgressBlock)progress andSuccess:(SuccessBlock)success andFailure:(FailureBlock)failure{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:[WBUserDefaults deviceToken] forHTTPHeaderField:@"Authorization"];
    [manager POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
        
       // [formData appendPartWithFileData:fileData name:name fileName:@"dsadad.jpg" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
   }


+(void)postUrl:(NSString *)str withParameters:(id)parameters  whenProgress:(ProgressBlock)progress andSuccess:(SuccessBlock)success andFailure:(FailureBlock)failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:[WBUserDefaults deviceToken] forHTTPHeaderField:@"Authorization"];
  //  NSLog(@"deviceToken %@",[WBUserDefaults deviceToken]);
    [manager POST:str
       parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            progress(uploadProgress);
       } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           success(responseObject);
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error.localizedDescription);
       }];

    
}

+(void)postUserInfoUrl:(NSString *)str withParameters:(id)parameters fieldData:(FieldDataBlock)fieldData whenProgress:(ProgressBlock)progress andSuccess:(SuccessBlock)success andFailure:(FailureBlock)failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:[WBUserDefaults deviceToken] forHTTPHeaderField:@"Authorization"];
    [manager POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        fieldData(formData);
        //[formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
        
        // [formData appendPartWithFileData:fileData name:name fileName:@"dsadad.jpg" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}





@end
