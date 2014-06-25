//
//  AccountListViewController.h
//  BasicSocial
//
//  Created by 鈴木 康弘 on 2014/06/25.
//  Copyright (c) 2014年 yasuhiro suzuki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>


extern NSString *const kCellReuseIdentifier;


@protocol AccountListViewControllerDelegate;


@interface AccountListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_accountList;
}

@property (nonatomic, strong) id<AccountListViewControllerDelegate> delegate;

- (id)initWithAccountList:(NSArray *)list;

@end



@protocol AccountListViewControllerDelegate <NSObject>

  @optional
- (void)accountListViewController:(AccountListViewController *)viewController didSelectAccount:(ACAccount *)account;
- (void)accountListViewControllerDidDismiss:(AccountListViewController *) viewController;

@end
