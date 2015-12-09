//
//  Scrollview.m
//  Demo
//
//  Created by imac21 on 13-9-3.
//  Copyright (c) 2013年 com.apple. All rights reserved.
//

#import "Scrollview.h"

@implementation Scrollview

@synthesize touchDelegate = _touchDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    NSLog(@"touchesBegan");
    
    [super touchesBegan:touches withEvent:event];
    
    if ([_touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)] &&
        [_touchDelegate respondsToSelector:@selector(tableView:touchesBegan:withEvent:)])
    {
        [_touchDelegate tableView:self touchesBegan:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    NSLog(@"touchesCancelled");
    [super touchesCancelled:touches withEvent:event];
    
    if ([_touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)] &&
        [_touchDelegate respondsToSelector:@selector(tableView:touchesCancelled:withEvent:)])
    {
        [_touchDelegate tableView:self touchesCancelled:touches withEvent:event];
    }
}




- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    NSLog(@"touchesEnded");
    [super touchesEnded:touches withEvent:event];
    
    if ([_touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)] &&
        [_touchDelegate respondsToSelector:@selector(tableView:touchesEnded:withEvent:)])
    {
        [_touchDelegate tableView:self touchesEnded:touches withEvent:event];
    }
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *etouchs = [event allTouches];
    NSLog(@"count:%d ",[etouchs count]);
    if([etouchs count]==1)
    {
        
        UITouch *touch = [etouchs.allObjects objectAtIndex:0];
        CGPoint oldPoint = [touch previousLocationInView:self];
        CGPoint curPoint = [touch locationInView:self];
        float distanceY = curPoint.y - oldPoint.y;
        
        NSLog(@"oldPoint %f",oldPoint.y);
        NSLog(@"curPoint %f",curPoint.y);
        NSLog(@"distanceY %f",distanceY);
        
    }
    
    NSLog(@"touchesMoved");
    [super touchesMoved:touches withEvent:event];
    
    if ([_touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)] &&
        [_touchDelegate respondsToSelector:@selector(tableView:touchesMoved:withEvent:)])
    {
        [_touchDelegate tableView:self touchesMoved:touches withEvent:event];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
