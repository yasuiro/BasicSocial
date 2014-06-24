//
//  Status.m
//  BasicSocial
//
//  Created by 鈴木 康弘 on 2014/06/24.
//  Copyright (c) 2014年 yasuhiro suzuki. All rights reserved.
//

#import "Status.h"



//--------------------------------------------------------------------------------------------------
#pragma mark - interface of Status

@interface Status()

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *iconURL;
@property (strong, nonatomic) UIImage *icon;

@end





//--------------------------------------------------------------------------------------------------
#pragma mark - implementation of Status

@implementation Status

- (id)init
{
    self = [super init];
    if (self) {
        _name = nil;
        _text = nil;
        _iconURL = nil;
        _icon = nil;
    }
    return self;
}

@end
