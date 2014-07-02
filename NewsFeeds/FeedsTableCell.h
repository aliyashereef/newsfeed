//
//  FeedsTableCell.h
//  NewsFeeds
//
//  Created by Vineeth on 18/06/14.
//  Copyright (c) 2014 Vineeth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedsTableCell : UITableViewCell
    @property (weak, nonatomic) IBOutlet UIImageView *FeedImage;
    @property (weak, nonatomic) IBOutlet UILabel *FeedTitle;
    @property (weak, nonatomic) IBOutlet UILabel *FeedDiscription;

@end
