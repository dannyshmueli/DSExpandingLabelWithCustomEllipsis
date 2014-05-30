DSExpandingLabelWithCustomEllipsis
==================================

iOS UILabel subclass that replace the ellipses with any NSAttributtedString


![Screenshot](http://i.imgur.com/FeErdpC.png?raw=true =100x100)
![Screenshot](http://i.imgur.com/PPkup3u.png?raw=true)
 
 Shrinked Label:
 
<img src="http://i.imgur.com/FeErdpC.png?raw=true" 
alt="Shrinked Label" width="320" height="568" border="0" />

Expanded Label:

<img src="http://i.imgur.com/PPkup3u.png?raw=true" 
alt="Expanded Label" width="320" height="568" border="0" />

Usage:

```objectivec
self.myExpandingLabel.customEllipsisAttributedText = customEllipsis;
self.myExpandingLabel.attributedText = loremIpsum;
self.myExpandingLabel.didExpandBlock = ^(){
    NSLog(@"did tap label");
};
[self.myExpandingLabel setTruncatingForNumberOfLines:2];
```
