//
//  SegementedControl.swift
//  HX App 0.1
//
//  Created by Jim Booth on 9/30/16.
//  Copyright © 2016 Jim Booth. All rights reserved.
//

import UIKit

@IBDesignable class SegementedControl: UIControl {
  
  // Set delegate to protocol type in ViewController
  var delegate: ConfigurationDelegate? = nil
  
  private var labels = [UILabel]()
  var thumbView = UIView()
  
  
  var items:[String] = ["HX220", "HX240"] {
    didSet {
      setupLabels()
    }
  }
  
  var selectedIndex: Int = 0 {
    didSet {
      displayNewSelectedIndex()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }
  
  func setupView() {
    layer.cornerRadius = frame.height/2
    layer.borderColor = UIColor.black.cgColor
    layer.borderWidth = 2
    
    backgroundColor = UIColor.clear
    setupLabels()
    insertSubview(thumbView, at: 0)
  }
  
  func setupLabels() {
    for label in labels {
      label.removeFromSuperview()
    }
    
    labels.removeAll(keepingCapacity: true)
    
    for index in 1...items.count {
      let label = UILabel(frame: CGRect.zero)
      label.text = items[index-1]
      label.textAlignment = .center
      label.textColor = UIColor(white: 0.5, alpha: 1.0)
      self.addSubview(label)
      labels.append(label)
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    var selectFrame = self.bounds
    let newWidth = selectFrame.width / CGFloat(items.count)
    selectFrame.size.width = newWidth
    thumbView.frame = selectFrame
    thumbView.backgroundColor = UIColor.black
    thumbView.layer.cornerRadius = thumbView.frame.height / 2
    
    let labelHeight = self.bounds.height
    let labelWidth = self.bounds.width / CGFloat(labels.count)
    
    for index in 0...labels.count - 1 {
      let label = labels[index]
      
      let xPosition = CGFloat(index) * labelWidth
      label.frame = CGRect(x: xPosition, y: 0, width: labelWidth, height: labelHeight)
    }
  }
  
  override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    let location = touch.location(in: self)
    
    var calculatedIndex: Int?
    for(index, item) in labels.enumerated() {
      if item.frame.contains(location) {
        calculatedIndex = index
      }
    }
    
    if calculatedIndex != nil {
      selectedIndex = calculatedIndex!
      sendActions(for: .valueChanged)
    }
    return false
  }
  
  func displayNewSelectedIndex() {
    let label = labels[selectedIndex]
    self.thumbView.frame = label.frame
    Global.nodeType = 220 + (selectedIndex == 0 ? 0 : 20)
  }
  
}
