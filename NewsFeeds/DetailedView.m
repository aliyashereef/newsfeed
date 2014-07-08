//
//  DetailedView.m
//  NewsFeeds
//
//  Created by Vineeth on 18/06/14.
//  Copyright (c) 2014 Vineeth. All rights reserved.
//

#import "DetailedView.h"
#import "UIImageView+WebCache.h"

@interface DetailedView ()
{
    int offsety;
    UIAlertView *alert;
    UIButton *sharebutton;
    UIBarButtonItem *rightbutton;
}

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
    NSString *version = [[UIDevice currentDevice] systemVersion];
    int ver = [version intValue];
    if (ver < 7){
        offsety=64;
        self.DetailViewScroll.frame=CGRectMake(0,90-offsety, 320, 516);
        //iOS 6 work
    }
    else{
        self.DetailViewScroll.frame=CGRectMake(0,0, 320, 560);
        //iOS 7 related work
    }
    [super viewDidLoad];
    UIImage *buttonImage = [UIImage imageNamed:@"rsz_share.png"];
    sharebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sharebutton setImage:buttonImage forState:UIControlStateNormal];
    sharebutton.frame = CGRectMake(0.0,0.0,buttonImage.size.width,buttonImage.size.height);
    [sharebutton addTarget:self action:@selector(ShareButton) forControlEvents:UIControlEventTouchUpInside];
    rightbutton = [[UIBarButtonItem alloc] initWithCustomView:sharebutton];
    self.navigationItem.rightBarButtonItem = rightbutton;
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
    [self.DetailedViewContent setFont:[UIFont systemFontOfSize:14]];
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
    [self.DetailedViewDate setFont:[UIFont systemFontOfSize:10]];
}

#pragma mark -FBshare
- (void)ShareButton
{
    NSArray *activityItems = @[[self.feed valueForKey:@"title"],[NSURL URLWithString:[self.feed valueForKey:@"image"]]];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:Nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact ];
    [self presentViewController:activityViewController animated:YES completion:NULL];
}
@end
