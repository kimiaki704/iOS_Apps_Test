//
//  ViewController.swift
//  pointStamp
//
//  Created by 鈴木公章 on 2018/01/31.
//  Copyright © 2018年 kimio. All rights reserved.
//

import UIKit

var saveImage = UIImage()

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  @IBOutlet weak var imageView: UIImageView!
  var stampImage = UIImage()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  var tapLocation: CGPoint = CGPoint()
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    // タッチイベントを取得する
    let touch = touches.first
    // タップした座標を取得する
    tapLocation = touch!.location(in: self.imageView)
    
    
    let stampSize = CGSize(width: 32, height: 32)
    let stampImageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: stampSize))
    
    stampImageView.center = tapLocation
    
    stampImageView.image = stampImage
    
    self.imageView.addSubview(stampImageView)
  }
  
  
  @IBAction func imageSet(_ sender: Any) {
    let alertViewController = UIAlertController(title: "選択してください", message: "", preferredStyle: .actionSheet)
    let cameraAction = UIAlertAction(title: "カメラ", style: .default, handler: { (action:UIAlertAction!) -> Void in
      
      self.openCamera()
      
    })
    
    let photoAction = UIAlertAction(title: "ライブラリー", style: .default, handler: { (action:UIAlertAction!) -> Void in
      
      self.openLibrary()
      
    })
    
    let cancelAction = UIAlertAction(title: "キャンセル", style: .default, handler: nil)
    
    alertViewController.addAction(cameraAction)
    alertViewController.addAction(photoAction)
    alertViewController.addAction(cancelAction)
    
    present(alertViewController, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      
      imageView.image = pickedImage
    }
    self.dismiss(animated: true, completion: nil)
  }
  
  
  func openCamera() {
    
    let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
      let cameraPicker = UIImagePickerController()
      cameraPicker.sourceType = sourceType
      cameraPicker.delegate = self
      self.present(cameraPicker, animated: true, completion: nil)
    }
  }
  
  func openLibrary() {
    
    let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.photoLibrary
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
      let photoPicker = UIImagePickerController()
      photoPicker.sourceType = sourceType
      photoPicker.delegate = self
      self.present(photoPicker, animated: true, completion: nil)
    }
  }
  
  
  
  @IBAction func save(_ sender: Any) {
    //画質を維持するためにUIGraphicsBeginImageContextではなくUIGraphicsBeginImageContextWithOptionsを使う
    UIGraphicsBeginImageContextWithOptions(imageView.frame.size, false, 0.0)
    imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
    
    //現在imageViewに表示されている画像をsaveImageに格納
    saveImage = UIGraphicsGetImageFromCurrentImageContext()!
  
    UIGraphicsEndImageContext()
  }
  

}

