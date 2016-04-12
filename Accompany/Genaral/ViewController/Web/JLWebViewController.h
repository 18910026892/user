//
//  JLWebViewController.h
//  Accompany
//
//  Created by 巩鑫 on 16/1/25.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"
#import <NJKWebViewProgress.h>
#import <NJKWebViewProgressView.h>
@interface JLWebViewController : BaseViewController<UIWebViewDelegate, NJKWebViewProgressDelegate>
{
 
    NJKWebViewProgressView *_webViewProgressView;
    NJKWebViewProgress *_webViewProgress;
}

@property(nonatomic,strong)UIButton * BackButton;

@property(nonatomic,strong)UIWebView * WebView;

@property(nonatomic,copy)NSString *  RequestUlr;

@property(nonatomic,copy)NSString * WebTitle;
@end
