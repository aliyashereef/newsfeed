//
//  SignInView.m
//  NewsFeeds
//
//  Created by Vineeth on 19/06/14.
//  Copyright (c) 2014 Vineeth. All rights reserved.
//

#import "SignInView.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import <Parse/Parse.h>
#import "HistoryTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "DetailedView.h"
#import "Constants.h"
static NSString * const kPlaceholderUserName = @"";
static NSString * const kPlaceholderEmailAddress = @"";
static NSString * const kPlaceholderAvatarImageName = @"PlaceholderAvatar.png";
static NSString * const kClientId = @"547022631962-gaibvaqbko16bqqn1vspjd70or1g9a8r.apps.googleusercontent.com";

@interface SignInView ()
{
    GPPSignIn *signIn;
    NSMutableArray *historyarray;
    int offsety;
    NSInteger historyindex;
}

@end

@implementation SignInView

@synthesize signInButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -GPPSignIn
- (void)viewDidLoad
{
    NSString *version = [[UIDevice currentDevice] systemVersion];
    int ver = [version intValue];
    if (ver < 7){
        offsety=64;
        self.UserAvtar.frame=CGRectMake(20,90-offsety, 83, 75);
        self.UserNAme.frame=CGRectMake(122,90-offsety, 178, 21);
        self.EmailId.frame=CGRectMake(122,111-offsety,178, 21);
        self.signOutButton.frame=CGRectMake(33,173-offsety,56, 30);
        self.signInButton.frame=CGRectMake(20,173-offsety,134, 62);
        self.HistoryTable.frame=CGRectMake(20,251-offsety,280, 310);
        self.historylabel.frame=CGRectMake(20,222-offsety,83, 21);
        //iOS 6 work
    }
    else{
        //iOS 7 related work
    }
    //initialising sign in button
    [super viewDidLoad];
    signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.delegate = self;
    signIn.clientID = kClientId;
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];
    [signIn trySilentAuthentication];
}

- (void) viewWillAppear:(BOOL)animated
{
    self.signOutButton.hidden=YES;
    self.historylabel.hidden=YES;
    [signIn trySilentAuthentication];
    historyarray=[[NSMutableArray alloc] init];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    [self reportAuthStatus];
}

- (void)reportAuthStatus {
    if ([GPPSignIn sharedInstance].authentication) {
    } else {
        // To authenticate, use Google+ sign-in button.
    }
    [self refreshUserInfo];
}

