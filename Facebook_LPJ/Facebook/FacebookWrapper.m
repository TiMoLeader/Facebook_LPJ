//
//  FacebookWrapper.m
//
//
//  Copyright (c) 2016年 PP Interactive. All rights reserved.
//

#import "FacebookWrapper.h"
#ifdef TP_FACEBOOK
#import <FacebookSDK/FacebookSDK.h>

typedef void (^FacebookLoginResultHandler)(FacebookUser *user, NSError *error);
typedef void (^FacebokkLoginFinishAuth)(void);

@implementation FacebookUser

@end

@interface FacebookWrapper ()
@property (nonatomic, copy) FacebookLoginResultHandler resultHandler;
@property (nonatomic, copy) FacebokkLoginFinishAuth authHandler;
@end

@implementation FacebookWrapper

- (NSArray *)applyPermissions
{
    return @[@"public_profile", @"email", @"user_friends"];
}

- (void)loginWithCompletion:(void (^)(FacebookUser *, NSError *))completion
{
    self.resultHandler = completion;
    [FBSession openActiveSessionWithReadPermissions:[self applyPermissions]
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session,
                                                      FBSessionState status,
                                                      NSError *error)
     {
         [self sessionStateChanged:session state:status error:error];
     }];
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
{
    if (!error) {
        if (session.isOpen) {
            [self fetchFacebookUserProfile];
        }
    } else {
        if (self.resultHandler) {
            self.resultHandler(nil, error);
        }
    }
}

+ (void)logout
{
    [[FBSession activeSession] closeAndClearTokenInformation];
}

- (void)finishAuth:(void (^)(void))completion
{
    self.authHandler = completion;
}

- (void)fetchFacebookUserProfile
{
    if (self.authHandler) {
        self.authHandler();
    }
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                                           id result,
                                                           NSError *error)
     {
         if (!error) {
             FacebookUser *user = [[FacebookUser alloc] init];
             user.userId = [result objectForKey:@"id"];
             user.userName = [result objectForKey:@"name"];
             user.authToken = [[FBSession activeSession] accessTokenData].accessToken;
             if (self.resultHandler) {
                 self.resultHandler(user, nil);
             }
         } else {
             if (self.resultHandler) {
                 self.resultHandler(nil, error);
             }
         }
     }];
}

+ (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

+ (void)handleDidBecomeActive
{
    [FBAppCall handleDidBecomeActive];
}

@end

#endif
