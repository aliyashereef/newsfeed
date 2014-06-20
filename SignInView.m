//
//  SignInView.m
//  NewsFeeds
//
//  Created by qbadmin on 19/06/14.
//  Copyright (c) 2014 qbadmin. All rights reserved.
//

#import "SignInView.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
@interface SignInView ()
{
    GPPSignIn *signIn;
}

@end
static NSString * const kPlaceholderUserName = @"<Name>";
static NSString * const kPlaceholderEmailAddress = @"<Email>";
static NSString * const kPlaceholderAvatarImageName = @"PlaceholderAvatar.png";
static NSString * const kClientId = @"547022631962-gaibvaqbko16bqqn1vspjd70or1g9a8r.apps.googleusercontent.com";
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    // You previously set kClientId in the "Initialize the Google+ client" step
    
    signIn.delegate = self;

    signIn.clientID = kClientId;
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
//    signIn.scopes = @[ @"profile" ];            // "profile" scope
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
    // Do any additional setup after loading the view.
    [signIn trySilentAuthentication];
}
- (void) viewWillAppear:(BOOL)animated
{   [signIn trySilentAuthentication];
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


- (void)presentSignInViewController:(UIViewController *)viewController {
    // This is an example of how you can implement it if your app is navigation-based.
    [[self navigationController] pushViewController:viewController animated:YES];
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
        self.signOutButton.enabled=YES;
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
        self.signOutButton.hidden=NO;
        [self reportAuthStatus];

        [self refreshInterfaceBasedOnSignIn];
    }
}
- (void)signOut {
    [[GPPSignIn sharedInstance] signOut];
}
- (void)disconnect {
    [[GPPSignIn sharedInstance] disconnect];
}

- (void)didDisconnectWithError:(NSError *)error {
    if (error) {
        NSLog(@"Received error %@", error);
    } else {
        // The user is signed out and disconnected.
        // Clean up user data as specified by the Google+ terms.
    }
}

- (IBAction)SignOutButton:(id)sender {
    [self signOut];
    [self refreshInterfaceBasedOnSignIn];
    [self reportAuthStatus];
    self.signOutButton.hidden=YES;
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

@end
