# PanelSheet

[![CI Status](https://img.shields.io/travis/ibnusina/PanelSheet.svg?style=flat)](https://travis-ci.org/ibnusina/PanelSheet)
[![Version](https://img.shields.io/cocoapods/v/PanelSheet.svg?style=flat)](https://cocoapods.org/pods/PanelSheet)
[![License](https://img.shields.io/cocoapods/l/PanelSheet.svg?style=flat)](https://cocoapods.org/pods/PanelSheet)
[![Platform](https://img.shields.io/cocoapods/p/PanelSheet.svg?style=flat)](https://cocoapods.org/pods/PanelSheet)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

PanelSheet is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PanelSheet'
```

## How To Use

To use it you need to import the library e.g `#import <PanelSheet/PanelSheet.h>`. If you use swift project put `#import <PanelSheet/PanelSheet.h>`  in your bridging header.  
Then all you have to do is create and present `PSTPanelSheetController`. It's content can be customized based on your need. Here is basic example:

```Objective-C
#import <PanelSheet/PanelSheet.h>

@implementation YourViewController {

....

//call this function to show the panel
- (void)showPanel
{
    PSTPanelSheetController *panelController = [[PSTPanelSheetController alloc] init];
    [panelController setPanelNavigationHeight:30];
    [panelController setPanelContentHeight:200];
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.view.backgroundColor = UIColor.redColor;
    [panelController setPanelContentWithViewOrViewController:viewController];
    [self presentViewController:panelController animated:NO completion:nil];
}


}
```

## Author

ibnusina, ibnu.sina009@gmail.com

## License

PanelSheet is available under the MIT license. See the LICENSE file for more info.
