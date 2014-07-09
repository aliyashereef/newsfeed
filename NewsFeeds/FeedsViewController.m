//
//  FeedsViewController.m
//  NewsFeeds
//
//  Created by Vineeth on 17/06/14.
//  Copyright (c) 2014 Vineeth. All rights reserved.
//

#import "FeedsViewController.h"
#import "MenuTableCell.h"
#import "CollectionCell.h"
#import "FeedsTableCell.h"
#import "FeedParse.h"
#import "UIImageView+WebCache.h"
#import "DetailedView.h"
#import "SignInView.h"
#import "Parse/Parse.h"
#import "Constants.h"
#import "MBProgressHUD.h"

@interface FeedsViewController ()
{
    NSArray *menulist,*menulist1;
    NSMutableArray *AllNewsArray,*AllNews,*SearchedNewsArray,*readarticle,*urlarray,*unsortednewsarray;
    int loginref,didscroll,didselectcollection,newssearched,menuclicked,offsety,didrefresh;
    NSInteger selectedrow,selectedfeed,collectionindex;
    NSTimer *timer;
    FeedParse *feedmovie,*feedpolitics,*feedholliwood,*feednational,*feedsports;
    UIButton *flipButton,*menubutton;
    UISearchBar *search;
    UIView *searchBarView,*feedsheaderView,*menuheaderView;
    UIBarButtonItem *rightbutton,*leftbutton;
    int allnewsindex,AllNewsArrayindex;
    MBProgressHUD *Loading;
    UILabel *refreshlabel;
}

@end


@implementation FeedsViewController

