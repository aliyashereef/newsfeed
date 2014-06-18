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
    NSMutableArray *SportsArray,*PoliticsArray,*MoviewReiviewArray,*NationalInterestArray,*HollywoodArray,*AllNewsArray;
    int selectedrow,loginref,selectedfeed;
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
    SportsArray=[[NSMutableArray alloc] init];
    MoviewReiviewArray=[[NSMutableArray alloc] init];
    NationalInterestArray=[[NSMutableArray alloc] init];
    PoliticsArray=[[NSMutableArray alloc] init];
    HollywoodArray=[[NSMutableArray alloc] init];
    AllNewsArray=[[NSMutableArray alloc] init];
    SportsArray =[feed startparse:Sportsurl];
    MoviewReiviewArray=[feed startparse:MoviewReiviewurl];
    NationalInterestArray=[feed startparse:NationalInteresturl];
    HollywoodArray=[feed startparse:Hollywoodurl];
    PoliticsArray=[feed startparse:Politicsurl];
    for(allnewsindex=0;allnewsindex<=100;allnewsindex++)
    {
        if((allnewsindex%5)==0)
        {
            [AllNewsArray addObject:[PoliticsArray objectAtIndex:(allnewsindex1)]];
            allnewsindex1++;
        }
        if ((allnewsindex%5)==1) {
            [AllNewsArray addObject:[MoviewReiviewArray objectAtIndex:(allnewsindex2)]];
            allnewsindex2++;
        } else if ((allnewsindex%5)==2){
            [AllNewsArray addObject:[HollywoodArray objectAtIndex:(allnewsindex3)]];
            allnewsindex3++;
        }else if ((allnewsindex%5)==3){
            [AllNewsArray addObject:[NationalInterestArray objectAtIndex:(allnewsindex4)]];
            allnewsindex4++;
        }else if ((allnewsindex%5)==4){
            [AllNewsArray addObject:[SportsArray objectAtIndex:(allnewsindex5)]];
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
}
//tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView==self.MenuTable)
    {
        return 6;
    }else
    {
        if(selectedrow==1)
        {
            return PoliticsArray.count;        }
        else if (selectedrow==2)
        {
            return MoviewReiviewArray.count;
        }
        else if (selectedrow==3)
        {
            return HollywoodArray.count;
        }
        else if (selectedrow==4)
        {
            return NationalInterestArray.count;
        }
        else if (selectedrow==5)
        {
            return SportsArray.count;
        }
        return SportsArray.count;
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
        if(selectedrow==1)
        {
            cell.FeedTitle.text = [[PoliticsArray objectAtIndex:indexPath.row] objectForKey: @"title"];
            [cell.FeedTitle setFont:[UIFont systemFontOfSize:13]];
            [cell.FeedTitle setLineBreakMode:NSLineBreakByWordWrapping];
            cell.FeedTitle.numberOfLines = 2; //will wrap text in new line
            cell.FeedDiscription.text = [[PoliticsArray objectAtIndex:indexPath.row] objectForKey:@"description"];
            while ((range = [cell.FeedDiscription.text rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
                cell.FeedDiscription.text = [cell.FeedDiscription.text stringByReplacingCharactersInRange:range withString:@""];
            [cell.FeedDiscription setFont:[UIFont systemFontOfSize:10]];
            cell.FeedDiscription.numberOfLines=3;
            [cell.FeedDiscription sizeToFit];
            [cell.FeedImage setImageWithURL:[NSURL URLWithString:[[PoliticsArray objectAtIndex:indexPath.row] valueForKey:@"image"] ] placeholderImage:nil];
        }
        else if (selectedrow==2)
        {
            cell.FeedTitle.text = [[MoviewReiviewArray objectAtIndex:indexPath.row] objectForKey: @"title"];
            [cell.FeedTitle setFont:[UIFont systemFontOfSize:13]];
            [cell.FeedTitle setLineBreakMode:NSLineBreakByWordWrapping];
            cell.FeedTitle.numberOfLines = 2; //will wrap text in new line
            cell.FeedDiscription.text = [[MoviewReiviewArray objectAtIndex:indexPath.row] objectForKey:@"description"];
            while ((range = [cell.FeedDiscription.text rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
                cell.FeedDiscription.text = [cell.FeedDiscription.text stringByReplacingCharactersInRange:range withString:@""];
            [cell.FeedDiscription setFont:[UIFont systemFontOfSize:10]];
            cell.FeedDiscription.numberOfLines=3;
            [cell.FeedDiscription sizeToFit];
            [cell.FeedImage setImageWithURL:[NSURL URLWithString:[[MoviewReiviewArray objectAtIndex:indexPath.row] valueForKey:@"image"] ] placeholderImage:nil];
 
        }
        else if (selectedrow==3)
        {
            cell.FeedTitle.text = [[HollywoodArray objectAtIndex:indexPath.row] objectForKey: @"title"];
            [cell.FeedTitle setFont:[UIFont systemFontOfSize:13]];
            [cell.FeedTitle setLineBreakMode:NSLineBreakByWordWrapping];
            cell.FeedTitle.numberOfLines = 2; //will wrap text in new line
            cell.FeedDiscription.text = [[HollywoodArray objectAtIndex:indexPath.row] objectForKey:@"description"];
            while ((range = [cell.FeedDiscription.text rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
                cell.FeedDiscription.text = [cell.FeedDiscription.text stringByReplacingCharactersInRange:range withString:@""];
            [cell.FeedDiscription setFont:[UIFont systemFontOfSize:10]];
            cell.FeedDiscription.numberOfLines=3;
            [cell.FeedDiscription sizeToFit];
            [cell.FeedImage setImageWithURL:[NSURL URLWithString:[[HollywoodArray objectAtIndex:indexPath.row] valueForKey:@"image"] ] placeholderImage:nil];
        }
        else if (selectedrow==4)
        {
            cell.FeedTitle.text = [[NationalInterestArray objectAtIndex:indexPath.row] objectForKey: @"title"];
            [cell.FeedTitle setFont:[UIFont systemFontOfSize:13]];
            [cell.FeedTitle setLineBreakMode:NSLineBreakByWordWrapping];
            cell.FeedTitle.numberOfLines = 2; //will wrap text in new line
            cell.FeedDiscription.text = [[NationalInterestArray objectAtIndex:indexPath.row] objectForKey:@"description"];
            while ((range = [cell.FeedDiscription.text rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
                cell.FeedDiscription.text = [cell.FeedDiscription.text stringByReplacingCharactersInRange:range withString:@""];
            [cell.FeedDiscription setFont:[UIFont systemFontOfSize:10]];
            cell.FeedDiscription.numberOfLines=3;
            [cell.FeedDiscription sizeToFit];
            [cell.FeedImage setImageWithURL:[NSURL URLWithString:[[NationalInterestArray objectAtIndex:indexPath.row] valueForKey:@"image"] ] placeholderImage:nil];

        }
        else if (selectedrow==5)
        {
            cell.FeedTitle.text = [[SportsArray objectAtIndex:indexPath.row] objectForKey: @"title"];
            [cell.FeedTitle setFont:[UIFont systemFontOfSize:13]];
            [cell.FeedTitle setLineBreakMode:NSLineBreakByWordWrapping];
            cell.FeedTitle.numberOfLines = 2; //will wrap text in new line
            cell.FeedDiscription.text = [[SportsArray objectAtIndex:indexPath.row] objectForKey:@"description"];
            while ((range = [cell.FeedDiscription.text rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
                cell.FeedDiscription.text = [cell.FeedDiscription.text stringByReplacingCharactersInRange:range withString:@""];
            [cell.FeedDiscription setFont:[UIFont systemFontOfSize:10]];
            cell.FeedDiscription.numberOfLines=3;
            [cell.FeedDiscription sizeToFit];
            [cell.FeedImage setImageWithURL:[NSURL URLWithString:[[SportsArray objectAtIndex:indexPath.row] valueForKey:@"image"] ] placeholderImage:nil];

        }

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
    {   selectedfeed=indexPath.row;
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
    int r=indexPath.row;
    [cell.CollectionImage setImageWithURL:[NSURL URLWithString:[[AllNewsArray objectAtIndex:r] valueForKey:@"image"] ] placeholderImage:nil];
    return cell;
    
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
    DetailedView *zoom = [segue destinationViewController];
    if(selectedrow==1)
    {
        zoom.feed=[PoliticsArray objectAtIndex:(selectedfeed)];
    }
    else if (selectedrow==2)
    {
        zoom.feed=[MoviewReiviewArray objectAtIndex:(selectedfeed)];
    }
    else if (selectedrow==3)
    {
        zoom.feed=[HollywoodArray objectAtIndex:(selectedfeed)];
    }
    else if (selectedrow==4)
    {
        zoom.feed=[NationalInterestArray objectAtIndex:(selectedfeed)];
    }
    else if (selectedrow==5)
    {
        zoom.feed=[SportsArray objectAtIndex:(selectedfeed)];
    }
}


@end
