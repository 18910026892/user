//
//  GXHttpRequest.m
//  Accompany
//
//  Created by GX on 16/1/18.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "HttpRequest.h"

@implementation HttpRequest

//将urlstr UTF8编码
-(NSString *)getEncodeurlStr:(NSString *)urlstr;
{
    NSString *encodeurlstr =  [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return encodeurlstr;
}

-(void)getResultWithSuccess:(successGetData)success DataFaiure:(failureData)datafailure Failure:(failureGetData)failure;
{
    _successBlock = success;
    _failureDataBlock = datafailure;
    _failureBlock = failure;
}

//Get 请求
-(void)RequestDataWithUrl:(NSString*)urlString;
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * requestUrl = [self getEncodeurlStr:urlString];
    
    [manager GET:requestUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if([jsonDict[@"code"] integerValue]==1){
            if(_successBlock){
                id response = jsonDict[@"result"];
                self.successBlock(response);
            }
        }else{
            if(_failureDataBlock){
                self.failureDataBlock(jsonDict[@"message"]);
            }
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        if(_failureBlock){
            self.failureBlock(error);
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

//不带图片post请求
-(void)RequestDataWithUrl:(NSString*)urlString pragma:(NSDictionary*)pragmaDict;
{
    [self RequestDataWithUrl:urlString pragma:pragmaDict ImageDatas:nil imageName:nil];
}


//带图片Post 请求
-(void)RequestDataWithUrl:(NSString*)urlString pragma:(NSDictionary*)pragmaDict ImageDatas:(id)data imageName:(NSString*)imageName;
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * requestUrl = [self getEncodeurlStr:urlString];
    
    [manager POST:requestUrl parameters:pragmaDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(data==nil) ;
        else if([data isKindOfClass:[NSData class]]){
            [formData appendPartWithFileData:data name:imageName fileName:@"defult_placeImage.png" mimeType:@"png"];
        }else if([data isKindOfClass:[NSMutableArray class]]){
            //多张图片上传
            [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSData *imgData = (NSData *)obj;
                [formData appendPartWithFileData:imgData name:imageName fileName:@"defult_placeImage.png" mimeType:@"png"];
            }];
        }
        
    } progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%f",downloadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if([jsonDict[@"code"] integerValue]==1){
            if(_successBlock){
                id response = jsonDict[@"result"];
                self.successBlock(response);
            }
        }else{
            if(_failureDataBlock){
                self.failureDataBlock(jsonDict[@"message"]);
            }
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        if(_failureBlock){
            self.failureBlock(error);
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

//下载
-(void)StartDownloadTaskWithUrl:(NSString*)urlString;
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        if(_FiledownloadedTo){
            self.FiledownloadedTo(filePath);
        }
        
    }];
    [downloadTask resume];
}
//上传
-(void)StartUploadTaskTaskWithUrl:(NSString*)urlString;
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://example.com/upload"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Success: %@ %@", response, responseObject);
            if(_FileuploadedTo)
            {
                self.FileuploadedTo(responseObject);
            }
        }
    }];
    [uploadTask resume];
}


@end
