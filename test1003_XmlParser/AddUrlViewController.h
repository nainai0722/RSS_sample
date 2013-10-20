//
//  AddUrlViewController.h
//  test1003_XmlParser
//
//  Created by apple on 2013/10/19.
//  Copyright (c) 2013年 com.beyondjapan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddUrlViewControllerDelegate;     //デリゲートするために追加
@interface AddUrlViewController : UIViewController<UITextFieldDelegate>
{
    UITextField *tf;
}
@property (nonatomic, retain) NSDictionary *dic;        //デリゲートするために追加
@property(nonatomic, assign) id<AddUrlViewControllerDelegate> delegate;     //デリゲートするために追加
@end

@protocol  AddUrlViewControllerDelegate <NSObject>      //デリゲートするために追加
@optional//デリゲートするために追加
- (void)addUrlViewController:(AddUrlViewController *)obj didInput:(NSDictionary *)dic;//デリゲートするために追加
//- (void)addUrlViewControllerDidCancel:(AddUrlViewController *)obj;//デリゲートするために追加

@end

