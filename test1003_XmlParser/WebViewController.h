//
//  WebViewController.h
//  test1003_XmlParser
//
//  Created by apple on 2013/10/13.
//  Copyright (c) 2013年 com.beyondjapan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<UIWebViewDelegate>
@property (nonatomic, retain) NSString *url;
@end
