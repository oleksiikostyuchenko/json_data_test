//
//  AKAppointmentType.h
//  AK_JSON_data_test
//
//  Created by Alexey Kostyuchenko on 4/21/17.
//  Copyright © 2017 Alexey Kostyuchenko. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface AKAppointmentTypeModel : NSManagedObject

@property (nonatomic, strong) NSString *appointmentType;
@property (nonatomic, strong) NSString *appointmentDescription;
@property (nonatomic, strong) NSString *appointmentID;

@end
