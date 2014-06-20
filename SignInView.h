//
//  SignInView.h
//  NewsFeeds
//
//  Created by qbadmin on 19/06/14.
//  Copyright (c) 2014 qbadmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>
@class GPPSignInButton;
@interface SignInView : UIViewController<GPPSignInDelegate>
@property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;
@property (weak, nonatomic) IBOutlet UIImageView *UserAvtar;
@property (weak, nonatomic) IBOutlet UILabel *UserNAme;
@property (weak, nonatomic) IBOutlet UILabel *EmailId;
@property(weak, nonatomic) IBOutlet UIButton *signOutButton;
- (IBAction)SignOutButton:(id)sender;
@end
