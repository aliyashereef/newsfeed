//
//  DetailedView.m
//  NewsFeeds
//
//  Created by qbadmin on 18/06/14.
//  Copyright (c) 2014 qbadmin. All rights reserved.
//

#import "DetailedView.h"
#import "UIImageView+WebCache.h"

@interface DetailedView ()

@end

@implementation DetailedView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //removing htmltags from content
    NSRange rangeofstring;
    self.DetailedViewContent.text =[self.feed valueForKey:@"content:encoded"];
    while ((rangeofstring = [self.DetailedViewContent.text rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        self.DetailedViewContent.text = [self.DetailedViewContent.text stringByReplacingCharactersInRange:rangeofstring   withString:@""];
    [self.DetailedViewContent setFont:[UIFont systemFontOfSize:13]];
    self.DetailedViewContent.numberOfLines = 0;
    [self.DetailedViewContent sizeToFit];
    self.DetailedViewTitle.text=[self.feed valueForKey:@"title"];
    self.DetailedViewTitle.numberOfLines = 0;
    [self.DetailedViewTitle sizeToFit];
    self.DetailViewScroll.contentSize = self.DetailedViewContent.bounds.size;
    //image setting
    [self.DetailedViewImage setImageWithURL:[NSURL URLWithString:[self.feed valueForKey:@"image"]]];
    //date
    NSString *dateString=[self.feed valueForKey:@"pubDate"];
    self.DetailedViewDate.text=dateString;
}


@end
