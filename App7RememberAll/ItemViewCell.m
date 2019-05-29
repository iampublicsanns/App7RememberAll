//
//  ItemViewCell.m
//  App7RememberAll
//
//  Created by Alexander on 08/04/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

#import "ItemViewCell.h"


@interface ItemViewCell ()

@property (nonatomic, nullable, strong) UIImageView *imageView;
@property (nonatomic, nullable, strong) UILabel *label;
@property (nonatomic, nullable, strong) UIButton *button;

@end


@implementation ItemViewCell

#pragma mark - Public

- (void)resetViews
{
	[self setupViews];

	self.imageView.image = nil;
	self.label.text = @"reset";
}

- (void)setImage:(UIImage *)image
{
	[self setupViews];

	self.imageView.image = image;
	self.imageView.translatesAutoresizingMaskIntoConstraints = NO;

	[NSLayoutConstraint activateConstraints:@[
		[self.imageView.widthAnchor constraintEqualToAnchor:self.widthAnchor],
		[self.imageView.heightAnchor constraintEqualToAnchor:self.heightAnchor]
	]];
}

- (void)setLabelText:(nonnull NSString *)string
{
	[self setupViews];

	self.label.text = [NSString stringWithFormat:@"%@", string];
	[self.label sizeToFit];
}


#pragma mark - Private

- (void)createImageView
{
	self.imageView = [[UIImageView alloc] init];
	[self.contentView addSubview:self.imageView];

	self.imageView.layer.cornerRadius = 5;
	self.imageView.clipsToBounds = YES;

	self.imageView.layer.borderWidth = 1;
	self.imageView.layer.borderColor = [UIColor colorWithRed:1 green:0.6 blue:0 alpha:1].CGColor;

	self.imageView.contentMode = UIViewContentModeScaleAspectFill;
	self.imageView.userInteractionEnabled = YES;

	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleClick)];
	[singleTap setNumberOfTapsRequired:1];
	[self.imageView addGestureRecognizer:singleTap];
}

- (void)createLabel
{
	CGFloat parentWidth = CGRectGetWidth(self.frame);
	CGFloat parentHeight = CGRectGetHeight(self.frame);

	self.label = [[UILabel alloc] init];
	self.label.text = @"new";
	self.label.frame = CGRectMake(0, 0, parentWidth, parentHeight);
	self.label.textColor = [UIColor colorWithRed:1 green:0.6 blue:0 alpha:1];

	[self.contentView addSubview:self.label];
}

- (void)setupViews
{
	if (!self.imageView)
	{
		[self createImageView];
	}

	if (!self.label)
	{
		[self createLabel];
	}

}

#pragma mark touch events

- (void)handleClick
{
	if (!self.clickHandler)
	{
		return;
	}

	self.clickHandler();
}

@end
