
#import "PullableView.h"

/**
 @author Fabio Rodella fabio@crocodella.com.br
 */
#define kSnapPosition 384
#define kMaxOpenYValue 230

#define kBounceOffset 5
#define kAnimationHighLimit 0.1
#define kAnimationLowLimit 0.25

@implementation PullableView

@synthesize handleView;
@synthesize closedCenter;
@synthesize openedCenter;
@synthesize dragRecognizer;
@synthesize tapRecognizer;
@synthesize animate;
@synthesize animationDuration;
@synthesize delegate;
@synthesize opened;

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

    return YES;
}
- (id)initWithFrame:(CGRect)frame
{
    
    frame.origin.y = kSnapPosition+10;
    self = [super initWithFrame:frame];
    if (self) {
        
        animate = YES;
        animationDuration = 0.2;
        
        toggleOnTap = YES;
        
        
        
        // Creates the handle view. Subclasses should resize, reposition and style this view
        handleView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 40, frame.size.width, 40)];
        [self addSubview:handleView];
        [handleView release];
        
        dragRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrag:)];
        dragRecognizer.minimumNumberOfTouches = 1;
        dragRecognizer.maximumNumberOfTouches = 1;
        dragRecognizer.delegate = self;
        [handleView addGestureRecognizer:dragRecognizer];
        [dragRecognizer release];
        
        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.numberOfTouchesRequired = 1;
        
        [handleView addGestureRecognizer:tapRecognizer];
        [tapRecognizer release];
        
        opened = NO;
    }
    return self;
}



-(void)calculateMinMaxPositions {
    verticalAxis = closedCenter.x == openedCenter.x;
    
    // Finds the minimum and maximum points in the axis
    if (verticalAxis) {
        minPos = closedCenter.y < openedCenter.y ? closedCenter : openedCenter;
        maxPos = closedCenter.y > openedCenter.y ? closedCenter : openedCenter;
    } else {
        minPos = closedCenter.x < openedCenter.x ? closedCenter : openedCenter;
        maxPos = closedCenter.x > openedCenter.x ? closedCenter : openedCenter;
    }
    
    
    

}
- (void)handleDrag:(UIPanGestureRecognizer *)sender {
    CGPoint pt = [sender locationInView:self.superview];
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            
            if(self.frame.origin.y==kSnapPosition)
            hasSnappedToGrid = YES;
            
            else if(self.frame.origin.y<kSnapPosition &&self.frame.origin.y!=kMaxOpenYValue)
                hasSnappedToGrid = NO;
        
        }break;
            
        case UIGestureRecognizerStateChanged: {
        
           
            CGRect frame = self.frame;
            frame.origin.y += pt.y -startPos.y;
            
            
            
            
            if(!hasSnappedToGrid && frame.origin.y<kSnapPosition &&pt.y<startPos.y) {
                
              //  hasSnappedToGrid = YES;
  
                frame.origin.y =kSnapPosition;
                snapPoint = pt;
            }
            
            
            
            if(frame.origin.y<kMaxOpenYValue)
                frame.origin.y = kMaxOpenYValue;
            
            [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.frame = frame;

            } completion:^(BOOL finished) {
                
            }];
        }
            break;
            
        case UIGestureRecognizerStateEnded: {
            
            
            int diffFromSnap = abs(self.frame.origin.y-kSnapPosition);
            NSLog(@"%f",(self.frame.origin.y-kMaxOpenYValue));
            int diffFromMax = abs(self.frame.origin.y-kMaxOpenYValue);
            CGRect frame = self.frame;

            if(frame.origin.y>kSnapPosition)
            {

                
                
                
                frame.origin.y = self.superview.frame.size.height-30 ;
                hasSnappedToGrid = NO;
                if([self.delegate respondsToSelector:@selector(pullableViewDidClose)])
                    [self.delegate pullableViewDidClose];
            }
        
        
            else if(diffFromSnap<diffFromMax) {
            
                
                frame.origin.y = kSnapPosition+kBounceOffset;
                hasSnappedToGrid = YES;
                if([self.delegate respondsToSelector:@selector(pullableViewDidSnapToTopRow)])
                    [self.delegate pullableViewDidSnapToTopRow];

                
            }
            else {
                
                frame.origin.y = kMaxOpenYValue-kBounceOffset;
                hasSnappedToGrid = YES;
                if([self.delegate respondsToSelector:@selector(pullableViewDidExpandFull)])
                    [self.delegate pullableViewDidExpandFull];

            }
            CGPoint velocity =[(UIPanGestureRecognizer*)sender velocityInView:self.superview];

            float duration  = [self animationDurationWithVelocity:velocity];
[UIView animateWithDuration:duration animations:^{
    self.frame = frame;

} completion:^(BOOL finished) {
   /* if(frame.origin.y<kSnapPosition)
    {
    [UIView animateWithDuration:duration animations:^{
        CGRect frame=  self.frame;
        
        if(diffFromSnap<diffFromMax) {
            
            frame.origin.y = kSnapPosition;
            
            
        }
        
        else frame.origin.y = kMaxOpenYValue;
        
        self.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    }*/
}];
            
        }break;
            
    }
    
    startPos = pt;
}

