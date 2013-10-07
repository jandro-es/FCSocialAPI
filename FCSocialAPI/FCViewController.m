//
//  FCViewController.m
//  FCSocialAPI
//
//  Created by Alejandro Barros on 10/5/13.
//  Copyright (c) 2013 Alejandro Barros. All rights reserved.
//

#import "FCViewController.h"
#import "FCSocialAPI.h"
#import "FCTweetModel.h"

@interface FCViewController () <FCSocialAPIDelegate>

@end

@implementation FCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[FCSocialAPI sharedInstance] setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - FCSocialAPI Actions
- (IBAction)connectToTwitter:(UIButton *)sender
{
    [[FCSocialAPI sharedInstance] connectTo:FCSocialAPITwitterMode];
}

- (IBAction)checkTwitterStatus:(UIButton *)sender
{
    if ([[FCSocialAPI sharedInstance] isConnectedTo:FCSocialAPITwitterMode]){
        NSLog(@"--- Connected to Twitter");
        NSLog(@"%@", [[FCSocialAPI sharedInstance] getTwitterUser]);
    } else {
        NSLog(@"--- Not connected to Twitter");
    }
}

- (IBAction)endTwitterConnection:(UIButton *)sender
{
    [[FCSocialAPI sharedInstance] disconnectFrom:FCSocialAPITwitterMode];
}

- (IBAction)searchHashtags:(UIButton *)sender
{
    [[FCSocialAPI sharedInstance] fetchTweetsForHashtags:@[@"#iOS7", @"#OSX"] withLimit:20 andLanguage:@"en"];
}

#pragma mark - FCSocialAPIDelegate
- (void)FCSocialApi:(FCSocialAPI *)socialAPI connectionForMode:(FCSocialAPIMode)socialMode didChangeStatusTo:(FCSocialAPIConnectionStatus)connectionStatus
{
    if (connectionStatus == FCSocialAPIConnectionStatusSuccess){
        if (socialMode == FCSocialAPITwitterMode){
            NSLog(@"--- Twitter connection was succesfull");
        } else if(socialMode == FCSocialAPIFacebookMode){
            NSLog(@"--- Facebook connection was succesfull");
        }
    } else  if (connectionStatus == FCSocialAPIConnectionStatusFailed){
        if (socialMode == FCSocialAPITwitterMode){
            NSLog(@"--- Twitter connection failed");
        } else if(socialMode == FCSocialAPIFacebookMode){
            NSLog(@"--- Facebook connection was failed");
        }
    } else if (connectionStatus == FCSocialAPIConnectionStatusEnded){
        if (socialMode == FCSocialAPITwitterMode){
            NSLog(@"--- Twitter connection ended");
        } else if(socialMode == FCSocialAPIFacebookMode){
            NSLog(@"--- Facebook connection was ended");
        }
    }
}

- (void)FCSocialApi:(FCSocialAPI *)socialAPI tweetsRequestDidFailWithError:(NSError *)error
{
    NSLog(@"--- Request for tweets failed with error %@", error);
}

- (void)FCSocialApi:(FCSocialAPI *)socialAPI tweetsRequestDidSuccessWith:(NSDictionary *)tweets
{
    NSLog(@"---  Request for tweets succesfull with data %@", tweets);
}

- (void)FCSocialApi:(FCSocialAPI *)socialAPI didParseDataToTweets:(NSArray *)tweets
{
    for (FCTweetModel *tweet in tweets){
        NSLog(@"%@", tweet);
    }
}

@end
