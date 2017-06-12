//
//  AKDataBaseController.h
//  AK_JSON_data_test
//
//  Created by Alexey Kostyuchenko on 4/21/17.
//  Copyright © 2017 Alexey Kostyuchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKDataBaseController : NSObject

- (BOOL)isDBEmpty;
- (BOOL)eraseDBEnteties;
- (void)loadAllEntetiesFromDBWithCompletion:
	(void (^)(NSArray *aAppts, NSArray *aApptsTypes,
		NSArray *aUsers))aCompletion;
- (void)addDataToDBWithAppointments:(NSData *)aAppointmentsData
	appointmentTypes:(NSData *)aAppointmentTypesData users:(NSData *)aUsersData
	completion:(void (^)(NSError *error))aCompletion;

@end
