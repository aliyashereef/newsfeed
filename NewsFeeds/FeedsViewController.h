//
//  FeedsViewController.h
//  NewsFeeds
//
//  Created by Vineeth on 17/06/14.
//  Copyright (c) 2014 Vineeth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>
#import "FeedParse.h"
@interface FeedsViewController : UIViewController<UITableViewDelegate,UISearchBarDelegate,NSXMLParserDelegate,FeedParseDelegate>
    @property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;
    @property (weak, nonatomic) IBOutlet UITableView *MenuTable;
    @property (weak, nonatomic) IBOutlet UITableView *FeedsTable;
@end
