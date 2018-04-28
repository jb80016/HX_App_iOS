//
//  StorageViewController240.swift
//  HX App 0.1
//
//  Created by Jim Booth on 9/23/16.
//  Copyright © 2016 Jim Booth. All rights reserved.
//

import UIKit

class StorageViewController240: UIViewController {
  
  // MARK:  Properties
  
  var nodes = 2
  var nodeButtons = [UIButton]()
  var disksPerNode = 6
  let minimumNodes = 3
  let maxNodeCount = 8
  let buttonHeight = 30
  let buttonWidth = 215
  let maxDisk240 = 23.0
  let nodeOffset = 2
  
  // Filled and empty images for the cluster node slots
  let hx240FilledNodeImages = [UIImage(named: "hx240f-1"), UIImage(named: "hx240f-2"), UIImage(named: "hx240f-3"),
                               UIImage(named: "hx240f-4"), UIImage(named: "hx240f-5"), UIImage(named: "hx240f-6"),
                               UIImage(named: "hx240f-7"), UIImage(named: "hx240f-8")]
  let hx240EmptyNodeImage = UIImage(named: "hx240e")
  
  // Set delegate to protocol type in ViewController
  var delegate: ConfigurationDelegate? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    for index in 0..<(maxNodeCount - nodeOffset) {
      let nodeButton = UIButton()
      nodeButton.setImage(hx240EmptyNodeImage, for: .normal)
      nodeButton.setImage(hx240FilledNodeImages[index+nodeOffset], for: .selected)
      nodeButton.setImage(hx240FilledNodeImages[index+nodeOffset], for: [.highlighted, .selected])
      nodeButton.adjustsImageWhenHighlighted = false
      nodeButton.addTarget(self, action: #selector(self.clusterButtonTapped(sender:)), for: .touchDown)
      nodeButtons += [nodeButton]
      self.view.addSubview(nodeButton)
      updateButtonSelectionStates()
    }
    
    var buttonFrame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
    
    // Offset each button's origin by the height of the button (plus spacing as needed)
    for (index, nodeButton) in nodeButtons.enumerated() {
      buttonFrame.origin.y = CGFloat(index * buttonHeight)
      nodeButton.frame = buttonFrame
    }
    // Do any additional setup after loading the view.
  }
  
  // MARK:  Button Action
  
  func clusterButtonTapped(sender nodeButton: UIButton) {
    nodes = nodeButtons.index(of: nodeButton)! + 1
    Global.nodeCount240 = nodes
    self.delegate?.setCPUOutput(coresghz: Global.processorType)
    self.delegate?.setMemoryOutput()
    self.delegate?.setStorageOutput(nodes: nodes)
    updateButtonSelectionStates()
  }
  
  // Fill all the button images up to the button selected
  func updateButtonSelectionStates() {
    for (index, nodeButton) in nodeButtons.enumerated() {
      nodeButton.isSelected = index < nodes
    }
  }
  
} // end
