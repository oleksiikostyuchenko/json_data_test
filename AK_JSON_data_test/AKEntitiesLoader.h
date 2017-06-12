//
//  AKEntitiesLoader.h
//  AK_JSON_data_test
//
//  Created by Alexey Kostyuchenko on 4/20/17.
//  Copyright © 2017 Alexey Kostyuchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKEntitiesLoader : NSObject

- (void)loadAllEntitiesWithCompletionBlock:
	(void (^)(NSData *aAppointments,NSData *aAppointmentTypes,
		NSData *aUsers, NSError* error))aCompletion;

@end
