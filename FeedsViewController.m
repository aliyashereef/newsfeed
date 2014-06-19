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

@interface FeedsViewController ()
{
    NSArray *menulist,*menulist1;
    NSURL *Politicsurl,*MoviewReiviewurl,*Sportsurl,*Hollywoodurl,*NationalInteresturl;
    NSMutableArray *AllNewsArray,*AllNews;
    int selectedrow,loginref,selectedfeed,didscroll,collectionindex,didselectcollection;
    NSTimer *timer;
}

@end

@implementation FeedsViewController

- (void)viewDidLoad
{
    int allnewsindex,allnewsindex1=0,allnewsindex2=0,allnewsindex3=0,allnewsindex4=0,allnewsindex5=0;
    [super viewDidLoad];
    selectedrow=5;
    FeedParse *feed;
    feed=[[FeedParse alloc] init];
    menulist=[NSArray arrayWithObjects:@"SignIn",@"Politics",@"Movie-Review",@"Hollywood",@"National-Interest",@"Sports",nil];
    menulist1= [NSArray arrayWithObjects:@"Sign Out",@"Politics",@"Movie-Review",@"Hollywood",@"National-Interest",@"Sports",nil];
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
    self.FeedsTable.frame=CGRectMake(0,280, 320, 516);
    self.CollectionView.frame=CGRectMake(0,0, 320, 280);
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"log"])
    {}
    else{
        loginref=1;
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


//tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView==self.MenuTable)
    {
        return 6;
    }else
    {
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
            menu=[menulist objectAtIndex:indexPath.row];
        }
        else
        {
            menu=[menulist1 objectAtIndex:indexPath.row];
        }
        
        cell.MainLabel.text=menu;
        [cell.MainLabel sizeToFit];
        
        
        return cell;
    }
    if (tableView==self.FeedsTable)
    {
        NSRange range;
        FeedsTableCell *cell = (FeedsTableCell*)[tableView dequeueReusableCellWithIdentifier:@"FeedMenu" forIndexPath:indexPath];
            cell.FeedTitle.text = [[[AllNews objectAtIndex:(selectedrow-1)] objectAtIndex:indexPath.row] objectForKey: @"title"];
            [cell.FeedTitle setFont:[UIFont systemFontOfSize:13]];
            [cell.FeedTitle setLineBreakMode:NSLineBreakByWordWrapping];
            cell.FeedTitle.numberOfLines = 2; //will wrap text in new line
            cell.FeedDiscription.text = [[[AllNews objectAtIndex:(selectedrow-1)] objectAtIndex:indexPath.row] objectForKey:@"description"];
            while ((range = [cell.FeedDiscription.text rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
                cell.FeedDiscription.text = [cell.FeedDiscription.text stringByReplacingCharactersInRange:range withString:@""];
            [cell.FeedDiscription setFont:[UIFont systemFontOfSize:10]];
            cell.FeedDiscription.numberOfLines=3;
            [cell.FeedDiscription sizeToFit];
            [cell.FeedImage setImageWithURL:[NSURL URLWithString:[[[AllNews objectAtIndex:(selectedrow-1)] objectAtIndex:indexPath.row] valueForKey:@"image"] ] placeholderImage:nil];
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
            if(loginref==1)
            {
                [self performSegueWithIdentifier:@"ClickView" sender:self];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"log"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                loginref=1;
                [self.MenuTable reloadData];
            }
        }
        selectedrow=indexPath.row;
        [self.FeedsTable reloadData];
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
{ DetailedView *zoom = [segue destinationViewController];
    if([segue.identifier isEqualToString:@"DetailedView"])
    {
        if (didselectcollection==1)
        {
            zoom.feed=[AllNewsArray objectAtIndex:(collectionindex)];
            didselectcollection=0;
        }
        else
        {
            zoom.feed=[[AllNews objectAtIndex:(selectedrow-1)] objectAtIndex:selectedfeed];
        }
    }
}


@end
