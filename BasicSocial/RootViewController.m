//
//  RootViewController.m
//  BasicSocial
//
//  Created by 鈴木 康弘 on 2014/06/24.
//  Copyright (c) 2014年 yasuhiro suzuki. All rights reserved.
//

#import "RootViewController.h"


NSString *const kFacebookAppID = @"1454427504805342";



//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
#pragma mark - interface of RootViewController

@interface RootViewController ()


@property (strong, nonatomic) IBOutlet UIButton *twitterButton;
@property (strong, nonatomic) IBOutlet UIButton *tweetButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet UIButton *sendToLineButton;
@property (strong, nonatomic) IBOutlet UIButton *facebookPostButton;
@property (strong, nonatomic) IBOutlet UIButton *twitterPostButton;

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
    [self initTwitterPostButton];
    [self initTweetButton];
    
    [self initFacebookButton];
    [self initFacebookPostButton];
    [self initShareButton];
    
    [self initSendToLineButton];
}


//--------------------------------------------------------------------------------------------------
#pragma mark - util

//データ->文字列
//- (NSString *)data2str:(NSData *)data
//{
//    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//}

- (void)showAlert:(NSString *)title text:(NSString *)text
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:text
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

//- (void)setIndicator:(BOOL)indicator
//{
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = indicator;
//}
//
//- (UILabel *)makeLabel:(CGRect)rect text:(NSString *)text font:(UIFont *)font
//{
//    UILabel *label = [[UILabel alloc] init];
//    [label setFrame:rect];
//    [label setText:text];
//    [label setFont:font];
//    [label setTextColor:[UIColor blackColor]];
//    [label setBackgroundColor:[UIColor clearColor]];
//    [label setTextAlignment:NSTextAlignmentLeft];
//    [label setNumberOfLines:0];
//    [label setLineBreakMode:NSLineBreakByCharWrapping];
//    return label;
//}
//
//- (UIImageView *)makeImageView:(CGRect)rect image:(UIImage *)image
//{
//    UIImageView *imageView = [[UIImageView alloc] init];
//    [imageView setImage:image];
//    [imageView setFrame:rect];
//    return imageView;
//}




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
        [self showAlert:@"Twitter"
                   text:@"アカウントが登録されていません。\n設定>Twitter より\nアカウントを登録してください。"];
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
                // アカウント認証を許可した場合はgrandtedがYESとなる。
                if (granted) {
                    NSArray *accounts = [_accountStore accountsWithAccountType:twitterType];
                    if (accounts.count > 0) {
                        if (accounts.count == 1) {
                            _twitterAccount = accounts[0];
                            [self showAlert:@"get twitter account" text:[NSString stringWithFormat:@"name:%@",_twitterAccount.username]];
                        } else {
                            [self createAccountList:accounts];
                        }
                        return;
                    }
                }
                
                // アカウントが登録されていないか、許可していない場合。
                // 一度設定するとアラート画面がでなくなるので、ユーザー自身で設定画面から変更してもらう必要がある。
                [self showAlert:@"Twitter" text:@"Twitterアカウントが登録されていません"];
            });
        }];
}



//--------------------------------------------------------------------------------------------------
#pragma mark - Post Twitter

- (void)initTwitterPostButton
{
    [self.twitterPostButton addTarget:self action:@selector(onTapForPostTwitter:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onTapForPostTwitter:(UIView *)sender
{
    NSLog(@"onTapForPostTwitter");
    [self postTwitter];
}

- (void)postTwitter
{
    if (_twitterAccount == nil) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"];
    NSDictionary *prameters = @{@"status": @"tweetします。"};
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:url parameters:prameters];
    [request setAccount:_twitterAccount];
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger statusCode = urlResponse.statusCode;
            if (statusCode >= 200 && statusCode < 300) {
                NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                NSLog(@"//////////");
                NSLog(@"Twitter post success : %@", response);
            } else {
                NSDictionary *errorResponse = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                NSLog(@"//////////");
                NSLog(@"Twitter post error : %@", errorResponse);
            }
        });
    }];
}



