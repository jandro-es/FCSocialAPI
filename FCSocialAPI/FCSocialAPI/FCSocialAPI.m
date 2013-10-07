//
//  FCSocialAPI.m
//  FCSocialAPI
//
//  Created by Alejandro Barros on 10/5/13.
//  Copyright (c) 2013 Alejandro Barros. All rights reserved.
//

#import "FCSocialAPI.h"

@interface FCSocialAPI() <FCTwitterManagerDelegate>

@end

@implementation FCSocialAPI{

}

#pragma mark - Initializers
- (id)init
{
    self = [super init];
    if (self) {
        [[FCTwitterManager sharedInstance] setDelegate:self];
    }
    return self;
}

#pragma mark - Connections
- (void)connectTo:(FCSocialAPIMode)socialMode
{
    switch (socialMode) {
        case FCSocialAPITwitterMode:
            [[FCTwitterManager sharedInstance] startConnection];
            break;
        case FCSocialAPIFacebookMode:
            break;
    }
}

- (void)disconnectFrom:(FCSocialAPIMode)socialMode
{
    switch (socialMode) {
        case FCSocialAPITwitterMode:
            [[FCTwitterManager sharedInstance] endConnection];
            break;
        case FCSocialAPIFacebookMode:
            break;
    }
}

#pragma mark - Checks
- (BOOL)isConnectedTo:(FCSocialAPIMode)socialMode
{
    switch (socialMode) {
        case FCSocialAPITwitterMode:
            return [[FCTwitterManager sharedInstance] isConnected];
            break;
        case FCSocialAPIFacebookMode:
            return NO;
            break;
    }
    return NO;
}

#pragma mark - Twitter
- (FCTwitterUserModel *)getTwitterUser
{
    return [[FCTwitterManager sharedInstance] user];
}

- (void)fetchTweetsForHashtags:(NSArray *)hashtags withLimit:(NSUInteger)limit andLanguage:(NSString *)lang;
{
    [[FCTwitterManager sharedInstance] fetchTweetsForHastags:hashtags withLimit:limit andLanguage:lang];
}

#pragma mark - FCTwitterManagerDelegate
- (void)FCTwitterManager:(FCTwitterManager *)manager didChangeConnectionStatusTo:(NSUInteger)connectionStatus
{
    if ([_delegate respondsToSelector:@selector(FCSocialApi:connectionForMode:didChangeStatusTo:)])
    {
        [_delegate FCSocialApi:self connectionForMode:FCSocialAPITwitterMode didChangeStatusTo:connectionStatus];
    }
}

- (void)FCTwitterManager:(FCTwitterManager *)manager didCompleteTweetsRequestsWith:(NSDictionary *)tweets
{
    if ([_delegate respondsToSelector:@selector(FCSocialApi:tweetsRequestDidSuccessWith:)]){
        [_delegate FCSocialApi:self tweetsRequestDidSuccessWith:tweets];
    }
}

- (void)FCTwitterManager:(FCTwitterManager *)manager didFailedTweetsRequestsWithError:(NSError *)error
{
    if ([_delegate respondsToSelector:@selector(FCSocialApi:tweetsRequestDidFailWithError:)]){
        [_delegate FCSocialApi:self tweetsRequestDidFailWithError:error];
    }
}

- (void)FCTwitterManager:(FCTwitterManager *)manager didParseDataToTweet:(NSArray *)tweets
{
    if ([_delegate respondsToSelector:@selector(FCSocialApi:didParseDataToTweets:)]){
        [_delegate FCSocialApi:self didParseDataToTweets:tweets];
    }
}

#pragma mark - Singleton class method
+ (FCSocialAPI *)sharedInstance
{
    static FCSocialAPI *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[FCSocialAPI alloc] init];
    });
    return _sharedInstance;
}

@end
