//
//  UIButton+Extension.m
//  ECAcademy
//
//  Created by Sophist on 2017/3/28.
//  Copyright © 2017年 dentalink. All rights reserved.
//

#import "UIButton+Extension.h"
#import "UIView+Extension.h"
#import "NSString+CalculateSize.h"
#import <objc/runtime.h>


@implementation UIButton (Extension)

static NSString * uibutton_my_colors_key = @"uibutton_my_colors_key";

- (NSMutableDictionary *)colors
{
    return objc_getAssociatedObject(self, &uibutton_my_colors_key);
}

- (void)setColors:(NSMutableDictionary *)colors
{
    objc_setAssociatedObject(self, &uibutton_my_colors_key, colors, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



+ (UIButton *)imageTitleButtonWithFrame:(CGRect)btnFrame image:(UIImage *)image showImageSize:(CGSize)imageSize title:(NSString *)title titleFont:(UIFont *)titleFont imagePosition:(UIImageOrientation)imagePosition buttonType:(UIButtonType)buttonType
{
    UIButton *btn = [UIButton buttonWithType:buttonType];
    btn.frame = btnFrame;
    [btn setImage:image forState:UIControlStateNormal];
    [btn.titleLabel setFont:titleFont];
    [btn setTitle:title forState:UIControlStateNormal];
    
    if (imagePosition == UIImageOrientationUp || imagePosition == UIImageOrientationDown || imagePosition == UIImageOrientationUpMirrored || imagePosition == UIImageOrientationDownMirrored)
    {
        CGFloat titleHeight = ceil(titleFont.lineHeight);
        CGFloat contentHeight = imageSize.height + 3 + titleHeight;
        if (imagePosition == UIImageOrientationUp || imagePosition == UIImageOrientationUpMirrored)
        {
            [btn setImageEdgeInsets:UIEdgeInsetsMake((btn.height - contentHeight)/2.0, (btn.width - imageSize.width)/2.0, btn.height - (btn.height - contentHeight)/2.0 - imageSize.height, (btn.width - imageSize.width)/2.0)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.height - (btn.height - contentHeight)/2.0 - titleHeight, -image.size.width, (btn.height - contentHeight)/2.0, 0)];
        }
        else
        {
            [btn setImageEdgeInsets:UIEdgeInsetsMake(btn.height - (btn.height - contentHeight)/2.0 - imageSize.height, (btn.width - imageSize.width)/2.0, (btn.height - contentHeight)/2.0, (btn.width - imageSize.width)/2.0)];
            
            [btn setTitleEdgeInsets:UIEdgeInsetsMake((btn.height - contentHeight)/2.0, -image.size.width, btn.height - (btn.height - contentHeight)/2.0 - titleHeight, 0)];
        }
    }
    else
    {
        CGSize titleSize = [NSString contentAutoSizeWithText:title boundSize:CGSizeMake(MAXFLOAT, 20) font:titleFont];
        CGFloat contentWidth = imageSize.width + 5 + titleSize.width;
        if (imagePosition == UIImageOrientationLeft || imagePosition == UIImageOrientationLeftMirrored)
        {
            [btn setImageEdgeInsets:UIEdgeInsetsMake((btn.height - imageSize.height)/2, (btn.width - contentWidth)/2.0, (btn.height - imageSize.height)/2, btn.width - (btn.width - contentWidth)/2.0 - imageSize.width)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width + imageSize.width + 5, 0, 0)];
        }
        else
        {
            [btn setImageEdgeInsets:UIEdgeInsetsMake((btn.height - imageSize.height)/2, btn.width - (btn.width - contentWidth)/2.0 - imageSize.width, (btn.height - imageSize.height)/2, (btn.width - contentWidth)/2.0)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width - imageSize.width - 5, 0, 0)];
        }
    }
    return btn;
}


