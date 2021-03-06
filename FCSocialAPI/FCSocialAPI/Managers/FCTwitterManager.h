//
//  FCTwitterManager.h
//  FCSocialAPI
//
//  Created by Alejandro Barros on 10/5/13.
//  Copyright (c) 2013 Alejandro Barros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCSocialAPI.h"
#import "FCTwitterUserModel.h"

@class FCTwitterManager;
@protocol FCTwitterManagerDelegate <NSObject>

@optional
- (void)FCTwitterManager:(FCTwitterManager *)manager didChangeConnectionStatusTo:(NSUInteger)connectionStatus;
- (void)FCTwitterManager:(FCTwitterManager *)manager didCompleteTweetsRequestsWith:(NSDictionary *)tweets;
- (void)FCTwitterManager:(FCTwitterManager *)manager didFailedTweetsRequestsWithError:(NSError *)error;
- (void)FCTwitterManager:(FCTwitterManager *)manager didParseDataToTweet:(NSArray *)tweets;
@end

@interface FCTwitterManager : NSObject

@property (weak, nonatomic) id <FCTwitterManagerDelegate> delegate;
@property (strong, nonatomic) FCTwitterUserModel *user;
@property (nonatomic) BOOL isConnected;

- (void)startConnection;
- (void)endConnection;
- (void)fetchTweetsForHastags:(NSArray *)hashtags withLimit:(NSUInteger)limit andLanguage:(NSString *)lang;

+ (FCTwitterManager *)sharedInstance;

@end
