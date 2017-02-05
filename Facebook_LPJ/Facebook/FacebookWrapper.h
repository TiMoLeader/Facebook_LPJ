//
//  FacebookWrapper.h
//
//
//  Copyright (c) 2016年 PP Interactive. All rights reserved.
//

/**
 *	@brief	宏注释集成的Facebook
 */
#define TP_FACEBOOK 1

#ifdef TP_FACEBOOK
#import <Foundation/Foundation.h>

@interface FacebookUser : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *authToken;
@end

@interface FacebookWrapper : NSObject

- (void)loginWithCompletion:(void (^)(FacebookUser *user, NSError *error))completion;

- (void)finishAuth:(void (^)(void))completion;

+ (void)logout;

+ (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication;

+ (void)handleDidBecomeActive;

@end

#endif
