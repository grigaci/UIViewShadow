#UIView+BIShadow
UIView category for setting shadow.

[![Build Status](https://travis-ci.org/grigaci/UIViewShadow.svg?branch=master)](https://travis-ci.org/grigaci/UIViewShadow)

##Installation
Just drag&drop the ```UIView+BIShadow.h/m``` files in your Xcode Project.

##Usage

``` objc

myView.shadowColor = [UIColor lightGrayColor];
myView.shadowOpacity = 0.8;

// Set shadow above the view.
NSDictionary *shadowDictionary = @{UIViewShadowOffset.top : @(20)};
[myView setShadow:UIViewShadowTop withOffsets:shadowDictionary];

```