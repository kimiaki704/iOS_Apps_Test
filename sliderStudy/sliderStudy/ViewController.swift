

import UIKit

class ViewController: UIViewController {
  let label = UILabel()
  override func viewDidLoad() {
    super.viewDidLoad()
    
    label.text = "test unko"
    label.numberOfLines = 0
    label.center = CGPoint(x: 0, y: 60)
    label.frame.size = CGSize(width: 375, height: 100)
    label.textAlignment = .center
    
    self.view.addSubview(label)
    
    scaleSlider.transform = CGAffineTransform(rotationAngle: CGFloat((270 * M_PI) / 180))
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBOutlet weak var colorView: UIView!
  
  @IBOutlet weak var scaleSlider: UISlider!
  
  @IBOutlet weak var rField: UITextField!
  @IBOutlet weak var gField: UITextField!
  @IBOutlet weak var bField: UITextField!
  @IBOutlet weak var aField: UITextField!
  
  @IBOutlet weak var scaleField: UITextField!
  
  var r = CGFloat(0.0)
  var g = CGFloat(0.0)
  var b = CGFloat(0.0)
  var a = CGFloat(1.0)
  
  var scale = CGFloat(10)
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
    labelSetting()
    drawBackgroundColor()
  }
  
  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }
  
  @IBAction func sliderAction(_ sender: UISlider) {
    
    
    switch sender.tag {
    case 0:
      rField.text = String(sender.value)
      r = CGFloat(sender.value / 255)
      print(r)
      break
    case 1:
      gField.text = String(sender.value)
      g = CGFloat(sender.value / 255)
      print(g)
      break
      
    case 2:
      bField.text = String(sender.value)
      b = CGFloat(sender.value / 255)
      print(b)
      break
      
    case 3:
      aField.text = String(sender.value)
      a = CGFloat(sender.value)
      print(a)
      break
      
    case 4:
      scaleField.text = String(sender.value)
      scale = CGFloat(sender.value)
      break
      
    default:
      break
    }
    labelSetting()
    drawBackgroundColor()
  }
  
  func drawBackgroundColor(){
    colorView.layer.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: a).cgColor
  }
  
  func labelSetting() {
    
    label.font = UIFont.systemFont(ofSize: scale)
    
    label.textColor = UIColor(red: r, green: g, blue: b, alpha: a)
  }


}

