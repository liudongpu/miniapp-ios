//
//  MiniappDownloadService.m
//  miniapp-ios
//
//  Created by liufan on 2019/8/23.
//  Copyright © 2019年 uhutu. All rights reserved.
//

#import "MiniappDownloadService.h"

#import <Foundation/Foundation.h>
#import "MiniappJumpUtil.h"
#import <UIKit/UIKit.h>
#import "MiniappViewController.h"
#import "SSZipArchive.h"
#import <AFURLSessionManager.h>
#import <AFHTTPSessionManager.h>

#import "MiniappEventInstance.h"
#import "MiniappViewController.h"

@interface MiniappDownloadService ()

@end


@implementation MiniappDownloadService



-(void)jumpUrl:(NSString *)sJumpUrl {
    
    if([sJumpUrl isEqualToString:@"debug-miniapp://"]){
        [self jumpForDebugMiniapp:@""];
    }
    else{
        [self targetMiniapp:sJumpUrl];
    }
}


-(void) jumpForDebugMiniapp:(NSString *)sJumpUrl {
    
    MiniappStructModel* initModel=[[MiniappStructModel alloc] init];
    
    [initModel setBundlePath:@""];
    
    [initModel setBundleView:@"MiniappPoject"];
    [initModel setEnvUrl:sJumpUrl];
    [initModel setEnvName:@"alpha"];
    [initModel setMiniInfo:@"{\"id\":\"\",\"code\":\"0\",\"version\":\"0.0.0\"}"];
    
    
    [self openMiniapp:initModel];

}



-(void) openMiniapp:(MiniappStructModel*) initModel {
    [self.delegate finishData:initModel];
}


