//
//  Scrollview.h
//  Demo
//
//  Created by imac21 on 13-9-3.
//  Copyright (c) 2013年 com.apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TouchTableViewDelegate <NSObject>

@optional

- (void)tableView:(UITableView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView
 touchesCancelled:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView
     touchesEnded:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView
     touchesMoved:(NSSet *)touches
        withEvent:(UIEvent *)event;


@end
 
@interface  Scrollview : UITableView
{
@private
    id touchDelegate;
}

@property (nonatomic,assign) id<TouchTableViewDelegate> touchDelegate;


@end
