//
//  SignInView.h
//  NewsFeeds
//
//  Created by Vineeth on 19/06/14.
//  Copyright (c) 2014 Vineeth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>

@class GPPSignInButton;

@interface SignInView : UIViewController<GPPSignInDelegate,UITableViewDelegate>
    @property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;
    @property (weak, nonatomic) IBOutlet UIImageView *UserAvtar;
    @property (weak, nonatomic) IBOutlet UILabel *UserNAme;
    @property (weak, nonatomic) IBOutlet UILabel *EmailId;
    @property(weak, nonatomic) IBOutlet UIButton *signOutButton;
    @property (weak, nonatomic) IBOutlet UITableView *HistoryTable;
@property (weak, nonatomic) IBOutlet UILabel *historylabel;
    - (IBAction)SignOutButton:(id)sender;
@end
