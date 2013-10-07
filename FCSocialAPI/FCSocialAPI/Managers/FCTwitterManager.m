//
//  FCTwitterManager.m
//  FCSocialAPI
//
//  Created by Alejandro Barros on 10/5/13.
//  Copyright (c) 2013 Alejandro Barros. All rights reserved.
//

#import "FCTwitterManager.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "FCTweetModel.h"

@interface FCTwitterManager()

@end

@implementation FCTwitterManager{
    ACAccount *_activeAccount;
}

#pragma mark - Connection
- (void)startConnection
{
    if (!_isConnected){
        ACAccountStore *account = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        [account requestAccessToAccountsWithType:accountType
                                         options:nil
                                      completion:^(BOOL granted, NSError *error){
                                          NSArray *accounts = [account accountsWithAccountType:accountType];
                                          if (granted && [accounts count] > 0){
                                              _isConnected = YES;
                                              [self notifyDelegateForConnectionStatusChangeTo:FCSocialAPIConnectionStatusSuccess];
                                              [self startTwitterValuesFor:account withType:accountType];
                                          } else {
                                              [self notifyDelegateForConnectionStatusChangeTo:FCSocialAPIConnectionStatusFailed];
                                              _isConnected = NO;
                                              self.user = nil;
                                          }
                                      }];
    }
}

- (void)endConnection
{
    _activeAccount = nil;
    _user = nil;
    _isConnected = NO;
    [self notifyDelegateForConnectionStatusChangeTo:FCSocialAPIConnectionStatusEnded];
}

- (void)startTwitterValuesFor:(ACAccountStore *)account withType:(ACAccountType *)accountType
{
    NSArray *accounts = [account accountsWithAccountType:accountType];

    _activeAccount = [accounts firstObject];
    [self fetchDataForAccount:_activeAccount];
}

#pragma mark - Checks
- (BOOL)isConnectedToTwitter
{
    return _isConnected;
}

#pragma mark - Requests
- (void)fetchDataForAccount:(ACAccount *)account
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TwitterURLS" ofType:@"plist"];
    NSDictionary *urls = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSString *userPath = [urls objectForKey:@"user_data"];
    userPath = [NSString stringWithFormat:userPath, account.username];
    
    SLRequest *aRequest  = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                              requestMethod:SLRequestMethodGET
                                                        URL:[NSURL URLWithString:userPath]
                                                 parameters:nil];
    aRequest.account = account;
    [aRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){
        if ([urlResponse statusCode] == 200){
            NSError *parseError = nil;
            NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                                 options:NSJSONReadingMutableLeaves
                                                                   error:&parseError];
            if (data){
                [self createUserWithDictionary:data];
            } else {
                self.user = nil;
            }
        } else {
            self.user = nil;
        }
    }];
}

- (void)fetchTweetsForHastags:(NSArray *)hashtags withLimit:(NSUInteger)limit andLanguage:(NSString *)lang
{
    if (_isConnected){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"TwitterURLS" ofType:@"plist"];
        NSDictionary *urls = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSString *searchPath = [urls objectForKey:@"tag_search"];
        
        NSMutableString *tagsquery = [[NSMutableString alloc] initWithCapacity:2];
        NSUInteger index = 0;
        for (NSString *tag in hashtags)
        {
            if (index != 0) {
                [tagsquery appendString:@" OR "];
            }
            [tagsquery appendString:tag];
            index++;
        }
        tagsquery = [[tagsquery stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding] mutableCopy];
        NSDictionary *queryParams;
        if (lang)
        {
            queryParams = @{@"q": tagsquery, @"count" : [NSString stringWithFormat:@"%d", limit], @"lang" : lang};
        } else {
            queryParams = @{@"q": tagsquery, @"count" : [NSString stringWithFormat:@"%d", limit]};
        }

        SLRequest *aRequest  = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                  requestMethod:SLRequestMethodGET
                                                            URL:[NSURL URLWithString:searchPath]
                                                     parameters:queryParams];
        aRequest.account = _activeAccount;
        [aRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){
            if ([urlResponse statusCode] == 200){
                NSError *parseError = nil;
                NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:NSJSONReadingMutableLeaves
                                                                       error:&parseError];
                if ([_delegate respondsToSelector:@selector(FCTwitterManager:didCompleteTweetsRequestsWith:)]){
                    [_delegate FCTwitterManager:self didCompleteTweetsRequestsWith:data];
                }
                [self createTweetsCollectionWith:data];
            } else {
                if ([_delegate respondsToSelector:@selector(FCTwitterManager:didFailedTweetsRequestsWithError:)]){
                    [_delegate FCTwitterManager:self didFailedTweetsRequestsWithError:error];
                }
            }
        }];
    }
    
}

#pragma mark - Data fillers & parsers
- (void)createUserWithDictionary:(NSDictionary *)aDictionary
{
    if (self.user == nil) self.user = [[FCTwitterUserModel alloc] init];
    
    _user.userScreenName = _activeAccount.username;
    _user.userName = [aDictionary objectForKey:@"name"];
    _user.userImage = [aDictionary objectForKey:@"profile_image_url"];
    _user.userLocation = [aDictionary objectForKey:@"location"];
    _user.userLanguaje = [aDictionary objectForKey:@"lang"];
    _user.userStatusesCount = [[aDictionary objectForKey:@"statuses_count"] unsignedIntegerValue];
    _user.userFriendsCount = [[aDictionary objectForKey:@""] unsignedIntegerValue];
    
    NSLog(@"%@", _user);
}

- (void)createTweetsCollectionWith:(NSDictionary *)data
{
    if (data){
        NSArray *statuses = [data objectForKey:@"statuses"];
        if ([statuses count] > 0){
            NSMutableArray *tweetCollection = [[NSMutableArray alloc] initWithCapacity:10];
            for (NSDictionary* entry in statuses)
            {
                FCTweetModel *tweet = [[FCTweetModel alloc] initWithData:entry];
                [tweetCollection addObject:tweet];
            }
            if ([_delegate respondsToSelector:@selector(FCTwitterManager:didParseDataToTweet:)]){
                [_delegate FCTwitterManager:self didParseDataToTweet:[tweetCollection copy]];
            }
        }
    }
}

#pragma mark - Singleton class method
+ (FCTwitterManager *)sharedInstance
{
    static FCTwitterManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[FCTwitterManager alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - Delegate notifications
- (void)notifyDelegateForConnectionStatusChangeTo:(FCSocialAPIConnectionStatus)status
{
    if ([self.delegate respondsToSelector:@selector(FCTwitterManager:didChangeConnectionStatusTo:)])
    {
        [_delegate FCTwitterManager:self didChangeConnectionStatusTo:status];
    }
}
@end
