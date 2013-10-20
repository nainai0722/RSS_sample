//
//  InsertViewController.m
//  test0918_RssFeedsTable
//
//  Created by apple on 2013/09/23.
//  Copyright (c) 2013年 byduser. All rights reserved.
//

#import "AddUrlViewController.h"

@interface AddUrlViewController (){
    CGRect orginalFrame;
}

@end

@implementation AddUrlViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    UIView *uv = [[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 690)];
    [sv addSubview:uv];
    sv.contentSize = uv.bounds.size;
    [self.view addSubview:sv];
    
    //URL入力用のラベル
    UILabel * urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 150, 30)];
    [urlLabel setText:@"URL"];
    [urlLabel setBackgroundColor:[UIColor darkGrayColor]];
    [uv addSubview:urlLabel];
    //テキストフィールドを設定
    tf = [[UITextField alloc] initWithFrame:CGRectMake(50, 100, 220, 40)];
    tf.delegate = self;
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.keyboardType = UIKeyboardTypeURL;
    tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tf.returnKeyType = UIReturnKeyDone;
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    [uv addSubview:tf];
    //ボタンを設定
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.frame = CGRectMake(60, 170, 80, 40);
    [btn1 setBackgroundColor:[UIColor whiteColor]];
    [btn1 setTitle:@"追加" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(backPage) forControlEvents:UIControlEventTouchUpInside];
    [uv addSubview:btn1];
    //キャンセルボタンを設定
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn2.frame = CGRectMake(170, 170, 100, 40);
    [btn2 setBackgroundColor:[UIColor whiteColor]];
    [btn2 setTitle:@"キャンセル" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(cancelPage) forControlEvents:UIControlEventTouchUpInside];
    [uv addSubview:btn2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma MARL - URL入力手続き関連
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [tf resignFirstResponder];
    return YES;
}

#pragma mark - ボタンを押した時の動き
- (void)backPage {
    NSString *str = @"addurl";
    self.dic = [NSDictionary dictionaryWithObjectsAndKeys:
                str, @"title",
                tf.text, @"url",
                nil];
    NSLog(@"%@",tf.text);
    //dicの内容をsectionListに追加して、cell追加及び外部ファイルに書き込む処理を行う
    if ([self.delegate conformsToProtocol:@protocol(AddUrlViewControllerDelegate)]) {
        if ([self.delegate respondsToSelector:@selector(addUrlViewController:didInput:)]) {
            [self.delegate addUrlViewController:self didInput:self.dic];
        }
    }
}

//if ([self.delegate conformsToProtocol:@protocol(InsertViewControllerDelegate)]) {
//    if ([self.delegate respondsToSelector:@selector(insertViewController:didInput:)]) {
//        [self.delegate insertViewController:self didInput:self.dic];
//    }
//}

#pragma mark - Cancelボタンを押した時の動作
- (void) cancelPage {
    NSLog(@"cancel click");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
