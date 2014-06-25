//
//  RootViewController.h
//  BasicSocial
//
//  Created by 鈴木 康弘 on 2014/06/24.
//  Copyright (c) 2014年 yasuhiro suzuki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "AccountListViewController.h"

@interface RootViewController : UIViewController <AccountListViewControllerDelegate>
{
    BOOL _portrate;
    
    ACAccountStore *_accountStore;
    ACAccount *_twitterAccount;
    ACAccount *_facebookAccount;
    
    NSMutableArray *_items;
}


@end
