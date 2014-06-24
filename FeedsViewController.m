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
#import "UIImageView+WebCache.h"
#import "DetailedView.h"
#import "SignInView.h"
#import "Parse/Parse.h"
@interface FeedsViewController ()
{
    NSArray *menulist,*menulist1;
    NSURL *Politicsurl,*MoviewReiviewurl,*Sportsurl,*Hollywoodurl,*NationalInteresturl;
    NSMutableArray *AllNewsArray,*AllNews,*SearchedNewsArray,*readarticle;
    int selectedrow,loginref,selectedfeed,didscroll,collectionindex,didselectcollection,newssearched;
    NSTimer *timer;
    FeedParse *feed;
    
}

@end


@implementation FeedsViewController

- (void)viewDidLoad
{
    int allnewsindex,allnewsindex1=0,allnewsindex2=0,allnewsindex3=0,allnewsindex4=0,allnewsindex5=0;
    [super viewDidLoad];
    selectedrow=5;
    feed=[[FeedParse alloc] init];
    readarticle=[[NSMutableArray alloc] init];
    menulist=[NSArray arrayWithObjects:@"SignIn",@"Politics",@"Movie-Review",@"Hollywood",@"National-Interest",@"Sports",nil];
    menulist1= [NSArray arrayWithObjects:@"My Profile",@"Politics",@"Movie-Review",@"Hollywood",@"National-Interest",@"Sports",nil];
    MoviewReiviewurl =[NSURL URLWithString:@"http://indianexpress.com/section/entertainment/movie-review/feed/"];
    Politicsurl=[NSURL URLWithString:@"http://indianexpress.com/section/india/politics/feed/"];
    Sportsurl=[NSURL URLWithString:@"http://indianexpress.com/section/sports/feed/"];
    NationalInteresturl=[NSURL URLWithString:@"http://indianexpress.com/print/national-interest/feed/"];
    Hollywoodurl=[NSURL URLWithString:@"http://indianexpress.com/section/entertainment/hollywood/feed/"];
    AllNewsArray=[[NSMutableArray alloc] init];
    AllNews=[[NSMutableArray alloc] init];
    [AllNews addObject:[feed startparse:Politicsurl]];
    [AllNews addObject:[feed startparse:MoviewReiviewurl]];
    [AllNews addObject:[feed startparse:Hollywoodurl]];
    [AllNews addObject:[feed startparse:NationalInteresturl]];
    [AllNews addObject:[feed startparse:Sportsurl]];
    for(allnewsindex=0;allnewsindex<=50;allnewsindex++)
    {
        if((allnewsindex%5)==0)
        {
            [AllNewsArray addObject:[[AllNews objectAtIndex:(0)] objectAtIndex:(allnewsindex1)]];
            allnewsindex1++;
        }
        if ((allnewsindex%5)==1) {
            [AllNewsArray addObject:[[AllNews objectAtIndex:(1)] objectAtIndex:(allnewsindex2)]];
            allnewsindex2++;
        } else if ((allnewsindex%5)==2){
            [AllNewsArray addObject:[[AllNews objectAtIndex:(2)] objectAtIndex:(allnewsindex3)]];
            allnewsindex3++;
        }else if ((allnewsindex%5)==3){
            [AllNewsArray addObject:[[AllNews objectAtIndex:(3)] objectAtIndex:(allnewsindex4)]];
            allnewsindex4++;
        }else if ((allnewsindex%5)==4){
//            [AllNewsArray addObject:[[AllNewsArray objectAtIndex:(4)] objectAtIndex:(allnewsindex5)]];
            allnewsindex5++;
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewWillAppear:(BOOL)animated{
    self.MenuTable.frame=CGRectMake(0, 75, 0,360);
    self.FeedsTable.frame=CGRectMake(0,280, 320, 288);
    self.CollectionView.frame=CGRectMake(0,0, 320, 280);
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"log"])
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

}

-(void)cellchange
{
    if(collectionindex==24)
    {
        collectionindex=0;
    }

    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:++collectionindex inSection:0];
    [self.CollectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView==self.MenuTable)
    {
        return 6;
    }else
    {
        if(selectedrow==6)
            return SearchedNewsArray.count;
        return 50;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==self.MenuTable)
    {
        static NSString *cellIdentifier = @"MainMenu";
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
        FeedsTableCell *cell = (FeedsTableCell*)[tableView dequeueReusableCellWithIdentifier:@"FeedMenu" forIndexPath:indexPath];[cell.FeedImage setImageWithURL:[NSURL URLWithString:[[[AllNews objectAtIndex:(selectedrow-1)] objectAtIndex:indexPath.row] valueForKey:@"image"] ] placeholderImage:nil];
       
            cell.FeedTitle.text = [[[AllNews objectAtIndex:(selectedrow-1)] objectAtIndex:indexPath.row] objectForKey: @"title"];
            cell.FeedDiscription.text = [[[AllNews objectAtIndex:(selectedrow-1)] objectAtIndex:indexPath.row] objectForKey:@"description"];
            [cell.FeedTitle setFont:[UIFont systemFontOfSize:13]];
            [cell.FeedTitle setLineBreakMode:NSLineBreakByWordWrapping];
            cell.FeedTitle.numberOfLines = 2; //will wrap text in new line
                        while ((range = [cell.FeedDiscription.text rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
                cell.FeedDiscription.text = [cell.FeedDiscription.text stringByReplacingCharactersInRange:range withString:@""];
            [cell.FeedDiscription setFont:[UIFont systemFontOfSize:10]];
            cell.FeedDiscription.numberOfLines=3;
            [cell.FeedDiscription sizeToFit];
            
                return cell;
    }
    return NULL;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==self.MenuTable)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.MenuTable.frame=CGRectMake(0, 75, 0,600);
            self.FeedsTable.frame=CGRectMake(0,280, 320, 516);
            self.CollectionView.frame=CGRectMake(0,0, 320, 280);
        }completion:nil];
        if(indexPath.row==0)
        {
            [timer invalidate];
            timer=nil;
            [self performSegueWithIdentifier:@"SignInView" sender:self];
        }else{
        selectedrow=indexPath.row;
        [self.FeedsTable reloadData];
        }
    }
    if(tableView==self.FeedsTable)
    {
        selectedfeed=indexPath.row;
        [self performSegueWithIdentifier:@"DetailedView" sender:self];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 25;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CollectionID";
    CollectionCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
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
    [self performSegueWithIdentifier:@"DetailedView" sender:nil];
    
    
}

