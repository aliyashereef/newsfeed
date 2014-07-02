//
//  HistoryTableViewCell.h
//  NewsFeeds
//
//  Created by qbadmin on 23/06/14.
//  Copyright (c) 2014 qbadmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell
    @property (weak, nonatomic) IBOutlet UIImageView *HistoryImage;
    @property (weak, nonatomic) IBOutlet UILabel *HistoryTitle;
    @property (weak, nonatomic) IBOutlet UILabel *HistoryDiscription;

@end