// Update the interface elements containing user data to reflect the
// currently signed in user.
- (void)refreshUserInfo {
    if ([GPPSignIn sharedInstance].authentication == nil) {
        self.UserNAme.text= kPlaceholderUserName;
        self.EmailId.text = kPlaceholderEmailAddress;
        self.UserAvtar.image = [UIImage imageNamed:kPlaceholderAvatarImageName];
        return;
    }
    self.EmailId.text = [GPPSignIn sharedInstance].userEmail;
    // The googlePlusUser member will be populated only if the appropriate
    // scope is set when signing in.
    GTLPlusPerson *person = [GPPSignIn sharedInstance].googlePlusUser;
    if (person == nil) {
        return;
    }
    
    self.UserNAme.text = person.displayName;
    
    // Load avatar image asynchronously, in background
    dispatch_queue_t backgroundQueue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(backgroundQueue, ^{
        NSData *avatarData = nil;
        NSString *imageURLString = person.image.url;
        if (imageURLString) {
            NSURL *imageURL = [NSURL URLWithString:imageURLString];
            avatarData = [NSData dataWithContentsOfURL:imageURL];
        }
        if (avatarData) {
            // Update UI from the main thread when available
            dispatch_async(dispatch_get_main_queue(), ^{
                self.UserAvtar.image = [UIImage imageWithData:avatarData];
            });
        }
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshInterfaceBasedOnSignIn {
    if ([[GPPSignIn sharedInstance] authentication]) {
        // The user is signed in.
        self.signInButton.hidden = YES;
        self.signOutButton.hidden=NO;
        // Perform other actions here, such as showing a sign-out button
    } else {
        self.signInButton.hidden = NO;
        self.signOutButton.hidden=YES;
        // Perform other actions here
    }
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    NSLog(@"Received error %@ and auth object %@",error, auth);
    if (error) {
        // Do some error handling here.
    } else {
        NSLog(@"Received auth %@", auth);
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:signinkey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.signOutButton.hidden=NO;
        self.signOutButton.highlighted=YES;
        self.historylabel.hidden=NO;
        [self reportAuthStatus];
        [self refreshInterfaceBasedOnSignIn];
        //registering user into parse
        PFUser *user = [PFUser user];
        user.username =self.EmailId.text;
        user.password =self.UserNAme.text;
        [user signUp];
        //fetching user history
        [PFUser logInWithUsernameInBackground:self.EmailId.text password:self.UserNAme.text
                                        block:^(PFUser *user, NSError *error) {}];
        PFQuery *history = [PFQuery queryWithClassName:@"history"];
        [history orderByAscending:@"createdAt"];
        [history whereKey:@"UserID" equalTo:self.EmailId.text];
        [history  findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                for(NSInteger i=objects.count;i>0;i--){
                    for (NSInteger j=[[[objects objectAtIndex:(i-1)]valueForKey:@"Feeds"] count];j>0;j--){
                        [historyarray addObject:[[[objects objectAtIndex:(i-1)] valueForKey:@"Feeds"]   objectAtIndex:(j-1)]];
                    }
                }
                [self.HistoryTable reloadData];
                    } else {
            // Log details of the failure
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
        }];
    }
}

- (IBAction)SignOutButton:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:signinkey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[GPPSignIn sharedInstance] signOut];
    [PFUser logOut];
    [historyarray removeAllObjects];
    [self.HistoryTable reloadData];
    [self refreshInterfaceBasedOnSignIn];
    [self reportAuthStatus];
    self.signOutButton.hidden=YES;
    self.historylabel.hidden=YES;
}

- (void)updateButtons {
    BOOL authenticated = ([GPPSignIn sharedInstance].authentication != nil);
    self.signInButton.enabled = !authenticated;
    self.signOutButton.enabled = authenticated;
    if (authenticated) {
        self.signInButton.alpha = 0.5;
        self.signOutButton.alpha =1.0;
    } else {
        self.signInButton.alpha = 1.0;
        self.signOutButton.alpha = 0.5;
    }
}

#pragma mark -HistoryTable
//tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(historyarray.count<maxnoofhistory)
    {
        return historyarray.count;
    }else
    {
        return maxnoofhistory;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSRange range;
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"history" forIndexPath:indexPath];
    cell.HistoryTitle.text=[[historyarray objectAtIndex:indexPath.row] objectForKey: @"title"];
    cell.HistoryDiscription.text=[[historyarray objectAtIndex:indexPath.row] objectForKey:@"pubDate"];
    [cell.HistoryImage setImageWithURL:[NSURL URLWithString:[[historyarray objectAtIndex:indexPath.row] valueForKey:@"image"] ] placeholderImage:nil];
    [cell.HistoryTitle setFont:[UIFont systemFontOfSize:13]];
    [cell.HistoryTitle setLineBreakMode:NSLineBreakByWordWrapping];
    cell.HistoryTitle.numberOfLines = 2; //will wrap text in new line
    while ((range = [cell.HistoryDiscription.text rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        cell.HistoryDiscription.text = [cell.HistoryDiscription.text stringByReplacingCharactersInRange:range withString:@""];
    [cell.HistoryDiscription setFont:[UIFont systemFontOfSize:10]];
    cell.HistoryDiscription.numberOfLines=1;
    [cell.HistoryDiscription sizeToFit];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    historyindex=indexPath.row;
    [self performSegueWithIdentifier:signinviewtodetailedview sender:self];
}

#pragma mark -Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailedView *zoom = [segue destinationViewController];
    if([segue.identifier isEqualToString:signinviewtodetailedview])
    {
        zoom.feed=[historyarray objectAtIndex:historyindex];
    }
}

@end
