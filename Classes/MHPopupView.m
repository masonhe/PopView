//
//  MHPopupView.m
//
//  Created by Mason on 16/5/31.
//
//

#import "MHPopupView.h"

static UIView *maskView;

#define MHPopupViewMaskAlpha 0.4
#define MHPopupViewMaskDuration 0.25
@interface MHPopupView(){
    BOOL __isShowing;
    CGAffineTransform __startupSlideTransform;
}
@end

@implementation MHPopupView

#pragma mark
#pragma mark - public method
- (void)slideFromEdge:(UIRectEdge)edge docked:(UIRectEdge)docked inContainer:(UIView *)container{
    __isShowing = YES;

    [self addMaskViewIntoContainer:container];
    
    self.frame = [self slideFinalRectFromEdge:edge docked:docked inContainer:container];
    
    self.transform = [self slideTransformFromEdge:edge inContainer:(UIView *)container];
    
    __startupSlideTransform = self.transform;
    
    [container addSubview:self];
    
    [UIView animateWithDuration:MHPopupViewMaskDuration animations:^{
        self.transform = CGAffineTransformIdentity;
        maskView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissIdentity{
    [UIView animateWithDuration:MHPopupViewMaskDuration animations:^{
        self.transform = __startupSlideTransform;
        maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [maskView removeFromSuperview];
        [self removeFromSuperview];
        self.transform = CGAffineTransformIdentity;
    }];
    __isShowing = NO;
}

#pragma mark
#pragma mark - private method

- (void)addMaskViewIntoContainer:(UIView*)view{
    if (!maskView) {
        maskView = [[UIView alloc] initWithFrame:CGRectZero];
        maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:MHPopupViewMaskAlpha];
    }
    
    [maskView setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    
    maskView.alpha = 0;
    
    [view addSubview:maskView];
    
    
    maskView.gestureRecognizers = @[];
    
    maskView.maskView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissIdentity)];
    
    tap.numberOfTapsRequired = 1;
    
    tap.numberOfTouchesRequired = 1;
    
    [maskView addGestureRecognizer:tap];
}

- (CGAffineTransform)slideTransformFromEdge:(UIRectEdge)edge inContainer:(UIView *)container{
    
    CGAffineTransform t;
    
    if (edge == UIRectEdgeLeft || edge == UIRectEdgeRight) {
        
        CGFloat translate = container.frame.size.width;
        
        if (edge == UIRectEdgeLeft) {
            // L->R
            translate = -translate;
        }else{
            // R->L
            translate = translate;
        }
        t = CGAffineTransformTranslate(self.transform, translate, 0);
    }else{
        CGFloat translate = self.frame.size.height;
        
        if (edge == UIRectEdgeTop) {
            // T->B
            translate = -translate;
        }else{
            // B->T
            translate = translate;
        }
        t = CGAffineTransformTranslate(self.transform, 0, translate);

    }
    
    return t;
}

- (CGRect)slideFinalRectFromEdge:(UIRectEdge)edge docked:(UIRectEdge)docked inContainer:(UIView *)container{
    CGPoint point;
    
    CGSize originSize = self.frame.size;
    
    CGFloat containerWidth = container.frame.size.width;
    
    CGFloat containerHeight = container.frame.size.height;
    
    if (edge == UIRectEdgeLeft || edge == UIRectEdgeRight) {
        // L->R
        // R->L

        if (docked == UIRectEdgeTop) {
            point = CGPointMake((containerWidth-originSize.width)/2, 0);
        }else{
            point = CGPointMake((containerWidth-originSize.width)/2, containerHeight-originSize.height);
        }

    }else{
        CGFloat translate = self.frame.size.height;
        
        if (edge == UIRectEdgeTop) {
            // T->B
            point = CGPointMake((containerWidth-originSize.width)/2, 0);
        }else{
            // B->T
            point = CGPointMake((containerWidth-originSize.width)/2, containerHeight-originSize.height);
        }
    }
    
    CGRect rect = {point, originSize};
    return rect;
}

@end
