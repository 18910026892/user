//
//  GXHttpRequest.h
//  Accompany
//
//  Created by GX on 16/1/18.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPSessionManager.h>


@interface HttpRequest : NSObject

typedef void(^successGetData)(id response);
typedef void(^failureData)(id error);
typedef void(^failureGetData)(id error);

@property(nonatomic,strong) successGetData successBlock;
@property(nonatomic,strong) failureData failureDataBlock;
@property(nonatomic,strong) failureGetData failureBlock;

@property(nonatomic,copy)void(^FiledownloadedTo)(NSURL*);
@property(nonatomic,copy)void(^FileuploadedTo)(id);


//Get请求
-(void)RequestDataWithUrl:(NSString*)urlString;
//post请求
-(void)RequestDataWithUrl:(NSString*)urlString pragma:(NSDictionary*)pragmaDict;
//带图片Post请求
-(void)RequestDataWithUrl:(NSString*)urlString pragma:(NSDictionary*)pragmaDict ImageDatas:(id)data imageName:(NSString*)imageName;
//下载
-(void)StartDownloadTaskWithUrl:(NSString*)urlString;
//上传
-(void)StartUploadTaskTaskWithUrl:(NSString*)urlString;

//结果回调
-(void)getResultWithSuccess:(successGetData)success DataFaiure:(failureData)datafailure Failure:(failureGetData)failure;

@end
