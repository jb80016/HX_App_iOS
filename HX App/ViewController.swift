//
//  ViewController.swift
//  HX App 0.1
//
//  Created by Jim Booth on 9/23/16.
//  Copyright © 2016 Jim Booth. All rights reserved.
//

import UIKit

// MARK: -- Protocols

// Set up delegate for storage view controller to update storage label here
protocol ConfigurationDelegate {
  func setStorageOutput(nodes: Int)
  func setMemoryOutput()
  func setCPUOutput(coresghz: String)
}

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, ConfigurationDelegate {
  
  // MARK: -- Properties
  
  var coresPerNode: Int = 28
  var ghzPerNCore: Double = 2.0
  var nodeCount: Int = 4
  let rawDiskUsable = 0.3333
  let nodeOffset = 2
  let initialCPU = 24
  let initialMem = 0
  //  let minus220Ghz = 10.8
  let minus220Mem = 48.0
  //  let minus240Ghz = 10.8
  let minus240Mem = 72.0
  let slider = UISlider(frame: CGRect(x: 62, y: 158, width: 215, height: 30))
  
  // MARK: -- Storyboard fields
  
  // Define view for Container and the label for the storage amount
  @IBOutlet weak var storageContainer220: UIView!
  @IBOutlet weak var storageContainer240: UIView!
  
  // Define key output fields
  @IBOutlet weak var StorageOutput: UILabel!
  @IBOutlet weak var MemoryOutput: UILabel!
  @IBOutlet weak var CpuOutput: UILabel!
  
  // Define picker views for CPU and Memory node
  @IBOutlet weak var cpuPicker: UIPickerView!
  @IBOutlet weak var memPicker: UIPickerView!
  
  // Define label for disks per node
  @IBOutlet weak var DiskPer: UILabel!
  
  // Placeholder nodes for minimum cluster size
  @IBOutlet weak var N2201: UIImageView!
  @IBOutlet weak var N2202: UIImageView!
  @IBOutlet weak var N2401: UIImageView!
  @IBOutlet weak var N2402: UIImageView!
  
  // MARK: -- Data model
  
  var processorData: [String: (Int, Double)] =
    
    ["E5-2630Lv3": (8, 1.8),  // 0
      "E5-2630v3": (8, 2.4),   // 1
      "E5-2640v3": (8, 2.6),   // 2
      "E5-2650Lv3": (12, 1.8), // 3
      "E5-2650v3": (10, 2.3),  // 4
      "E5-2658v3": (12, 2.2),  // 5
      "E5-2660v3": (10, 2.6),  // 6
      "E5-2667v3": (8, 3.2),   // 7
      "E5-2670v3": (12, 2.3),  // 8
      "E5-2680v3": (12, 2.5),  // 9
      "E5-2683v3": (14, 2.0),  // 10
      "E5-2690v3": (12, 2.6),  // 11
      "E5-2695v3": (14, 2.3),  // 12
      "E5-2697v3": (14, 2.6),  // 13
      "E5-2698v3": (16, 2.3),  // 14
      "E5-2699v3": (18, 2.3),  // 15
      "E5-2609v4": (8, 1.7),   // 16
      "E5-2620v4": (8, 2.1),   // 17
      "E5-2630Lv4": (8, 1.8),  // 18
      "E5-2630v4": (10, 2.2),  // 19
      "E5-2640v4": (10, 2.4),  // 20
      "E5-2650v4": (12, 2.2),  // 21
      "E5-2650Lv4": (14, 1.7), // 22
      "E5-2658v4": (14, 2.3),  // 23
      "E5-2660v4": (14, 2.0),  // 24 - Default
      "E5-2667v4": (8, 3.2),   // 25
      "E5-2680v4": (14, 2.4),  // 26
      "E5-2683v4": (16, 2.1),  // 27
      "E5-2690v4": (14, 2.6),  // 28
      "E5-2695v4": (18, 2.1),  // 29
      "E5-2697v4": (18, 2.3),  // 30
      "E5-2697Av4": (16, 2.6), // 31
      "E5-2698v4": (20,2.2),   // 32
      "E5-2699v4": (22,2.2)]   // 33
  
  // initial index = 24, E5-2660v4
  var cpuData = ["E5-2630Lv3", "E5-2630v3", "E5-2640v3", "E5-2650Lv3", "E5-2650v3", "E5-2658v3", "E5-2660v3",
                 "E5-2667v3", "E5-2670v3", "E5-2680v3", "E5-2683v3", "E5-2690v3", "E5-2695v3", "E5-2697v3",
                 "E5-2698v3", "E5-2699v3", "E5-2609v4", "E5-2620v4", "E5-2630Lv4", "E5-2630v4", "E5-2640v4",
                 "E5-2650v4", "E5-2650Lv4", "E5-2658v4", "E5-2660v4", "E5-2667v4", "E5-2680v4", "E5-2683v4",
                 "E5-2690v4", "E5-2695v4", "E5-2697v4", "E5-2697Av4", "E5-2698v4", "E5-2699v4"]
  
  var memData = [128, 256, 384, 512, 768]
  
  // MARK: -- Segemented controller
  
  // Segemented control used to change alpha of 220 and 240 nodes
  @IBAction func NodeType(_ sender: AnyObject) {
    if storageContainer220.alpha == 1 {
      
      // Show the 240 nodes, hide the 220 nodes
      storageContainer220.alpha = 0
      N2201.alpha = 0
      N2202.alpha = 0
      storageContainer240.alpha = 1
      N2401.alpha = 1
      N2402.alpha = 1
      nodeCount = Global.nodeCount240
      memPicker.reloadComponent(0)
      
      // Enable disk slider for disk options in 240 node
      DiskPer.text = String(Global.slider)
      DiskPer.alpha = 1.0
      slider.isEnabled = true
      slider.value = Float(Global.slider)
      updateAllOutput(nodes: nodeCount)
    } else if storageContainer220.alpha == 0 {
      
      // Show the 220 nodes, hide the 240 nodes
      storageContainer220.alpha = 1
      N2201.alpha = 1
      N2202.alpha = 1
      storageContainer240.alpha = 0
      N2401.alpha = 0
      N2402.alpha = 0
      nodeCount = Global.nodeCount220
      memPicker.reloadComponent(0)
      
      // Dim disk number and set to only option
      DiskPer.text = "6"
      DiskPer.alpha = 0.5
      
      // Turn off slider for disks since there is only one option of 6 disks
      dismissSlider()
      updateAllOutput(nodes: nodeCount)
    }
  }
  
  // MARK: -- Storage output
  
  // Set the storage output label to the storage amount
  func setStorageOutput(nodes: Int) {
    var storage: Double
    if Global.nodeType == 240 {
      storage = rawDiskUsable * Double(Global.slider) * Double(nodes+nodeOffset)
    } else {
      storage = rawDiskUsable * 6.0 * Double(nodes+nodeOffset)
    }
    let storageString=String(format: "%.1f", (storage))
    
    // Label text field set to string
    StorageOutput!.text = storageString as NSString as String
  }
  
  // MARK: -- Memory output
  
  // Set the memory output label to the memory amount
  func setMemoryOutput() {
    if (Global.nodeType == 240) {
      MemoryOutput!.text = calcMemory(memPerNode: Global.memoryPerNode, nodes: Global.nodeCount240) as NSString as String
    } else {
      MemoryOutput!.text = calcMemory(memPerNode: Global.memoryPerNode, nodes: Global.nodeCount220) as NSString as String
    }
  }
  
  // Calculate the total memory
  func calcMemory(memPerNode: Int, nodes: Int) -> String {
    var minusMem = 0.0
    if (Global.nodeType == 240) {
      minusMem = minus240Mem
    } else {
      minusMem = minus220Mem
    }
    let mem = Int((Double(memPerNode) * Double(nodes+nodeOffset)) - (minusMem * Double(nodes+nodeOffset)))
    return String(mem)
  }
  
  // MARK: -- CPU output
  
  // Set the CPU output label to the compute amount
  func setCPUOutput(coresghz processor: String) {
    let cors: Int = (processorData[processor]?.0)!
    let gz: Double = (processorData[processor]?.1)!
    var cores: Int = 0
    var minusCores = 0
    var minusGhz = 0.0
    if (Global.nodeType == 240) {
      cores = Int(Double(cors) * 2.0 * Double(Global.nodeCount240+nodeOffset))
      minusGhz = 10.8 * Double(Global.nodeCount240+nodeOffset)
      minusCores = Int((10.8 / Double(gz)) * Double(Global.nodeCount240+nodeOffset))
    } else {
      cores = Int(Double(cors) * 2.0 * Double(Global.nodeCount220+nodeOffset))
      minusGhz = 10.8 * Double(Global.nodeCount220+nodeOffset)
      minusCores = Int((10.8 / Double(gz)) * Double(Global.nodeCount220+nodeOffset))
    }
    var ghz = Double(gz) * Double(cores)
    cores -= minusCores
    ghz -= minusGhz
    CpuOutput!.text = "\(cores) / \(ghz)" as NSString as String
  }
  
  // MARK: -- Update All
  
  func updateAllOutput(nodes: Int) {
    setStorageOutput(nodes: nodes)
    setMemoryOutput()
    setCPUOutput(coresghz: Global.processorType)
  }
  
  // MARK: -- PickerView
  
  // Required func of picker components
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  // Get the number of components for cpu and memory picker
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
    if pickerView == cpuPicker {
      return processorData.count
    } else if pickerView == memPicker {
      return memData.count
    }
    return 0
  }
  
  // View information for picker on both CPU and memory
  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    
    let pickerLabel = (view as? UILabel) ?? UILabel()
    pickerLabel.font = UIFont(name: "System", size: 12.0)
    pickerLabel.textAlignment = NSTextAlignment.center
    
    if pickerView == cpuPicker {
      pickerLabel.text = cpuData[row]
      return pickerLabel
    } else if pickerView == memPicker {
      pickerLabel.text = String(memData[row]) + " GB"
      return pickerLabel
    }
    return pickerLabel
  }
  
  // Selected view row picker for both CPU and memory
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
    let pickerLabel = (view as? UILabel) ?? UILabel()
    pickerLabel.font = UIFont(name: "System", size: 12.0)
    pickerLabel.textAlignment = NSTextAlignment.center
    
    if pickerView == cpuPicker {
      Global.processorType = cpuData[row]
      setCPUOutput(coresghz: cpuData[row])
    } else if pickerView == memPicker {
      pickerLabel.text = String(memData[row]) + " GB"
      if Global.nodeType == 240 {
        MemoryOutput.text = calcMemory(memPerNode: Global.memoryPerNode, nodes: Global.nodeCount240)
        Global.memoryPerNode = memData[row]
        setMemoryOutput()
      } else {
        MemoryOutput.text = calcMemory(memPerNode: Global.memoryPerNode, nodes: Global.nodeCount220)
        Global.memoryPerNode = memData[row]
        setMemoryOutput()
      }
    }
  }
  
  // MARK: -- Disk slider
  
  func dismissSlider() {
    slider.value = 6.0
    slider.setNeedsDisplay()
    slider.isEnabled = false
  }
  
  func sliderValueChanged(_ sender: UISlider) {
    if Global.nodeType == 240 {
      let currentValue = Int(sender.value)
      Global.slider = currentValue
      DiskPer.text = String(currentValue)
      setStorageOutput(nodes: Global.nodeCount240)
    }
  }
  
  // MARK: -- Load initial view
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Hide 240 at startup
    N2401.alpha = 0
    N2402.alpha = 0
    
    // Set up for slider
    slider.minimumValue = 6
    slider.maximumValue = 23
    slider.isContinuous = true
    slider.tintColor = UIColor.black
    slider.addTarget(self, action: #selector(ViewController.sliderValueChanged(_:)), for: .valueChanged)
    self.view.addSubview(slider)
    DiskPer.alpha = 0.5
    slider.isEnabled = false
    
    // Set up CPU picker
    self.cpuPicker.dataSource = self
    self.cpuPicker.delegate = self
    cpuPicker.selectRow(initialCPU, inComponent: 0, animated: false)
    
    // Set up Memory picker
    self.memPicker.dataSource = self
    self.memPicker.delegate = self
    memPicker.selectRow(initialMem, inComponent: 0, animated: false)
    
    // Show 220 container, hide 240 container
    storageContainer220.alpha = 1
    storageContainer240.alpha = 0
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: -- Conduit for viewcontroller communication
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if (segue.identifier == "220") {
      // Define storage view controller to set delegate
      let vc220 = segue.destination as! StorageViewController220
      // Set the Storage View Controller delegate to ViewController
      vc220.delegate = self
    }
    
    if (segue.identifier == "240") {
      // Define storage view controller to set delegate
      let vc240 = segue.destination as! StorageViewController240
      // Set the Storage View Controller delegate to ViewController
      vc240.delegate = self
    }
  }
  
} // end
