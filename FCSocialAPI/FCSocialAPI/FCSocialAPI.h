//
//  FCSocialAPI.h
//  FCSocialAPI
//
//  Created by Alejandro Barros on 10/5/13.
//  Copyright (c) 2013 Alejandro Barros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCTwitterUserModel.h"
#import "FCTwitterManager.h"


// Mode types for social API
typedef NS_ENUM(NSUInteger, FCSocialAPIMode) {
    FCSocialAPITwitterMode,
    FCSocialAPIFacebookMode
};

// Connection Status
typedef NS_ENUM(NSUInteger, FCSocialAPIConnectionStatus) {
    FCSocialAPIConnectionStatusFailed,
    FCSocialAPIConnectionStatusSuccess,
    FCSocialAPIConnectionStatusEnded
};

@class FCSocialAPI;
@protocol FCSocialAPIDelegate <NSObject>

@optional
- (void)FCSocialApi:(FCSocialAPI *)socialAPI connectionForMode:(FCSocialAPIMode)socialMode didChangeStatusTo:(FCSocialAPIConnectionStatus)connectionStatus;
- (void)FCSocialApi:(FCSocialAPI *)socialAPI tweetsRequestDidSuccessWith:(NSArray *)tweets;
- (void)FCSocialApi:(FCSocialAPI *)socialAPI tweetsRequestDidFailWithError:(NSError *)error;
@end

@interface FCSocialAPI : NSObject

@property (weak, nonatomic) id <FCSocialAPIDelegate> delegate;

- (void)connectTo:(FCSocialAPIMode)socialMode;
- (void)disconnectFrom:(FCSocialAPIMode)socialMode;

- (BOOL)isConnectedTo:(FCSocialAPIMode)socialMode;

- (FCTwitterUserModel *)getTwitterUser;
- (void)fetchTweetsForHashtags:(NSArray *)hashtags withLimit:(NSUInteger)limit andLanguaje:(NSString *)lang;

+ (FCSocialAPI *)sharedInstance;

@end
