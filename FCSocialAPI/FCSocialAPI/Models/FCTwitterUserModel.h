//
//  FCTwitterUserModel.h
//  FCSocialAPI
//
//  Created by Alejandro Barros on 10/5/13.
//  Copyright (c) 2013 Alejandro Barros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCTwitterUserModel : NSObject

@property (copy, nonatomic) NSString *userScreenName;
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSURL *userImage;
@property (copy, nonatomic) NSString *userLocation;
@property (copy, nonatomic) NSString *userLanguaje;
@property (nonatomic) NSUInteger userStatusesCount;
@property (nonatomic) NSUInteger userFriendsCount;

@end