- (void)viewDidLoad
{
    didrefresh=0;
    Loading = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Loading.mode = MBProgressHUDModeIndeterminate;
    Loading.labelText = @"Loading";
    [Loading show:YES];
    AllNewsArrayindex=0;
    allnewsindex=0;
    NSString *version = [[UIDevice currentDevice] systemVersion];
    int ver = [version intValue];
    if (ver < 7){
        offsety=64;
        //iOS 6 work
    }
    [super viewDidLoad];
    selectedrow=6;
    readarticle=[[NSMutableArray alloc] init];
    unsortednewsarray=[[NSMutableArray alloc] init];
    //setting all the url
    menulist=[NSArray arrayWithObjects:@"SignIn",@"Politics",@"Movie-Review",@"Hollywood",@"National-Interest",@"Sports",@"AllNews",nil];
    menulist1= [NSArray arrayWithObjects:@"My Profile",@"Politics",@"Movie-Review",@"Hollywood",@"National-Interest",@"Sports",@"AllNews",nil];
    urlarray=[[NSMutableArray alloc] init];
    [urlarray addObject:[NSURL URLWithString:@"http://indianexpress.com/section/india/politics/feed/"]];
    [urlarray addObject:[NSURL URLWithString:@"http://indianexpress.com/section/entertainment/movie-review/feed/"]];
    [urlarray addObject:[NSURL URLWithString:@"http://indianexpress.com/section/entertainment/hollywood/feed/"]];
    [urlarray addObject:[NSURL URLWithString:@"http://indianexpress.com/print/national-interest/feed/"]];
    [urlarray addObject:[NSURL URLWithString:@"http://indianexpress.com/section/sports/feed/"]];
    //parsing
    feedpolitics=[[FeedParse alloc] init];
    feedmovie=[[FeedParse alloc] init];
    feedholliwood=[[FeedParse alloc] init];
    feednational=[[FeedParse alloc] init];
    feedsports=[[FeedParse alloc] init];
    AllNewsArray=[[NSMutableArray alloc] init];
    AllNews=[[NSMutableArray alloc] init];
    [feedpolitics startparse:[urlarray objectAtIndex:0]];
    [feedmovie startparse:[urlarray objectAtIndex:1]];
    [feedholliwood startparse:[urlarray objectAtIndex:2]];
    [feednational startparse:[urlarray objectAtIndex:3]];
    [feedsports startparse:[urlarray objectAtIndex:4]];
    [feedpolitics setMydelegate:self];
    [feedmovie setMydelegate:self];
    [feedholliwood setMydelegate:self];
    [feednational setMydelegate:self];
    [feedsports setMydelegate:self];
    //adding navigationbarbuttons
    UIImage *searchImage = [UIImage imageNamed:@"rsz_1menu.jpg"];
    menubutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menubutton setImage:searchImage forState:UIControlStateNormal];
    menubutton.frame = CGRectMake(0.0,0.0,searchImage.size.width,searchImage.size.height);
    [menubutton addTarget:self action:@selector(MenuButton) forControlEvents:UIControlEventTouchUpInside];
    leftbutton = [[UIBarButtonItem alloc] initWithCustomView:menubutton];
    UIImage *buttonImage = [UIImage imageNamed:@"rsz_search.png"];
    flipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [flipButton setImage:buttonImage forState:UIControlStateNormal];
    flipButton.frame = CGRectMake(0.0,0.0,buttonImage.size.width,buttonImage.size.height);
    [flipButton addTarget:self action:@selector(clicksearchbutton) forControlEvents:UIControlEventTouchUpInside];
    rightbutton = [[UIBarButtonItem alloc] initWithCustomView:flipButton];
    self.navigationItem.leftBarButtonItem = leftbutton;
    self.navigationItem.rightBarButtonItem = rightbutton;
    feedsheaderView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 220, 10)];
    feedsheaderView.backgroundColor=[UIColor colorWithRed:0 green:0.5 blue:1 alpha:1];
    menuheaderView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 220, 10)];
    menuheaderView.backgroundColor=[UIColor colorWithRed:1 green:0.5 blue:0 alpha:1];
    refreshlabel= [[UILabel alloc] initWithFrame:CGRectMake(123, 0, 100, 10)];
    refreshlabel.text=@"Pull To Refresh";
    refreshlabel.backgroundColor=[UIColor colorWithRed:0 green:0.5 blue:1 alpha:1];;
    [refreshlabel setTextColor:[UIColor whiteColor]];
    [refreshlabel setFont:[UIFont systemFontOfSize:10]];
    [feedsheaderView addSubview:refreshlabel];
    self.MenuTable.tableHeaderView=menuheaderView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    menuclicked=0;
    self.MenuTable.frame=CGRectMake(0, 65-offsety, 0,302);
    self.FeedsTable.frame=CGRectMake(0,240-offsety, 320, 320-offsety);
    self.CollectionView.frame=CGRectMake(0,-20-offsety, 320, 280);
    //checking whether a user is logged in or not
    if([[NSUserDefaults standardUserDefaults] boolForKey:signinkey])
    {
        loginref=1;
        [self.MenuTable reloadData];
    }
    else{
        loginref=0;
        [self.MenuTable reloadData];
    }
    timer= [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)4.0
                                            target:(id)self selector:@selector(cellchange)userInfo:(id)nil
                                           repeats:(BOOL)YES];
    self.navigationItem.title=@"NewsFeeds";
}
//changing collection view cell with respetct to timer
-(void)cellchange
{
    if(collectionindex==24)
    {
        collectionindex=0;
    }
    if(AllNewsArray.count>collectionindex+1)
    {
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:++collectionindex inSection:0];
    [self.CollectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

#pragma mark -TableView
//table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView==self.MenuTable)
    {
        return 7;
    }else
    {
        if (AllNews.count==0) {
            return 0;
        }else{
        return [[AllNews objectAtIndex:(selectedrow-1)] count];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==self.MenuTable)
    {
        static NSString *cellIdentifier = menutablecellid;
        MenuTableCell *cell = (MenuTableCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil)
        {
            cell = [[MenuTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        NSString *menu;
        if(loginref==1)
        {
            menu=[menulist1 objectAtIndex:indexPath.row];
        }
        else
        {
            menu=[menulist objectAtIndex:indexPath.row];
        }
        cell.MainLabel.text=menu;
        [cell.MainLabel sizeToFit];
        return cell;
    }
    if (tableView==self.FeedsTable)
    {   NSRange range;
        FeedsTableCell *cell = (FeedsTableCell*)[tableView dequeueReusableCellWithIdentifier:feedstablecellid forIndexPath:indexPath];
        [cell.FeedImage setImageWithURL:[NSURL URLWithString:[[[AllNews objectAtIndex:(selectedrow-1)] objectAtIndex:indexPath.row] valueForKey:@"image"] ] placeholderImage:nil];
        cell.FeedTitle.text = [[[AllNews objectAtIndex:(selectedrow-1)] objectAtIndex:indexPath.row] objectForKey: @"title"];
        cell.FeedDiscription.text = [[[AllNews objectAtIndex:(selectedrow-1)] objectAtIndex:indexPath.row] objectForKey:@"pubDate"];
//        [cell.FeedTitle setFont:[UIFont systemFontOfSize:15]];
//        cell.FeedTitle.numberOfLines=2;
        while ((range = [cell.FeedDiscription.text rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        cell.FeedDiscription.text = [cell.FeedDiscription.text stringByReplacingCharactersInRange:range withString:@""];
        [cell.FeedDiscription setFont:[UIFont systemFontOfSize:10]];
        cell.FeedDiscription.numberOfLines=1;
        [cell.FeedDiscription sizeToFit];
        return cell;
    }
    return NULL;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==self.MenuTable)
    {
        if(!(AllNews.count<indexPath.row)){
            menuclicked=0;
            [UIView animateWithDuration:0.5 animations:^{
                self.MenuTable.frame=CGRectMake(0, 65-offsety, 0,302);
                self.FeedsTable.frame=CGRectMake(0,240-offsety, 320, 320-offsety);
                self.CollectionView.frame=CGRectMake(0,-20-offsety, 320, 280);
            }completion:nil];
            if(indexPath.row==0)
            {
                [timer invalidate];
                timer=nil;
                [self performSegueWithIdentifier:tosigninviewcontroller sender:self];
            }else{
                selectedrow=indexPath.row;
                [self.FeedsTable reloadData];
            }
        }
    }
    if(tableView==self.FeedsTable)
    {
        selectedfeed=indexPath.row;
        [self performSegueWithIdentifier:todetailedviewcontroller sender:self];
    }
}

#pragma mark -CollectionView
//collectionview
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return AllNewsArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:collectioncellIdentifier
                                                                           forIndexPath:indexPath];
    if (cell==nil)
    {
        cell=[[CollectionCell alloc]init];
    }
    collectionindex=indexPath.row;
    [cell.CollectionImage setImageWithURL:[NSURL URLWithString:[[AllNewsArray objectAtIndex:indexPath.row] valueForKey:@"image"] ] placeholderImage:nil];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    didselectcollection=1;
    [self performSegueWithIdentifier:todetailedviewcontroller sender:nil];
}

#pragma mark -IB Action
//menu selector
- (IBAction)MenuButton{
    if(menuclicked==0)
    {
    [UIView animateWithDuration:0.5 animations:^{
        self.MenuTable.frame =  CGRectMake(0,65-offsety, 150, 302);
        self.FeedsTable.frame= CGRectMake(153, 240-offsety, 320, 320-offsety);
        self.CollectionView.frame=CGRectMake(153,-20-offsety, 320, 280);
        }completion:nil];
        menuclicked=1;
    }else
    {
    [UIView animateWithDuration:0.5 animations:^{
        self.MenuTable.frame=CGRectMake(0, 65-offsety, 0,302);
        self.FeedsTable.frame=CGRectMake(0,240-offsety, 320, 320-offsety);
        self.CollectionView.frame=CGRectMake(0,-20-offsety, 320, 280);
    }completion:nil];
    menuclicked=0;
    }
}

#pragma mark -Seague
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [timer invalidate];
    DetailedView *zoom = [segue destinationViewController];
    if([segue.identifier isEqualToString:@"DetailedView"])
    {
        if (didselectcollection==1)
        {
            //collection is selected
            [readarticle addObject:[AllNewsArray objectAtIndex:(collectionindex)]];
            zoom.feed=[AllNewsArray objectAtIndex:(collectionindex)];
            didselectcollection=0;
        }
        else if (selectedrow==7)
        {
            //search
            zoom.feed=[SearchedNewsArray objectAtIndex:selectedfeed];
            [readarticle addObject:[SearchedNewsArray objectAtIndex:(selectedfeed)]];
        }else
        {
            //feedstable
            zoom.feed=[[AllNews objectAtIndex:(selectedrow-1)] objectAtIndex:selectedfeed];
            [readarticle addObject:[[AllNews objectAtIndex:(selectedrow-1)]objectAtIndex:selectedfeed]];
        }
    }
    else
    {
        //user profile
        if(readarticle.count !=0)
        {
            PFUser *currentUser = [PFUser currentUser];
            if (currentUser) {
                PFObject *history = [PFObject objectWithClassName:@"history"];
                history[@"Feeds"] = readarticle;
                history[@"UserID"]=currentUser.username;
                [history save];
                [readarticle removeAllObjects];
            }
        }
    }
}

#pragma mark -Search

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [UIView animateWithDuration:0.5 animations:^{
        self.MenuTable.frame=CGRectMake(0, 65-offsety, 0,302);
        self.FeedsTable.frame=CGRectMake(0,60-offsety, 320, 500);
        self.CollectionView.frame=CGRectMake(0,0-offsety, 320, 0);
    }completion:nil];
    NSString *searchedlower=[search.text lowercaseString];
    SearchedNewsArray=[[NSMutableArray alloc] init];
    for (int j=0;j<[[AllNews objectAtIndex:(selectedrow-1)] count]; j++) {
        NSString *contentlower =[[[[AllNews objectAtIndex:(selectedrow-1)]objectAtIndex:j] valueForKey:@"content:encoded"] lowercaseString];
        NSString *titlelower=[[[[AllNews objectAtIndex:(selectedrow-1)]objectAtIndex:j] valueForKey:@"title"] lowercaseString];
        if (([contentlower rangeOfString:searchedlower].location == NSNotFound) && ([titlelower rangeOfString:searchedlower].location == NSNotFound))
        {
        } else {
            [SearchedNewsArray addObject:[[AllNews objectAtIndex:(selectedrow-1)]objectAtIndex:j]];
        }
    }
    if(AllNews.count==6)
    [AllNews addObject:SearchedNewsArray];
    [AllNews removeObjectAtIndex:6];
    selectedrow=7;
    [AllNews addObject:SearchedNewsArray];
    [search resignFirstResponder];
    //resetting navigation bar
    self.navigationItem.titleView=Nil;
    self.navigationItem.rightBarButtonItem=rightbutton;
    self.navigationItem.leftBarButtonItem=leftbutton;
    self.navigationItem.title=@"NewsFeeds";
    [self.FeedsTable reloadData];
}

 -(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([search.text isEqualToString:@""])
        
    {
        //resetting navigation bar
        [search resignFirstResponder];
        self.navigationItem.titleView=Nil;
        self.navigationItem.rightBarButtonItem=rightbutton;
        self.navigationItem.leftBarButtonItem=leftbutton;
        self.navigationItem.title=@"NewsFeeds";
        [self.FeedsTable reloadData];
    }
}

-(IBAction)clicksearchbutton
{
    //setting navigation bar when search button is clicked
    search= [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 400.0, 44.0)];
    search.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 400.0, 44.0)];
    searchBarView.autoresizingMask = 0;
    self.navigationItem.rightBarButtonItem=Nil;
    self.navigationItem.leftBarButtonItem=Nil;
    search.delegate = self;
    [searchBarView addSubview:search];
    self.navigationItem.titleView = searchBarView;
    [search becomeFirstResponder];
}

