//
//  FeedsViewController.h
//  NewsFeeds
//
//  Created by qbadmin on 17/06/14.
//  Copyright (c) 2014 qbadmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>
@interface FeedsViewController : UIViewController<UITableViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;
@property (weak, nonatomic) IBOutlet UITableView *MenuTable;
@property (weak, nonatomic) IBOutlet UISearchBar *NewsSearch;

- (IBAction)MenuButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *FeedsTable;
@end
