//
//  AKLoaderController.m
//  AK_JSON_data_test
//
//  Created by Alexey Kostyuchenko on 4/21/17.
//  Copyright © 2017 Alexey Kostyuchenko. All rights reserved.
//

#import "AKLoaderController.h"
#import "AKDataBaseController.h"
#import "AKEntitiesLoader.h"

@implementation AKLoaderController

- (void)loadAppointmentsWithCompletion:(void (^)(NSError *error))aCompletion {
	AKDataBaseController *theDBController = [AKDataBaseController new];
	if (![theDBController isDBEmpty]) {
		[theDBController eraseDBEnteties];
	}

	AKEntitiesLoader *theEntitiesLoader = [AKEntitiesLoader new];
	[theEntitiesLoader loadAllEntitiesWithCompletionBlock:
		^(NSData *aAppointments, NSData *aAppointmentTypes,
			NSData *aUsers, NSError *error) {
			if (nil == error) {
				[theDBController addDataToDBWithAppointments:aAppointments
					appointmentTypes:aAppointmentTypes users:aUsers
						  completion:^(NSError *theError) {
			    aCompletion(theError);
				}];
			} else {
				aCompletion(error);
			}
	}];
}

- (void)loadImageWithURL:(NSURL *)aURL completion:
	(void (^)(NSError *error, UIImage *image))aCompletion {
	NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
	NSURLSession *session = [NSURLSession
		sessionWithConfiguration:sessionConfiguration];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aURL];
	[request setHTTPMethod:@"GET"];

	NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache]
		cachedResponseForRequest:request];
	if (cachedResponse.data) {
		UIImage *downloadedImage = [UIImage imageWithData:cachedResponse.data];
		aCompletion(nil, downloadedImage);
	} else {
		NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
			completionHandler:^(NSData *data, NSURLResponse *response,
			NSError *error) {
			if (!error) {
				NSCachedURLResponse *cachedResp = [[NSCachedURLResponse alloc]
					initWithResponse:response data:data];
				[[NSURLCache sharedURLCache] storeCachedResponse:cachedResp
					forRequest:request];
				UIImage *downloadedImage = [UIImage
					imageWithData:cachedResp.data];
				aCompletion(nil, downloadedImage);
			} else {
				aCompletion(error, nil);
			}
		}];
		[dataTask resume];
	}
}

@end