- (void)setImageTitleButtonWithFrame:(CGRect)btnFrame image:(UIImage *)image showImageSize:(CGSize)imageSize title:(NSString *)title titleFont:(UIFont *)titleFont imagePosition:(UIImageOrientation)imagePosition
{
    UIButton *btn = self;
    btn.frame = btnFrame;
    [btn setImage:image forState:UIControlStateNormal];
    [btn.titleLabel setFont:titleFont];
    [btn setTitle:title forState:UIControlStateNormal];
    
    if (imagePosition == UIImageOrientationUp || imagePosition == UIImageOrientationDown || imagePosition == UIImageOrientationUpMirrored || imagePosition == UIImageOrientationDownMirrored)
    {
        CGFloat titleHeight = ceil(titleFont.lineHeight);
        CGFloat contentHeight = imageSize.height + 3 + titleHeight;
        if (imagePosition == UIImageOrientationUp || imagePosition == UIImageOrientationUpMirrored)
        {
            [btn setImageEdgeInsets:UIEdgeInsetsMake((btn.height - contentHeight)/2.0, (btn.width - imageSize.width)/2.0, btn.height - (btn.height - contentHeight)/2.0 - imageSize.height, (btn.width - imageSize.width)/2.0)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.height - (btn.height - contentHeight)/2.0 - titleHeight, -image.size.width, (btn.height - contentHeight)/2.0, 0)];
        }
        else
        {
            [btn setImageEdgeInsets:UIEdgeInsetsMake(btn.height - (btn.height - contentHeight)/2.0 - imageSize.height, (btn.width - imageSize.width)/2.0, (btn.height - contentHeight)/2.0, (btn.width - imageSize.width)/2.0)];
            
            [btn setTitleEdgeInsets:UIEdgeInsetsMake((btn.height - contentHeight)/2.0, -image.size.width, btn.height - (btn.height - contentHeight)/2.0 - titleHeight, 0)];
        }
    }
    else
    {
        CGSize titleSize = [NSString contentAutoSizeWithText:title boundSize:CGSizeMake(MAXFLOAT, 20) font:titleFont];
        CGFloat contentWidth = imageSize.width + 5 + titleSize.width;
        if (imagePosition == UIImageOrientationLeft || imagePosition == UIImageOrientationLeftMirrored)
        {
            [btn setImageEdgeInsets:UIEdgeInsetsMake((btn.height - imageSize.height)/2, (btn.width - contentWidth)/2.0, (btn.height - imageSize.height)/2, btn.width - (btn.width - contentWidth)/2.0 - imageSize.width)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width + imageSize.width + 5, 0, 0)];
        }
        else
        {
            [btn setImageEdgeInsets:UIEdgeInsetsMake((btn.height - imageSize.height)/2, btn.width - (btn.width - contentWidth)/2.0 - imageSize.width, (btn.height - imageSize.height)/2, (btn.width - contentWidth)/2.0)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width - imageSize.width - 5, 0, 0)];
        }
    }
}


+ (UIButton *)customBackButtonWithTarget:(id)target action:(SEL)action
{
    UIButton *baseView = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 60, 44)];
    if (action && target)
    {
        [baseView addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    [baseView setImage:[UIImage imageNamed:@"btn_navi_return_title"] forState:UIControlStateNormal];
    [baseView setImageEdgeInsets:UIEdgeInsetsMake(14, 15, 15, 2)];
    return baseView;
}


- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    if (!self.colors)
    {
        self.colors = [[NSMutableDictionary alloc] init];
    }
    // If it is normal then set the standard background here
    if (state == UIControlStateNormal)
    {
        [super setBackgroundColor:backgroundColor];
    }
    else
    {
        UIColor * originalColor = [self.colors objectForKey:[self keyForState:UIControlStateNormal]];
        if (!originalColor)
        {
            [self.colors setValue:self.backgroundColor forKey:[self keyForState:UIControlStateNormal]];
        }
        
    }
    
    // Store the background colour for that state
    [self.colors setValue:backgroundColor forKey:[self keyForState:state]];
    
}
- (UIColor *)backgroundColorForState:(UIControlState)state
{
    return [self.colors valueForKey:[self keyForState:state]];
}
- (void)setHighlighted:(BOOL)highlighted
{
    // Do original Highlight
    [super setHighlighted:highlighted];
    
    UIColor * originalColor = [self.colors objectForKey:[self keyForState:UIControlStateNormal]];
    if (originalColor)
    {
        // Highlight with new colour OR replace with orignial
        NSString *highlightedKey = [self keyForState:UIControlStateHighlighted];
        UIColor *highlightedColor = [self.colors valueForKey:highlightedKey];
        if (highlighted && highlightedColor) {
            [super setBackgroundColor:highlightedColor];
        }
        else
        {
            // 由于系统在调用setSelected后，会再触发一次setHighlighted，故做如下处理，否则，背景色会被最后一次的覆盖掉。
            if ([self isSelected])
            {
                NSString *selectedKey = [self keyForState:UIControlStateSelected];
                UIColor *selectedColor = [self.colors valueForKey:selectedKey];
                [super setBackgroundColor:selectedColor];
            }
            else
            {
                NSString *normalKey = [self keyForState:UIControlStateNormal];
                [super setBackgroundColor:[self.colors valueForKey:normalKey]];
            }
        }
    }
}
- (void)setSelected:(BOOL)selected
{
    // Do original Selected
    [super setSelected:selected];
    // Select with new colour OR replace with orignial
    NSString *selectedKey = [self keyForState:UIControlStateSelected];
    UIColor *selectedColor = [self.colors valueForKey:selectedKey];
    if (selected && selectedColor) {
        [super setBackgroundColor:selectedColor];
    } else {
        NSString *normalKey = [self keyForState:UIControlStateNormal];
        [super setBackgroundColor:[self.colors valueForKey:normalKey]];
    }
}
- (NSString *)keyForState:(UIControlState)state
{
    return [NSString stringWithFormat:@"state_%zd", state];
}


@end
