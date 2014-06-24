//
//  RootViewController.m
//  BasicSocial
//
//  Created by 鈴木 康弘 on 2014/06/24.
//  Copyright (c) 2014年 yasuhiro suzuki. All rights reserved.
//

#import "RootViewController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>




//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
#pragma mark - interface of RootViewController

@interface RootViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UITableView *_tableView;
    BOOL _portrate;
    
    ACAccountStore *_accoountStore;
    ACAccount *_account;
    NSMutableArray *_items;
}

@property (strong, nonatomic) IBOutlet UIButton *twitterButton;

@end




//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
#pragma mark - @implementation of RootViewController

@implementation RootViewController


//--------------------------------------------------------------------------------------------------
#pragma mark - life cycle method

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
    [self initialize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




//--------------------------------------------------------------------------------------------------
#pragma mark - init

- (void)initialize
{
    self.title = @"Twitterクライアント";
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    _portrate = UIInterfaceOrientationIsPortrait(orientation);
    
    _items = [NSMutableArray array];
    
    [self initTwitterButton];
}


//--------------------------------------------------------------------------------------------------
#pragma mark - 

//データ->文字列
- (NSString *)data2str:(NSData *)data
{
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (void)showAlert:(NSString *)title text:(NSString *)text
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:text
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)setIndicator:(BOOL)indicator
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = indicator;
}

- (UILabel *)makeLabel:(CGRect)rect text:(NSString *)text font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] init];
    [label setFrame:rect];
    [label setText:text];
    [label setFont:font];
    [label setTextColor:[UIColor blackColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setNumberOfLines:0];
    [label setLineBreakMode:NSLineBreakByCharWrapping];
    return label;
}

- (UIImageView *)makeImageView:(CGRect)rect image:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:image];
    [imageView setFrame:rect];
    return imageView;
}




- (void)initTwitterAccount
{
    _account = nil;
    _accoountStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterType = [_accoountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [_accoountStore requestAccessToAccountsWithType:twitterType
                                            options:nil
                                         completion:^(BOOL granted, NSError *error) {
                                             if (granted) {
                                                 NSArray *accounts = [_accoountStore accountsWithAccountType:twitterType];
                                                 if (accounts.count > 0) {
                                                     _account = [accounts objectAtIndex:0];
//                                                     [self timeline];
                                                     
                                                     return;
                                                 }
                                             }
                                             [self showAlert:@"" text:@"Twitterアカウントが登録されていません"];
                                         }];
}


- (void)initTwitterButton
{
    [self.twitterButton addTarget:self action:@selector(onTapTwitterButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onTapTwitterButton:(id)sender
{
    [self initTwitterAccount];
}


//--------------------------------------------------------------------------------------------------
#pragma mark - UITableViewDelegate



//--------------------------------------------------------------------------------------------------
#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}


//--------------------------------------------------------------------------------------------------
#pragma mark - UITextFieldDelegate








@end
