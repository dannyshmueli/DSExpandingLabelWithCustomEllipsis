DSExpandingLabelWithCustomEllipsis
==================================

iOS UILabel subclass that replace the ellipses with any NSAttributtedString

 Shrinked label to expanded label

<img src="http://i.imgur.com/FeErdpC.png?raw=true" 
alt="Shrinked Label" width="320" height="568" border="0" style="float: left;"/> 
 

<img src="http://i.imgur.com/PPkup3u.png?raw=true" 
alt="Expanded Label" width="320" height="568" border="0" style="float: left;" />



<p style="clear: both">
Usage:

```objectivec
self.myExpandingLabel.customEllipsisAttributedText = customEllipsis;
self.myExpandingLabel.attributedText = loremIpsum;
self.myExpandingLabel.didExpandBlock = ^(){
    NSLog(@"did tap label");
};
[self.myExpandingLabel setTruncatingForNumberOfLines:2];
```
