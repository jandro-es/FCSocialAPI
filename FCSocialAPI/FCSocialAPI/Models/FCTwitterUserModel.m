//
//  FCTwitterUserModel.m
//  FCSocialAPI
//
//  Created by Alejandro Barros on 10/5/13.
//  Copyright (c) 2013 Alejandro Barros. All rights reserved.
//

#import "FCTwitterUserModel.h"

@implementation FCTwitterUserModel

#pragma mark - Custom description
- (NSString *)description
{
    return [NSString stringWithFormat:@"\n### Twitter user ###\n--------------------\nScreen name: %@ \nUser name: %@\nProfile image = %@\nLocation: %@\nLanguaje: %@", _userScreenName, _userName, _userImage, _userLocation, _userLanguaje];
}

@end