//--------------------------------------------------------------------------------------------------
#pragma mark - Authentication Facebook

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
        [self showAlert:@"Facebook"
                   text:@"アカウントが登録されていません。\n設定>Facebook より\nアカウントを登録してください。"];
        // memo:
        // アカウント登録されていない場合にsettingのアカウント項目に飛ばすようにしたいが、
        // どうやらiOS7からできなくなっているよう。
        // prefs:root=FACEBOOK
        // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs://"]];
        return;
    }
    
    //アカウント種別の取得
    ACAccountType *facebookType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    /*
    // memo:
    // 上記Facebookアカウントが登録されているかのチェックは以下の方法でも可能。
    NSArray *accounts = [_accountStore accountsWithAccountType:facebookType];
    if (accounts.count == 0) {
        //do something
        return;
    }
     //*/
    
    NSDictionary *options = @{ ACFacebookAppIdKey : kFacebookAppID,
                               ACFacebookAudienceKey : ACFacebookAudienceOnlyMe,
                               ACFacebookPermissionsKey : @[@"email"] };
    
    //アカウントの取得
    [_accountStore requestAccessToAccountsWithType:facebookType
        options:options
        completion:^(BOOL granted, NSError *error) {
//            NSDictionary *options2 = @{ ACFacebookAppIdKey : kFacebookAppID,
//                                       ACFacebookAudienceKey : ACFacebookAudienceOnlyMe,
//                                       ACFacebookPermissionsKey : @[@"publish_actions"] };
            
            //このcompletionブロックはメインスレッドではないため,UI操作などをするためにメインスレッドで動作するようにする。
            dispatch_async(dispatch_get_main_queue(), ^{
                //アカウント認証を許可した場合はgrandtedがYESとなる。
                //一度設定するとアラート画面がでなくなるので、ユーザー自身で設定画面から変更してもらう必要がある。
                NSLog(@"get facebook account");
                if (granted) {
                    // アカウント使用認証時にスタンダードなパーミッション以外を指定すると、
                    // 許可が通らないらしい。
                    // そのため、始めはemailを指定して許可を取った後、再度本当のパーミッションを取りに行く。
                    // パーミッションの種類については
                    // https://developers.facebook.com/docs/facebook-login/permissions/v2.0を参照。
                    [self authenticationPermission];
                } else {
                    //アカウントを許可していない場合。
                    [self showAlert:@"Facebook" text:@"Facebookに許可されていません"];
                }
            });
        }];
}

- (void)authenticationPermission
{
//    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    //アカウント種別の取得
    ACAccountType *facebookType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    // publish_actions or publish_stream
    NSDictionary *options = @{ ACFacebookAppIdKey : kFacebookAppID,
                               ACFacebookAudienceKey : ACFacebookAudienceOnlyMe,
                               ACFacebookPermissionsKey : @[@"email", @"publish_actions"] };
    
    //アカウントの取得
    [_accountStore requestAccessToAccountsWithType:facebookType
        options:options
        completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    NSArray *accounts = [_accountStore accountsWithAccountType:facebookType];
                    _facebookAccount = accounts[0];
                    [self showAlert:@"get facebook account" text:[NSString stringWithFormat:@"name:%@",_facebookAccount.username]];
                    NSString *email = [[_facebookAccount valueForKey:@"properties"] objectForKey:@"ACUIDisplayUsername"];
                    ACAccountCredential *facebookCredential = [_facebookAccount credential];
                    NSString *accessToken = [facebookCredential oauthToken];
                    NSLog(@"facebookCredential////\%@",facebookCredential);
                    NSLog(@"facebookAccessToken////\n%@",accessToken);
                    NSString *uid = [[_facebookAccount valueForKey:@"properties"] objectForKey:@"uid"];
                    NSLog(@"facebookID:%@", uid);
                    [self getPermissions];
                } else {
                    //アカウントを許可していない場合。
                    [self showAlert:@"Facebook" text:@"Permissionが許可されていません"];
                }
            });
        }];
}