- (NSTimeInterval)animationDurationWithVelocity:(CGPoint)velocity {
    
    
    CGFloat width = CGRectGetWidth(self.bounds);
    NSTimeInterval animationDurationDiff =  - kAnimationLowLimit;
    CGFloat horizontalVelocity = (velocity.x);
    
    if (horizontalVelocity < -width) horizontalVelocity = -width;
    else if (horizontalVelocity > width) horizontalVelocity = width;
    
    return (kAnimationHighLimit + kAnimationLowLimit) - fabs(((horizontalVelocity / width) * animationDurationDiff));
}



/*
- (void)handleDrag:(UIPanGestureRecognizer *)sender {
    
    if ([sender state] == UIGestureRecognizerStateBegan) {
        startPos = self.center;
        
        // Determines if the view can be pulled in the x or y axis
        verticalAxis = closedCenter.x == openedCenter.x;
        
        // Finds the minimum and maximum points in the axis
        if (verticalAxis) {
            minPos = closedCenter.y < openedCenter.y ? closedCenter : openedCenter;
            maxPos = closedCenter.y > openedCenter.y ? closedCenter : openedCenter;
        } else {
            minPos = closedCenter.x < openedCenter.x ? closedCenter : openedCenter;
            maxPos = closedCenter.x > openedCenter.x ? closedCenter : openedCenter;
        }
        
    } else if ([sender state] == UIGestureRecognizerStateChanged) {

        
        CGPoint translate = [sender translationInView:self.superview];
        
        CGPoint newPos;
        
        // Moves the view, keeping it constrained between openedCenter and closedCenter
        if (verticalAxis) {
            
            newPos = CGPointMake(startPos.x, startPos.y + translate.y);
            NSLog(@"POSITION %@",NSStringFromCGPoint(newPos));

            if(newPos.y<688 && newPos.y>530){
                

               return;
                
            }
            
            if (newPos.y < minPos.y) {
               newPos.y = minPos.y;
                //newPos.y = 688;

                translate = CGPointMake(0, newPos.y - startPos.y);
            }
            
            if (newPos.y > maxPos.y) {
                newPos.y = maxPos.y;
                translate = CGPointMake(0, newPos.y - startPos.y);
            }
        } else {
            
            newPos = CGPointMake(startPos.x + translate.x, startPos.y);
            
            if (newPos.x < minPos.x) {
                newPos.x = minPos.x;
                translate = CGPointMake(newPos.x - startPos.x, 0);
            }
            
            if (newPos.x > maxPos.x) {
                newPos.x = maxPos.x;
                translate = CGPointMake(newPos.x - startPos.x, 0);
            }
        }
        
        [sender setTranslation:translate inView:self.superview];
        
        self.center = newPos;
        
    } else if ([sender state] == UIGestureRecognizerStateEnded) {
        
        // Gets the velocity of the gesture in the axis, so it can be
        // determined to which endpoint the state should be set.
        
        CGPoint vectorVelocity = [sender velocityInView:self.superview];
        CGFloat axisVelocity = verticalAxis ? vectorVelocity.y : vectorVelocity.x;
        
        CGPoint target = axisVelocity < 0 ? minPos : maxPos;
        BOOL op = CGPointEqualToPoint(target, openedCenter);
        
       // [self setOpened:op animated:animate];
    }
}*/

- (void)handleTap:(UITapGestureRecognizer *)sender {
    
    if ([sender state] == UIGestureRecognizerStateEnded) {
        [self setOpened:!opened animated:animate];
    }
}

- (void)setToggleOnTap:(BOOL)tap {
    toggleOnTap = tap;
    tapRecognizer.enabled = tap;
    
}

- (BOOL)toggleOnTap {
    return toggleOnTap;
}

- (void)setOpened:(BOOL)op animated:(BOOL)anim {
    opened = op;
    
    if (anim) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    }
    
    self.center = opened ? openedCenter : closedCenter;
    
    if (anim) {
        
        // For the duration of the animation, no further interaction with the view is permitted
        dragRecognizer.enabled = NO;
        tapRecognizer.enabled = NO;
        
        [UIView commitAnimations];
        
    } else {
        
        if ([delegate respondsToSelector:@selector(pullableView:didChangeState:)]) {
            [delegate pullableView:self didChangeState:opened];
        }
    }
}
         
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if (finished) {
        // Restores interaction after the animation is over
        dragRecognizer.enabled = YES;
        tapRecognizer.enabled = toggleOnTap;
        
        if ([delegate respondsToSelector:@selector(pullableView:didChangeState:)]) {
            [delegate pullableView:self didChangeState:opened];
        }
    }
}

@end
