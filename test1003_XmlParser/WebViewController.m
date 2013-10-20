//
//  WebViewController.m
//  test1003_XmlParser
//
//  Created by apple on 2013/10/13.
//  Copyright (c) 2013年 com.beyondjapan. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    UIWebView *wv = [[UIWebView alloc] init];//hファイルにて定義、インスタンス生成
    wv.scalesPageToFit = YES;
    wv.delegate  = self;
    CGRect r = self.view.bounds;
    //    r.size.height -= self.navigationController.navigationBar.bounds.size.height;
    wv.frame = r;
    
    [self.view addSubview:wv];

    
    NSURL *url1 = [NSURL URLWithString:self.url];
    NSURLRequest *req1 = [NSURLRequest requestWithURL:url1];
    [wv loadRequest:req1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