- (void)getPermissions
{
    NSString *uid = [[_facebookAccount valueForKey:@"properties"] objectForKey:@"uid"];
    NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/v2.0/%@/permissions", uid];
//    ACAccountCredential *facebookCredential = [_facebookAccount credential];
//    NSString *accessToken = [facebookCredential oauthToken];
//    NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/v2.0/me?access_token=%@", accessToken];
    
    NSURL *url = [NSURL URLWithString:urlString];
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:nil];
    request.account = _facebookAccount;
//    [request setAccount:_facebookAccount];
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:0
                                                                       error:nil];
            NSLog(@"facebook get permissions result ///\n %@", response);
        });
    }];
}


//--------------------------------------------------------------------------------------------------
#pragma mark - Post Feed for Facebook

- (void)initFacebookPostButton
{
    [self.facebookPostButton addTarget:self action:@selector(onTapForPostFacebook:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onTapForPostFacebook:(UIView *)sender
{
    [self postFeed];
}

- (void)postFeed
{
    if (_facebookAccount == nil) {
        return;
    }
    
    NSString *uid = [[_facebookAccount valueForKey:@"properties"] objectForKey:@"uid"];
    NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/v2.0/%@/feed", uid];
    NSURL *url = [NSURL URLWithString:urlString];
    NSDictionary *parameters = @{@"message" : @"投稿してみました。"};
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodPOST
                                                      URL:url
                                               parameters:parameters];
    [request setAccount:_facebookAccount];
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSUInteger statusCode = urlResponse.statusCode;
            if (statusCode >= 200 && statusCode < 300) {
                NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData
                                                                         options:0
                                                                           error:nil];
                NSLog(@"facebook post feed result /// %@", response);
                NSString *resultMessage = [NSString stringWithFormat:@"投稿完了しました。\n%@", response[@"id"]];
                [self showAlert:@"Facebook" text:resultMessage];
            } else {
                NSDictionary *errorResponse = [NSJSONSerialization JSONObjectWithData:responseData
                                                                              options:0
                                                                                error:nil];
                NSLog(@"facebook post feed error /// %@", errorResponse);
                NSString *errorMessage = [NSString stringWithFormat:@"error:%@", errorResponse[@"error"][@"message"]];
                [self showAlert:@"Facebook" text:errorMessage];
            }
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
    // memo:
    // アカウントが複数登録されている場合はアカウントを選択できる項目が自動で追加される。
    // アカウントが登録されていない場合は、
    SLComposeViewController *tweetVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetVC setInitialText:@"つぶやいてみます"];
    [self presentViewController:tweetVC
                       animated:YES
                     completion:^{
                         
                     }];
}



//--------------------------------------------------------------------------------------------------
#pragma mark - Share Facebook

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
#pragma mark - Send Line

- (void)initSendToLineButton
{
    [self.sendToLineButton addTarget:self action:@selector(onTapSendToLineButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onTapSendToLineButton:(id)sender
{
    [self sendToLine];
}

- (void)sendToLine
{
    NSString *message = @"Lineに送ります。";
    message = [message stringByAppendingString:@" http://yahoo.co.jp"];
    message = [message stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"line://msg/text/%@", message];
    NSURL *url = [NSURL URLWithString:urlString];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        [self showAlert:@"" text:@"Lineがインストールされていません"];
    }
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
        _twitterAccount = account;
        [self showAlert:@"get twitter account" text:[NSString stringWithFormat:@"name:%@",_twitterAccount.username]];
//        if ([account.accountType isEqual:(ACAccountTypeIdentifierTwitter)]) {
//            NSLog(@"///////////////////");
//            NSLog(@"Twitter アカウント");
//            _twitterAccount = account;
//            [self showAlert:@"get twitter account" text:[NSString stringWithFormat:@"name:%@",_twitterAccount.username]];
//        } else if ([account.accountType isEqual:(ACAccountTypeIdentifierFacebook)]) {
//            NSLog(@"Facebook アカウント");
//            _facebookAccount = account;
//        }
    }
}












@end
