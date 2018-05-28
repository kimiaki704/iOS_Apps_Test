//
//  ViewController.swift
//  stampCamera
//
//  Created by SasakiTatsuya on 2018/01/07.
//  Copyright © 2018年 S.Tatsuya. All rights reserved.
//

import UIKit

var stampImages: UIImage!
var backImages: UIImage!

var imageOfNew: UIImage!

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var imageView: UIImageView!
    var stampImage: UIImage? = nil
  
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Screen Size の取得
        let screenWidth:CGFloat = view.frame.size.width
        let screenHeight:CGFloat = view.frame.size.height
        
        // タッチ操作を enable
        imageView.isUserInteractionEnabled = true
        
        //self.view.addSubview(stamp)
        
       /* // 小数点以下２桁のみ表示
        labelX.text = "x: ".appendingFormat("%.2f", screenWidth/2)
        labelY.text = "y: ".appendingFormat("%.2f", screenHeight/2)
        */
        // 画面背景を設定
        self.view.backgroundColor = UIColor(red:0.85,green:1.0,blue:0.95,alpha:1.0)
        
    }
    
    

    /*
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: imageView) else { return }
        let stampSize: CGFloat = 32
        let maxY = imageView.frame.maxY - stampSize
        
        guard maxY > point.y else { return }
        
       //addStamp(with: point)
        //point.view.addSubview(stamp)
    }
     */
    
    private func addStamp(with point: CGPoint) {
        
        let stampSize = CGSize(width: 32, height: 32)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: stampSize))
        
        imageView.center = point
         print(point)
        imageView.image = stampImage
      let imageSize = imageView.image
      print(imageSize?.size)
        
        self.imageView.addSubview(imageView)
      
      
      //この辺から画像合成(参照：https://i-app-tec.com/ios/uigraphicsbeginimagecontext.html)
      let imageViewWidth = backImages.size.width
      let imageViewHeight = backImages.size.height
      let rect = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeight)
      
      UIGraphicsBeginImageContext(backImages.size)
      
      backImages.draw(in: rect)
      
      let stampRect = CGRect(x: point.x, y: point.y, width: stampSize.width, height: stampSize.height)
      
      stampImage?.draw(in: stampRect)
      
      let newImages = UIGraphicsGetImageFromCurrentImageContext()
      imageOfNew = newImages
      UIGraphicsEndImageContext()
      
      
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let point = touches.first?.location(in: imageView) else { return }
        let stampSize: CGFloat = 32
        let maxY = imageView.frame.maxY - stampSize
        
        guard maxY > point.y else { return }
        
        addStamp(with: point)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        if delegate.isStampAdded {
            delegate.isStampAdded = false
            
            let stamp = UIImageView()
            let _:CGFloat = 100
            stamp.frame  = CGRect(x:0, y:0, width:32, height:32)
            //stamp.frame = CGFloat(0, 0, stampSize, stampSize)
            stamp.center = self.view.center
            stamp.contentMode = .scaleAspectFit
            stamp.image = delegate.image
            
            /*
            let stampSize = CGSize(width: 32, height: 32)
            _ = UIImageView(frame: CGRect(origin: CGPoint.zero, size: stampSize))
            
            //stamp.center = self.view.point as! Bool
            //stamp.image = stampArray[indexPath.row]
            stamp.image = delegate.image
            */
            self.view.addSubview(stamp)
        }
    }
    
    

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                dismiss(animated: true, completion: nil)
            }
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[String : Any]) {
                
                let image = info[UIImagePickerControllerOriginalImage] as! UIImage
                imageView.image = image
              backImages = image
                self.dismiss(animated: true, completion: nil)
            }

    
    @IBAction func photo(_ sender: Any) {
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = .photoLibrary
            cameraPicker.delegate = self
            
            present(cameraPicker, animated: true, completion: nil)
        }
  



    
            
    /*
        func camera(sender: AnyObject){
            openCamera()
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .photoLibrary
        pickerController.delegate = self as UIImagePickerControllerDelegate as? UIImagePickerControllerDelegate & UINavigationControllerDelegate 
        self.present(pickerController, animated: true, completion: nil)
        }
    
        
        
        func openCamera() {
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                dismiss(animated: true, completion: nil)
            }
            func UIImagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
                info: [String : Any]) {
                
                let image = info[UIImagePickerControllerOriginalImage] as! UIImage
                imageView.image = image
                
                dismiss(animated: true, completion: nil)
    }
        }
 
 
        func touchesBegan(touches: Set<UITouch>, with: UIEvent) {
                
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = .photoLibrary
            present (controller, animated: true, completion: nil)
            
            }
    
    func openCamera() {
        let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let photoPicker = UIImagePickerController()
            photoPicker.sourceType = sourceType
            photoPicker.delegate = self
            self.present(photoPicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleToFill
            imageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController,
                didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imageView.image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
        */
 
        

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

  @IBAction func saveAction(_ sender: Any) {
    stampImages = imageOfNew
    
  }
  
}


