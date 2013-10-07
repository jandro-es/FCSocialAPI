//
//  FCTweetModel.m
//  FCSocialAPI
//
//  Created by Alejandro Barros on 10/8/13.
//  Copyright (c) 2013 Alejandro Barros. All rights reserved.
//

#import "FCTweetModel.h"

@implementation FCTweetModel

#pragma mark - Initializers
- (id)init
{
    self = [super init];
	if (self)
	{
        self.userIdStr = @"";
        self.userScreenName = @"";
        self.userName = @"";
        self.userId = [NSNumber numberWithInteger:-1];
        self.userTimeZone = @"";
        self.userLocation = @"";
        self.userDescription = @"";
        self.userFollowers = [NSNumber numberWithInteger:-1];
        self.userFriends = [NSNumber numberWithInteger:-1];
        self.userProfileImage = @"";
        
        self.tweetId = [NSNumber numberWithInteger:-1];
        self.mediaUrl = @"";
        self.text = @"";
        self.toUserId = [NSNumber numberWithInteger:-1];
        self.toUserScreeName = @"";
        self.replyToTweetId = [NSNumber numberWithInteger:-1];
        self.createdAt = [[NSDate alloc] init];
    }
    return self;
}

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
	if (self)
	{
        [self parseDictionary:data];
    }
    return self;
}

#pragma mark - Parser
- (void)parseDictionary:(NSDictionary *)data
{
    NSDictionary *userData = data[@"user"];
    self.userIdStr = userData[@"id_str"];
    self.userScreenName = userData[@"screen_name"];
    self.userId = [NSNumber numberWithInteger:[userData[@"id"] integerValue]];
    self.userName = userData[@"name"];
    self.userTimeZone = userData[@"time_zone"];
    self.userLocation = userData[@"location"];
    self.userDescription = userData[@"description"];
    self.userFollowers = [NSNumber numberWithInteger:[userData[@"followers_count"] integerValue]];
    self.userFriends = [NSNumber numberWithInteger:[userData[@"friends_count"] integerValue]];
    self.userProfileImage = userData[@"profile_image_url"];
    
    self.tweetId = [NSNumber numberWithInteger:[data[@"id"] integerValue]];
    self.text = data[@"text"];
    if (data[@"in_reply_to_user_id"] != [NSNull null])
    {
        self.toUserId = [NSNumber numberWithInteger:[data[@"in_reply_to_user_id"] integerValue]];
    } else {
        self.toUserId = [NSNumber numberWithInt:0];
    }
    if (data[@"in_reply_to_screen_name"] != [NSNull null]){
        self.toUserScreeName = data[@"in_reply_to_screen_name"];
    } else {
        self.toUserScreeName = @"";
    }
    if (data[@"in_reply_to_status_id"] != [NSNull null]){
       self.replyToTweetId = [NSNumber numberWithInteger:[data[@"in_reply_to_status_id"] integerValue]];
    } else {
        self.replyToTweetId = [NSNumber numberWithInt:0];
    }
    
    NSDateFormatter *frm = [[NSDateFormatter alloc] init];
    [frm setDateStyle:NSDateFormatterLongStyle];
    [frm setFormatterBehavior:NSDateFormatterBehavior10_4];
    [frm setDateFormat: @"EEE MMM dd HH:mm:ss Z yyyy"];
    self.createdAt = [frm dateFromString:data[@"created_at"]];
    
    NSDictionary *entities = data[@"entities"];
    NSArray *media = entities[@"media"];
    NSDictionary *mediaData = media[0];
    if (mediaData)
    {
        self.mediaUrl = mediaData[@"media_url"];
    } else {
        self.mediaUrl = @"";
    }
}

#pragma mark - Custom description
- (NSString *)description
{
    return [NSString stringWithFormat:@"\n\n### TWEET ###\n--------------------\nUser ScreenName: %@ \nUser name: %@\nUser Profile image = %@\nUser Location: %@\nUser description: %@\nUser follower: %@\nUser friends: %@\n--------------------\nTweet ID: %@\nTweet text: %@\nTweet created at: %@\nTweet media: %@\n\n", _userScreenName, _userName, _userProfileImage, _userLocation, _userDescription, _userFollowers, _userFriends, _tweetId, _text, _createdAt, _mediaUrl];
}
@end
