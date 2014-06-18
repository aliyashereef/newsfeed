//
//  FeedsViewController.m
//  NewsFeeds
//
//  Created by qbadmin on 17/06/14.
//  Copyright (c) 2014 qbadmin. All rights reserved.
//

#import "FeedsViewController.h"
#import "MenuTableCell.h"
#import "CollectionCell.h"
#import "FeedsTableCell.h"
#import "FeedParse.h"

@interface FeedsViewController ()
{
    NSArray *menulist,*menulist1;
    NSURL *Politicsurl,*MoviewReiviewurl,*Sportsurl,*Hollywoodurl,*NationalInteresturl;
    NSMutableArray *SportsArray,*PoliticsArray,*MoviewReiviewArray,*NationalInterestArray,*HollywoodArray;
}

@end

@implementation FeedsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    FeedParse *feed;
    feed=[[FeedParse alloc] init];
    menulist=[NSArray arrayWithObjects:@"SignIn",@"Politics",@"Movie-Review",@"Hollywood",@"National-Interest",@"Sports",nil];
    menulist1= [NSArray arrayWithObjects:@"Sign Out",@"Politics",@"Movie-Review",@"Hollywood",@"National-Interest",@"Sports",nil];
    MoviewReiviewurl =[NSURL URLWithString:@"http://indianexpress.com/section/entertainment/movie-review/feed/"];
    Politicsurl=[NSURL URLWithString:@"http://indianexpress.com/section/india/politics/feed/"];
    Sportsurl=[NSURL URLWithString:@"http://indianexpress.com/section/sports/feed/"];
    NationalInteresturl=[NSURL URLWithString:@"http://indianexpress.com/print/national-interest/feed/"];
    Hollywoodurl=[NSURL URLWithString:@"http://indianexpress.com/section/entertainment/hollywood/feed/"];
    SportsArray=[[NSMutableArray alloc] init];
    MoviewReiviewArray=[[NSMutableArray alloc] init];
    NationalInterestArray=[[NSMutableArray alloc] init];
    PoliticsArray=[[NSMutableArray alloc] init];
    HollywoodArray=[[NSMutableArray alloc] init];
    SportsArray =[feed startparse:Sportsurl];
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewWillAppear:(BOOL)animated{
    self.MenuTable.frame=CGRectMake(0, 75, 0,360);
    self.FeedsTable.frame=CGRectMake(0,280, 320, 516);
    self.CollectionView.frame=CGRectMake(0,0, 320, 280);
}



@end
