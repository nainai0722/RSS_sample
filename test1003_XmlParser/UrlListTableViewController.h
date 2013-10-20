//
//  UrlListTableViewController.h
//  test1003_XmlParser
//
//  Created by apple on 2013/10/13.
//  Copyright (c) 2013年 com.beyondjapan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddUrlViewController.h"

@interface UrlListTableViewController : UITableViewController<NSXMLParserDelegate,AddUrlViewControllerDelegate> {
    NSMutableArray *_items;
    NSMutableData *_receivedData;
    NSMutableArray *_feed;
    NSString *_currentElement;
    NSMutableString *_currentTitle, *_currentLink,*_feedTitle;
    NSString *_count1;
    NSDictionary *_dics;
}
@end
