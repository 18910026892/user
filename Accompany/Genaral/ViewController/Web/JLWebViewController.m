//
//  JLWebViewController.m
//  Accompany
//
//  Created by 巩鑫 on 16/1/25.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLWebViewController.h"

@implementation JLWebViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTabBarHide:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    // Do any additional setup after loading the view.
    [self setNavTitle:_WebTitle];
    
    
}
-(UIButton*)BackButton
{
    if (!_BackButton) {
        _BackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_BackButton setFrame:CGRectMake(10,20, 64*Proportion, 44)];
        _BackButton.titleLabel.font = [UIFont fontWithName:KTitleFont size:16.0];
        _BackButton.imageEdgeInsets = UIEdgeInsetsMake(0,-20, 0, 25);
        _BackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [_BackButton setImage:[UIImage imageNamed:@"BackButton"] forState:UIControlStateNormal];
        [_BackButton setImage:[UIImage imageNamed:@"BackButtonHighlighted"] forState:UIControlStateHighlighted];
        [_BackButton addTarget:self action:@selector(backEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _BackButton;
}
-(void)backEvent:(UIButton*)sender;
{
    UIButton * btn = (UIButton*)sender;
    btn.userInteractionEnabled = NO;
    
    if (_WebView.canGoBack) {
        
        [_WebView goBack];
        btn.userInteractionEnabled = YES;
        
    }else
    {
         [self.navigationController popViewControllerAnimated:YES];
         btn.userInteractionEnabled = YES;
        
    }
}


-(UIWebView*)WebView
{
    if (!_WebView) {
        _WebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kMainBoundsWidth, kMainBoundsHeight-64)];
        _WebView.backgroundColor = [UIColor clearColor];
        _WebView.delegate = self;
        _WebView.opaque  = NO;
        _WebView.tag = 1;
        _WebView.scalesPageToFit = YES;
        _WebView.autoresizesSubviews = YES;
        NSString * requestUrl = [_RequestUlr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        NSURL * url = [NSURL URLWithString:requestUrl];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [_WebView loadRequest:request];
 
    }
    return _WebView;
}

-(void)initProgressView
{
    _webViewProgress = [[NJKWebViewProgress alloc] init];
    _WebView.delegate = _webViewProgress;
    _webViewProgress.webViewProxyDelegate = self;
    _webViewProgress.progressDelegate = self;
    
    
    CGRect navBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0,
                                 navBounds.size.height - 2,
                                 navBounds.size.width,
                                 2);
    _webViewProgressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _webViewProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_webViewProgressView setProgress:0 animated:YES];
}


-(void)setupViews
{
    [self.Customview addSubview:self.BackButton];
    [self.view addSubview:self.WebView];
    [self initProgressView];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_webViewProgressView setProgress:progress animated:YES];
    self.title = [_WebView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webViewDidStartLoad:(UIWebView *)webView;
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error;
{
    
}



@end
