//
//  RootViewController.m
//  BasicSocial
//
//  Created by 鈴木 康弘 on 2014/06/24.
//  Copyright (c) 2014年 yasuhiro suzuki. All rights reserved.
//

#import "RootViewController.h"





//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
#pragma mark - interface of RootViewController

@interface RootViewController ()


@property (strong, nonatomic) IBOutlet UIButton *twitterButton;
@property (strong, nonatomic) IBOutlet UIButton *tweetButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;

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
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    _portrate = UIInterfaceOrientationIsPortrait(orientation);
    
    _items = [NSMutableArray array];
    
    [self initTwitterButton];
    [self initTweetButton];
    [self initFacebookButton];
    [self initShareButton];
}


//--------------------------------------------------------------------------------------------------
#pragma mark - util

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




- (void)createAccountStore
{
    if (_accountStore == nil) {
        _accountStore = [[ACAccountStore alloc] init];
    }
}




//--------------------------------------------------------------------------------------------------
#pragma mark - Twitter

- (void)initTwitterButton
{
    [self.twitterButton addTarget:self action:@selector(onTapTwitterButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onTapTwitterButton:(id)sender
{
    [self fetchTwitterAccount];
}


- (void)fetchTwitterAccount
{
    _twitterAccount = nil;
    [self createAccountStore];
    
    BOOL isTwitter = [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
    if (!isTwitter) {
        [self showAlert:@"Twitterアカウントが\n登録されていません" text:@"設定>Twitter より\nアカウントを登録してください。"];
        return;
    }
    
    //アカウント種別の取得
    ACAccountType *twitterType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    //アカウントの取得
    [_accountStore requestAccessToAccountsWithType:twitterType
        options:nil
        completion:^(BOOL granted, NSError *error) {
            //このcompletionブロックはメインスレッドではないため,UI操作などをするためにメインスレッドで動作するようにする。
            dispatch_async(dispatch_get_main_queue(), ^{
                //アカウント認証を許可した場合はgrandtedがYESとなる。
                //一度設定するとアラート画面がでなくなるので、ユーザー自身で設定画面から変更してもらう必要がある。
                if (granted) {
                    NSLog(@"allow twitter account");
                    NSArray *accounts = [_accountStore accountsWithAccountType:twitterType];
                    if (accounts.count > 0) {
                        NSLog(@"has twitter account");
                        if (accounts.count == 1) {
                            _twitterAccount = accounts[0];
                            [self showAlert:@"get twitter account" text:[NSString stringWithFormat:@"name:%@",_twitterAccount.username]];
                        } else {
                            [self createAccountList:accounts];
                        }
                        return;
                    }
                }
                
                //アカウントが登録されていないか、許可していない場合。
                [self showAlert:@"" text:@"Twitterアカウントが登録されていません"];
            });
        }];
}



//--------------------------------------------------------------------------------------------------
#pragma mark - Facebook

- (void)initFacebookButton
{
    [self.facebookButton addTarget:self action:@selector(onTapFacebookButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onTapFacebookButton:(id)sender
{
    [self fetchFacebookAccount];
}

- (void)fetchFacebookAccount
{
    _facebookAccount = nil;
    [self createAccountStore];
    
    BOOL isFacebook = [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook];
    if (!isFacebook) {
        [self showAlert:@"Facebookアカウントが\n登録されていません" text:@"設定>Facebook より\nアカウントを登録してください。"];
        //prefs:root=FACEBOOK
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs://"]];
        return;
    }
    
    //アカウント種別の取得
    ACAccountType *facebookType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    options[ACFacebookAppIdKey] = @"337191383103732";
//    options[ACFacebookPermissionsKey] = @[@"public_actions", @"publish_stream", @"offline_access"];
//    options[ACFacebookPermissionsKey] = @[];
    options[ACFacebookAudienceKey] = ACFacebookAudienceOnlyMe;
    
    //アカウントの取得
    [_accountStore requestAccessToAccountsWithType:facebookType
        options:options
        completion:^(BOOL granted, NSError *error) {
            //このcompletionブロックはメインスレッドではないため,UI操作などをするためにメインスレッドで動作するようにする。
            dispatch_async(dispatch_get_main_queue(), ^{
            //アカウント認証を許可した場合はgrandtedがYESとなる。
            //一度設定するとアラート画面がでなくなるので、ユーザー自身で設定画面から変更してもらう必要がある。
                NSLog(@"get facebook account");
            if (granted) {
                NSLog(@"arrow facebook account");
                NSArray *accounts = [_accountStore accountsWithAccountType:facebookType];
                if (accounts.count > 0) {
                    if (accounts.count == 1) {
                        _facebookAccount = accounts[0];
                    } else {
                        [self createAccountList:accounts];
                    }
                    return;
                }
            }
                
                NSLog(@"don't arrow facebook account");
                
            //アカウントを許可していない場合。
            [self showAlert:@"" text:@"Facebookアカウントが登録されていません"];
            });
        }];
}



//--------------------------------------------------------------------------------------------------
#pragma mark - Twitter tweet

- (void)initTweetButton
{
    [self.tweetButton addTarget:self action:@selector(onTapTweetButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onTapTweetButton:(id)sender
{
    [self createTweetWindow];
}

- (void)createTweetWindow
{
    SLComposeViewController *tweetVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetVC setInitialText:@"つぶやいてみます"];
    [self presentViewController:tweetVC
                       animated:YES
                     completion:^{
                         
                     }];
}



//--------------------------------------------------------------------------------------------------
#pragma mark - Facebook Share

- (void)initShareButton
{
    [self.shareButton addTarget:self action:@selector(onTapShareButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onTapShareButton:(id)sender
{
    [self createShareWindow];
}

- (void)createShareWindow
{
    SLComposeViewController *shareVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [shareVC setInitialText:@"シェアします"];
    [self presentViewController:shareVC
                       animated:YES
                     completion:^{
                         
                     }];
}



//--------------------------------------------------------------------------------------------------
#pragma mark - account list

- (void)createAccountList:(NSArray *)list
{
    AccountListViewController *accountListViewController = [[AccountListViewController alloc] initWithAccountList:list];
    accountListViewController.delegate = self;
    
    [self presentViewController:accountListViewController
                       animated:YES
                     completion:^{
                         
                     }];
}



//--------------------------------------------------------------------------------------------------
#pragma mark - AccountListViewControllerDelegate

- (void)accountListViewController:(AccountListViewController *)viewController
                 didSelectAccount:(ACAccount *)account
{
    NSLog(@"///////////////////");
    NSLog(@"RootViewController -> アカウント選択完了 アカウント名:%@", account);
    if (account) {
        if ([account.accountType isEqual:(ACAccountTypeIdentifierTwitter)]) {
            NSLog(@"Twitter アカウント");
            _twitterAccount = account;
            [self showAlert:@"get twitter account" text:[NSString stringWithFormat:@"name:%@",_twitterAccount.username]];
        } else if ([account.accountType isEqual:(ACAccountTypeIdentifierFacebook)]) {
            NSLog(@"Facebook アカウント");
            _facebookAccount = account;
        }
    }
}












@end
