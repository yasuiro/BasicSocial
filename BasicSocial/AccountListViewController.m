//
//  AccountListViewController.m
//  BasicSocial
//
//  Created by 鈴木 康弘 on 2014/06/25.
//  Copyright (c) 2014年 yasuhiro suzuki. All rights reserved.
//

#import "AccountListViewController.h"



NSString *const kCellReuseIdentifier = @"Cell";




@interface AccountListViewController ()

@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *accountTableView;

@end




@implementation AccountListViewController

- (id)initWithAccountList:(NSArray *)list
{
    self = [super init];
    if (self) {
        _accountList = list;
    }
    return self;
}

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
    [self initCloseButton];
    [self initTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    
}







//--------------------------------------------------------------------------------------------------
#pragma mark - close button

- (void)initCloseButton
{
    [self.closeButton addTarget:self action:@selector(onTapCloseButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onTapCloseButton:(id)sender
{
    [self dismiss];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(accountListViewControllerDidDismiss:)]) {
            [self.delegate accountListViewControllerDidDismiss:self];
        }
    }];
}


- (void)initTableView
{
    self.accountTableView.delegate = self;
    self.accountTableView.dataSource = self;
    [self.accountTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
}



//--------------------------------------------------------------------------------------------------
#pragma mark - public method

- (void)setAccountList:(NSArray *)list
{
    
}


//--------------------------------------------------------------------------------------------------
#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier
                                                            forIndexPath:indexPath];
    if (!cell) {
        NSLog(@"AccountListViewController -> cellForRowAtIndexPath");
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:kCellReuseIdentifier];
    }
    
    ACAccount *account = _accountList[indexPath.row];
    cell.textLabel.text = account.username;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _accountList.count;
}


//--------------------------------------------------------------------------------------------------
#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACAccount *account = _accountList[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(accountListViewController:didSelectAccount:)]) {
        [self.delegate accountListViewController:self didSelectAccount:account];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self dismiss];
}








@end