-(void) targetMiniapp:(NSString *)sJumpUrl {
    
    
    
    NSRange rStartIndex = [sJumpUrl rangeOfString:@":"];
    
    
    NSString *sAfter=[sJumpUrl substringFromIndex:rStartIndex.location+3];
    
    
    
    NSRange rAppIndex=[sAfter rangeOfString:@".app"];
    
    NSString *sId= [sAfter substringToIndex:rAppIndex.location];
    
    NSString *sRequestUrl= [NSString stringWithFormat:[[MiniappEventInstance sharedInstance].eventDelegate upRequestUrl],sId];
    
    
    NSString *escapedString = [sJumpUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    
    sRequestUrl=[[sRequestUrl stringByAppendingString:@"?system_source="] stringByAppendingString:escapedString];
    
    
    
    //加载一个NSURL对象
    // NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:sRequestUrl]];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer.timeoutInterval = 60.0f;
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    
    [manager GET:sRequestUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        
        
        //iOS自带解析类NSJSONSerialization从response中解析出数据放到字典中
        NSDictionary *weatherDic = responseObject;
        
        MiniappStructModel* initModel=[[MiniappStructModel alloc] init];
        
        
        
        NSString *sPathRoot=[NSHomeDirectory() stringByAppendingString:@"/Documents/icome_miniapp/"];
        
        
        
        
        [initModel setPathBundle:[sPathRoot stringByAppendingString:@"bundle/"]];
        
        NSString *sPathFolder=[[initModel.pathBundle stringByAppendingString:[weatherDic objectForKey:@"folder" ]] stringByAppendingString:@"/"];
        
        
        [initModel setBundlePath:[sPathFolder stringByAppendingString:[weatherDic objectForKey:@"file"  ]]];
        
        [initModel setPathZip:[sPathRoot stringByAppendingString:@"zip/"]];
        
        [initModel setPathFolder:sPathFolder];
        [initModel setJsonUrl:[weatherDic objectForKey:@"url" ]];
        
        [initModel setBundleView:[weatherDic objectForKey:@"view" ]];
        
        [initModel setEnvUrl:sJumpUrl];
        [initModel setEnvName:[weatherDic objectForKey:@"env" ]];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:weatherDic options:0 error:0];
        
        NSString *sMiniInfo  =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        
        [initModel setMiniInfo:sMiniInfo];
        
        
        [self checkExec:initModel];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    
    //[NSURLSession ];
    
    
    //将请求的url数据放到NSData对象中
    //NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    
    
    
    
}



/**
 检查然后执行模型
 
 @param initModel <#initModel description#>
 */
-(void)checkExec:(MiniappStructModel*) initModel{
    
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    
    
    NSLog(@"file bundle %@",initModel.bundlePath);
    if ([fm fileExistsAtPath:initModel.bundlePath]) {
        [self openMiniapp:initModel ];
        
    }
    else{
        
        if(![fm fileExistsAtPath:initModel.pathZip ]){
            [fm createDirectoryAtPath:initModel.pathZip withIntermediateDirectories:YES attributes:nil error:nil];
        }
        if(![fm fileExistsAtPath:initModel.pathBundle] ){
            [fm createDirectoryAtPath:initModel.pathBundle withIntermediateDirectories:YES attributes:nil error:nil];
        }
        if(![fm fileExistsAtPath:initModel.pathFolder ]){
            [fm createDirectoryAtPath:initModel.pathFolder withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        
        
        
        
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        
        NSURL *url = [NSURL URLWithString:initModel.jsonUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        NSString *sNameZip=url.lastPathComponent;
        
        NSString *sFileZip = [initModel.pathZip stringByAppendingPathComponent:sNameZip];
        
        
        //        NSLog(sFileZip);
        
        
        
        /*
         if( [SSZipArchive unzipFileAtPath:[sPathZip stringByAppendingString:@"1.zip"] toDestination:sPathFolder]){
         NSLog(@"解压成功");
         
         }
         else{
         NSLog(@"解压失败");
         
         }
         */
        
        
        
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            
            NSLog(@"下载进度：%.0f％", downloadProgress.fractionCompleted * 100);
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            
            
            return [NSURL fileURLWithPath:sFileZip];
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            
            NSLog(@"下载完成");
            
            //NSString *sFileZip=   [filePath absoluteString];
            
            //            NSLog(filePath.path);
            //            NSLog(sPathFolder);
            
            if([fm fileExistsAtPath:filePath.path]){
                
                
                /*
                 [SSZipArchive createZipFileAtPath:[sPathBundle stringByAppendingString:@"1.zip"] withContentsOfDirectory:sPathZip];
                 
                 // Unzip
                 [SSZipArchive unzipFileAtPath:[sPathBundle stringByAppendingString:@"1.zip"] toDestination:[self tempUnzipPath]];
                 */
                
                
                
                [SSZipArchive unzipFileAtPath:filePath.path toDestination:initModel.pathFolder progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
                    // entry : 解压出来的文件名
                    //entryNumber : 第几个, 从1开始
                    //total : 总共几个
                    NSLog(@"progressHandler:%@, , entryNumber:%ld, total:%ld", entry, entryNumber, total);
                } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
                    //path : 被解压的压缩吧全路径
                    //succeeded 是否成功
                    // error 错误信息
                    NSLog(@"completionHandler:%@, , succeeded:%d, error:%@", path, succeeded, error);
                    
                    if(succeeded==1){
                        [self openMiniapp:initModel ];
                    }
                    
                }];
                
                
                /*
                 // Unzip
                 if( [SSZipArchive unzipFileAtPath:filePath toDestination:sPathFolder]){
                 NSLog(@"解压成功");
                 
                 }
                 else{
                 NSLog(@"解压失败");
                 
                 }
                 */
            }
            else{
                NSLog(@"文件不存在");
            }
            
            
            
            
            
            
            
            
        }];
        
        [downloadTask resume];
        
        
        
        
        
        /*
         NSString *sZipFileName = [NSURL URLWithString:sJsonUrl].lastPathComponent;
         
         [ICKNetworkHelper downloadWithURL:sJsonUrl fileDir:@"zip" fileName:sZipFileName progress:^(NSProgress *progress) {
         
         } success:^(NSString *filePath) {
         NSLog(sPathFolder);
         NSLog(filePath);
         if ([fm fileExistsAtPath:filePath]) {
         // Unzip
         if( [SSZipArchive unzipFileAtPath:filePath toDestination:sPathFolder]){
         NSLog(@"解压成功");
         
         }
         else{
         NSLog(@"解压失败");
         
         }
         
         
         
         }
         
         } failure:^(NSError *error) {
         
         }];
         */
    }
    
    
    
}



@end

