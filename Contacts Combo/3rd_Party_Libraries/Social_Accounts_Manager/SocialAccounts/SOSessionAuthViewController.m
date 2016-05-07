//
// Copyright 2011-2012 Adar Porat (https://github.com/aporat)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "SOSessionAuthViewController.h"

@implementation SOSessionAuthViewController

+ (instancetype)controllerWithCompletionHandler:(void (^)(NSDictionary* info, NSError *error))handler {
    return [[self alloc] initWithCompletionHandler:handler];
}

- (instancetype)initWithCompletionHandler:(void (^)(NSDictionary* info, NSError *error))handler {
    
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        completionBlock_ = [handler copy];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSHTTPCookieStorage *cookieStorage;
    
    cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies =  [cookieStorage cookies];
    
    for (NSHTTPCookie *cookie in cookies) {
        [cookieStorage deleteCookie:cookie];
    }
    
    self.webView.scalesPageToFit = YES;

    self.title = [NSString stringWithFormat:NSLocalizedString(@"Login to %@", @""), self.accountType.accountTypeDescription];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss:)];
    
    CGRect frame = CGRectMake(0.0, 0.0, 25.0, 25.0);
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    [self.activityIndicator sizeToFit];
    self.activityIndicator.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    self.webView.delegate = self;
    
    // the app may prefer some html other than blank white to be displayed
    // before the sign-in web page loads
    NSString *html = @"<html><body bgcolor=white><div align=center style='font-family:Arial'>Loading sign-in page...</div></body></html>";
    if ([html length] > 0) {
        [[self webView] loadHTMLString:html baseURL:nil];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.loginUrl];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    [self.webView loadRequest:request];
    [self.webView setScalesPageToFit:YES];
    
}

- (void)dismiss:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
    [self dismissModalViewControllerAnimated:YES];
    });
}


- (void)dealloc {
    self.webView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.activityIndicator startAnimating];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicator stopAnimating];
}


@end
