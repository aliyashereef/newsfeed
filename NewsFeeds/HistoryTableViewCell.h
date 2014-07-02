//
//  HistoryTableViewCell.h
//  NewsFeeds
//
//  Created by Vineeth on 23/06/14.
//  Copyright (c) 2014 Vineeth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell
    @property (weak, nonatomic) IBOutlet UIImageView *HistoryImage;
    @property (weak, nonatomic) IBOutlet UILabel *HistoryTitle;
    @property (weak, nonatomic) IBOutlet UILabel *HistoryDiscription;

@end
