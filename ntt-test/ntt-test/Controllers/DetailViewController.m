//
//  DetailViewController.m
//  ntt-test
//
//  Created by Alessandro Grigiante on 20/01/2020.
//  Copyright © 2020 ArsETmedia. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "DetailViewController.h"

@interface DetailViewController () <WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;


@end

@implementation DetailViewController

@synthesize userHtmlUrl;

- (void)viewDidLoad {
    [super viewDidLoad];

    _webView.navigationDelegate = self;
    [_spinner startAnimating];
    
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:[NSURL URLWithString: self.userHtmlUrl]];
    [_webView loadRequest:nsrequest];
    
}



-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [_spinner stopAnimating];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
