//
//  AddTaskView.h
//  HW8_Drag&Drop
//
//  Created by Roman Cheremin on 26/11/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "AddTaskViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Task creation view (Pop-Up view) implementation
 */
@interface TaskCreationView : UIView

@property (nonatomic, weak) id<TaskCreationViewProtocol> delegate;

/**
 Shows Pop-Up view
 */
- (void) makeViewVisible;

@end

NS_ASSUME_NONNULL_END
