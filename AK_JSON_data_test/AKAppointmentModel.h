//
//  AKAppointmentModel.h
//  AK_JSON_data_test
//
//  Created by Alexey Kostyuchenko on 4/21/17.
//  Copyright © 2017 Alexey Kostyuchenko. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface AKAppointmentModel : NSManagedObject

@property (nonatomic, strong) NSString *appointmentID;
@property (nonatomic, strong) NSString *appointmentType;
@property (nonatomic, strong) NSString *appointmentSubject;
@property (nonatomic, strong) NSString *appointmentDetails;
@property (nonatomic, strong) NSDate *appointmentStartDate;
@property (nonatomic, strong) NSDate *appointmentEndDate;
@property (nonatomic, strong) NSString *relatedUserID;
@property (nonatomic, assign) BOOL isConfirmed;

@end
