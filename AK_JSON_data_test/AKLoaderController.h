//
//  AKLoaderController.h
//  AK_JSON_data_test
//
//  Created by Alexey Kostyuchenko on 4/21/17.
//  Copyright © 2017 Alexey Kostyuchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

@interface AKLoaderController : NSObject

- (void)loadAppointmentsWithCompletion:(void (^)(NSError *error))aCompletion;

- (void)loadImageWithURL:(NSURL *)aURL completion:
	(void (^)(NSError *error, UIImage *image))aCompletion;

@end