- (IBAction)MenuButton:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.MenuTable.frame =  CGRectMake(0,75, 150, 360);
        self.FeedsTable.frame= CGRectMake(153, 280, 320, 516);
        self.CollectionView.frame=CGRectMake(153,0, 320, 280);
        
    }completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [timer invalidate];
    DetailedView *zoom = [segue destinationViewController];
    if([segue.identifier isEqualToString:@"DetailedView"])
    {
        if (didselectcollection==1)
        {
            [readarticle addObject:[AllNewsArray objectAtIndex:(collectionindex)]];
            zoom.feed=[AllNewsArray objectAtIndex:(collectionindex)];
            didselectcollection=0;
        }
        else if (selectedrow==6)
        {
            zoom.feed=[SearchedNewsArray objectAtIndex:selectedfeed];
            [readarticle addObject:[SearchedNewsArray objectAtIndex:(selectedfeed)]];
        }else
        {
            zoom.feed=[[AllNews objectAtIndex:(selectedrow-1)] objectAtIndex:selectedfeed];
            [readarticle addObject:[[AllNews objectAtIndex:(selectedrow-1)]objectAtIndex:selectedfeed]];
        }
    }
    else
    {   if(readarticle.count !=0)
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
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [UIView animateWithDuration:0.5 animations:^{
        self.MenuTable.frame=CGRectMake(0, 75, 0,600);
        self.FeedsTable.frame=CGRectMake(0,60, 320, 500);
        self.CollectionView.frame=CGRectMake(0,0, 320, 0);
    }completion:nil];
    [self.NewsSearch resignFirstResponder];
    SearchedNewsArray=[[NSMutableArray alloc] init];
    for (int i=0; i<AllNews.count; i++) {
        for (int j=0;j<[[AllNews objectAtIndex:i] count]; j++) {
            if (([[[[AllNews objectAtIndex:i]objectAtIndex:j] valueForKey:@"content:encoded"] rangeOfString:self.NewsSearch.text].location == NSNotFound) && ([[[[AllNews objectAtIndex:i]objectAtIndex:j] valueForKey:@"title"] rangeOfString:self.NewsSearch.text].location == NSNotFound))
            {
                NSLog(@"string does not contain %@",self.NewsSearch.text);
            } else {
                NSLog(@"string contains %@",self.NewsSearch.text);
                [SearchedNewsArray addObject:[[AllNews objectAtIndex:i]objectAtIndex:j]];
            }
        }
    }
    [AllNews addObject:SearchedNewsArray];
    [AllNews removeObjectAtIndex:5];
    selectedrow=6;
    [AllNews addObject:SearchedNewsArray];
    [self.FeedsTable reloadData];
}
@end
