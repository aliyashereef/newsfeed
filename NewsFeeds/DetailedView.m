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
        //iOS 7 related work
    }
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

#pragma mark -FBshare
- (IBAction)ShareButton:(id)sender {
    // Check if the Facebook app is installed and we can present the share dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:[self.feed valueForKey:@"image"]];
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        // Present share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
        
        // If the Facebook app is NOT installed and we can't present the share dialog
    } else {
        // FALLBACK: publish just a link using the Feed dialog
        
        // Put together the dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [self.feed valueForKey:@"title"], @"name",
                                       [self.feed valueForKey:@"pubDate"], @"caption",
                                       [self.feed valueForKey:@"description"], @"description",
                                       @"", @"link",
                                       [self.feed valueForKey:@"image"], @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User canceled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User canceled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                }];
    }
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

@end
