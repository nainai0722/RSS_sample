//
//  UrlListTableViewController.m
//  test1003_XmlParser
//
//  Created by apple on 2013/10/13.
//  Copyright (c) 2013年 com.beyondjapan. All rights reserved.
//

#import "UrlListTableViewController.h"
#import "FeedListTableViewController.h"

@interface UrlListTableViewController ()

@end

@implementation UrlListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)_loadFile{
    _items = [[NSMutableArray alloc] init];
    
    NSString *title;
    NSString *url;
    NSDictionary *dic;
    
    title = @"title1";
    
    url = @"http://rss.dailynews.yahoo.co.jp/fc/rss.xml";
    
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:
           title, @"title",
           url, @"url",
           nil];
    [_items addObject:dic];
    
    title = @"title2";
    
    url = @"http://rss.dailynews.yahoo.co.jp/fc/world/rss.xml";
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:
           title, @"title",
           url, @"url",
           nil];
    [_items addObject:dic];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _loadFile];

    // addボタン追加
    UIBarButtonItem *btn =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addUrlMethod:)];
    self.navigationItem.leftBarButtonItem = btn;
    self.navigationController.toolbar.tintColor = [UIColor grayColor];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - セル追加入力画面への遷移
- (void)addUrlMethod:(UIBarButtonItem *)item {
    AddUrlViewController *ad = [[AddUrlViewController alloc] init];
    ad.delegate = self;
    [self presentViewController:ad animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dicRow = [_items objectAtIndex:indexPath.row];
    cell.textLabel.text = [dicRow objectForKey:@"title"];
    cell.detailTextLabel.text = [dicRow objectForKey:@"url"];    // 詳細をセット
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // ここから追加
    NSURL *theURL = [NSURL URLWithString:[[_items objectAtIndex:indexPath.row] objectForKey:@"url"]];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:theURL];
    NSURLConnection *theConnection=[[NSURLConnection alloc]
                                    initWithRequest:theRequest delegate:self];
    if (theConnection) {
        NSLog(@"start loading");
        _receivedData = [NSMutableData data];
    }
    // ここまで追加
}


- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"receive response");
    [_receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    NSLog(@"receive data");
    [_receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Succeeded! Received %d bytes of data",[_receivedData length]);
    
    NSXMLParser *p = [[NSXMLParser alloc] initWithData:_receivedData];
    p.delegate = self;
    _feed = [[NSMutableArray alloc] init];
//    NSMutableArray *sectionList = [[NSMutableArray alloc] init];
    // XMLの読み込みを開始する。
    [p parse];
    

}


/* add xml 読み込みイベントの監視*/
// xml 読み込み開始イベント
- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
    
    _currentElement = [elementName copy];
    
    if ([elementName isEqualToString:@"channel"]) {
        _feedTitle = [[NSMutableString alloc] init];
    }
    if ([elementName isEqualToString:@"item"]) {
        _currentTitle = [[NSMutableString alloc] init];
        _currentLink = [[NSMutableString alloc] init];
    }
}
// なんか見つけた時のイベント
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //_count1が発行されたら、ここはもう読み込まない
    if (![_count1 isEqualToString:@"1"]&&[_currentElement isEqualToString:@"title"]) {
        [_feedTitle appendString:string];
    }
    
    if ([_currentElement isEqualToString:@"title"]) {
        [_currentTitle appendString:string];
    } else if( [_currentElement isEqualToString:@"link"]) {
        [_currentLink appendString:string];
    }
}

// xml 読み込み完了イベント
- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"item"]) {
        
        NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:_currentTitle, @"title",_currentLink, @"description", nil];
        [_feed addObject:item];
        
        NSString *title;
        title = _feedTitle;
        
        NSString *feed;
        
        /* add start */
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat  = @"yyyy/MM/dd HH:mm:ss";
        NSString *time = [df stringFromDate:[NSDate date]];
        /* add end */
        

        _dics = [NSDictionary dictionaryWithObjectsAndKeys:
                 title, @"title",
                 feed, @"feed",
                 _feed, @"items",
                 time, @"time",
                 nil];
    }
    if ([elementName isEqualToString:@"title"]) {
        // タイトルを一回読んだら、_count1を発行する
        _count1 = @"1";
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"xmldidfinished!");
    
    FeedListTableViewController *fv = [[FeedListTableViewController alloc] init];
    fv.feed = _feed;
    [self.navigationController pushViewController:fv animated:YES];
}

/* add end xml 読み込みイベントの監視*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */
#pragma mark - 　insertView　からのデリゲート
- (void)addUrlViewController:(AddUrlViewController *)obj didInput:(NSDictionary *)dic{
    [_items addObject:obj.dic];
    //cellにも同様に追加する
    NSIndexPath *ip = [NSIndexPath indexPathForItem:[_items count]-1 inSection:0];
    NSArray *ips = [NSArray arrayWithObject:ip];
    [self.tableView insertRowsAtIndexPaths:ips withRowAnimation:UITableViewRowAnimationLeft];
    
    [obj dismissViewControllerAnimated:YES completion:^{
        [self.tableView scrollToRowAtIndexPath:ip
                              atScrollPosition:UITableViewScrollPositionMiddle
                                      animated:YES];
    }];
}

@end
