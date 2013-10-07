//
//  FCTweetModel.h
//  FCSocialAPI
//
//  Created by Alejandro Barros on 10/8/13.
//  Copyright (c) 2013 Alejandro Barros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCTweetModel : NSObject

@property (strong, nonatomic) NSString *userIdStr;
@property (strong, nonatomic) NSString *userScreenName;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSString *userTimeZone;
@property (strong, nonatomic) NSString *userLocation;
@property (strong, nonatomic) NSString *userDescription;
@property (strong, nonatomic) NSNumber *userFollowers;
@property (strong, nonatomic) NSNumber *userFriends;
@property (strong, nonatomic) NSString *userProfileImage;

@property (strong, nonatomic) NSNumber *tweetId;
@property (strong, nonatomic) NSString *mediaUrl;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSNumber *toUserId;
@property (strong, nonatomic) NSString *toUserScreeName;
@property (strong, nonatomic) NSNumber *replyToTweetId;
@property (strong, nonatomic) NSDate *createdAt;

- (id)init;
- (id)initWithData:(NSDictionary *)data;

@end
