
#import "StyledPullableView.h"

/**
 @author Fabio Rodella fabio@crocodella.com.br
 */

@implementation StyledPullableView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
        UIView *bgView = [[UIView alloc]initWithFrame:self.bounds];
        [bgView setBackgroundColor:[UIColor colorWithRed:(float)205/255 green:(float)206/255 blue:(float)285/255 alpha:0.36]];
//        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
//        imgView.frame = CGRectMake(0, 0, 320, 460);
      //  [self addSubview:bgView];
        //[bgView release];
    }
    return self;
}

@end