#pragma mark -PulltoRefresh
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self containingScrollViewDidEndDragging:scrollView];
}

- (void)containingScrollViewDidEndDragging:(UIScrollView *)containingScrollView
{
    if(containingScrollView==self.FeedsTable)
    {
        CGFloat minOffsetToTriggerRefresh = 70.0f;
        if (containingScrollView.contentOffset.y <= -minOffsetToTriggerRefresh) {
            [self refresh];
        }
    }
}

-(void)refresh
{
    if(selectedrow<7)
    {
        didrefresh=1;
        allnewsindex=0;
        [Loading show:YES];
        AllNewsArrayindex=0;
        [unsortednewsarray removeAllObjects];
        [SearchedNewsArray removeAllObjects];
        [feedpolitics startparse:[urlarray objectAtIndex:0]];
        [feedmovie startparse:[urlarray objectAtIndex:1]];
        [feedholliwood startparse:[urlarray objectAtIndex:2]];
        [feednational startparse:[urlarray objectAtIndex:3]];
        [feedsports startparse:[urlarray objectAtIndex:4]];
    }
}

#pragma mark -FeedparserDelegate
-(void)passfeeds:(NSDictionary *)passeddict
{
    [unsortednewsarray addObject:passeddict];
    if (didrefresh==1) {
        [AllNewsArray removeAllObjects];
        didrefresh=0;
    }
    for (int i=0; i<5; i++) {
        [AllNewsArray insertObject:[[[unsortednewsarray objectAtIndex:allnewsindex ] valueForKey:@"feeds"] objectAtIndex:i] atIndex:AllNewsArrayindex];
        AllNewsArrayindex++;
    }
    allnewsindex++;
    if(allnewsindex==5)
    {
        [AllNews removeAllObjects];
        for (int i=0; i<5;i++) {
            for (int j=0; j<5; j++) {
                if ([[unsortednewsarray objectAtIndex:j] valueForKey:@"url"]==[urlarray objectAtIndex:i]) {
                    [AllNews addObject:[[unsortednewsarray objectAtIndex:j] valueForKey:@"feeds"]];
                }
            }
        }
        [AllNews addObject:AllNewsArray];
        [self.FeedsTable reloadData];
        [Loading hide:YES];
        self.FeedsTable.tableHeaderView = feedsheaderView;
    }
    [self.CollectionView reloadData];
}

@end

