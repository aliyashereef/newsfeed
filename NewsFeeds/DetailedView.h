//
//  DetailedView.h
//  NewsFeeds
//
//  Created by Vineeth on 18/06/14.
//  Copyright (c) 2014 Vineeth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface DetailedView : UIViewController
    @property (weak,nonatomic) NSDictionary *feed;
    @property (weak, nonatomic) IBOutlet UIImageView *DetailedViewImage;
    @property (weak, nonatomic) IBOutlet UILabel *DetailedViewTitle;
    @property (weak, nonatomic) IBOutlet UILabel *DetailedViewDate;
    @property (weak, nonatomic) IBOutlet UILabel *DetailedViewContent;
    @property (weak, nonatomic) IBOutlet UIScrollView *DetailViewScroll;
@end
