
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate,UICollectionViewDataSource {
  
  var colorInfo = UIColor()
  
  var colorAsset = [UIColor.white, UIColor.black, UIColor.darkGray, UIColor.lightGray, UIColor.gray, UIColor.brown, UIColor.red, UIColor.magenta, UIColor.green, UIColor.blue, UIColor.cyan, UIColor.yellow, UIColor.orange, UIColor.purple]
  
  @IBOutlet weak var colorCollectionView: UICollectionView!
  
  @IBAction func blackViewClose(_ sender: Any) {
    blackView.isHidden = true
  }
  
  @IBAction func textDone(_ sender: Any) {
    labelTextSave = textField.text!
    
    stampImage = nil
    
    blackView.isHidden = true
  }
  
  @IBOutlet weak var filterSetting: UIButton!
  @IBAction func filterButton(_ sender: Any) {
    imageFiltering()
  }
  

    @IBOutlet weak var imageView: UIImageView!
    var stampImage: UIImage! = nil
  var textImage: UIImage!
  
  @IBOutlet weak var blackView: UIView!
  @IBOutlet weak var textField: UITextField!
  
  var stampLabelText = String()
  var labelTextSave = String()
  var stampLabelSize = CGFloat(30)
  
  @IBAction func textFieldAction(_ sender: Any) {
    stampLabelText = (sender as AnyObject).text
  }
  
  @IBAction func editText(_ sender: Any) {
    blackView.isHidden = false
    textField.becomeFirstResponder()
    
  }
  
    
    @IBAction func back(_ sender: Any) {
    
        let stamps = imageView.subviews
        stamps.last?.removeFromSuperview()
    }
    
    
    @IBAction func save(_ sender: Any) {
        saveImageWithStamps()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      blackView.isHidden = true
      textField.textColor = UIColor.white
      colorInfo = UIColor.white
      
      filterSetting.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return colorAsset.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCollectionViewCell
    cell.colorImageView.backgroundColor = colorAsset[indexPath.row]
    /*switch indexPath.row {
    case 0:
      cell.colorImageView.image = UIImage(named: "+button")
      return cell
    default:
      cell.colorImageView.backgroundColor = colorAsset[indexPath.row - 1]
      return cell
    }*/
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    colorInfo = colorAsset[indexPath.row]
    textField.textColor = colorAsset[indexPath.row]
  }
  
    
    private func addStamp(with point: CGPoint) {
      
      if stampImage == nil {
        
        let stampLabel = UILabel()
        stampLabel.center = point
        stampLabel.numberOfLines = 0
        //stampLabel.font = UIFont.systemFont(ofSize: stampLabelSize)
        
        stampLabel.text = labelTextSave
        stampLabel.sizeToFit()
        stampLabel.backgroundColor = UIColor.clear
        stampLabel.textColor = colorInfo
        
        self.imageView.addSubview(stampLabel)
      }
      
        let stampSize = CGSize(width: 32, height: 32)
        let stampImageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: stampSize))
        
        stampImageView.center = point
        
        stampImageView.image = stampImage
        
        self.imageView.addSubview(stampImageView)
      
      
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
        
            self.view.addSubview(stamp)
          effectImage = imageView.image
        }
    }
    

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                dismiss(animated: true, completion: nil)
            }
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[String : Any]) {
                
                let image = info[UIImagePickerControllerOriginalImage] as! UIImage
                imageView.image = image
              effectImage = image
              filterSetting.isHidden = false
                self.dismiss(animated: true, completion: nil)
            }

    
    @IBAction func photo(_ sender: Any) {
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = .photoLibrary
            cameraPicker.delegate = self
            
            present(cameraPicker, animated: true, completion: nil)
        }

    
    private func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
    }


    private func saveImageWithStamps() {
        
        UIGraphicsBeginImageContext(imageView.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            displayAlert(title: "エラー", message: "画像の保存に失敗しました")
            return
        }
        
        imageView.layer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            displayAlert(title: "エラー", message: "画像の保存に失敗しました")
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(ViewController.imageError(image:didFinishSaveImageWithError:contextInfo:)), nil)
        UIGraphicsEndImageContext()
    }
    
    
    @objc func imageError(image: UIImage, didFinishSaveImageWithError error: NSError?, contextInfo: UnsafeMutableRawPointer) {
      if error != nil {
        print(error?.code as Any)
      }
        switch error {
        case let .some(error):
            displayAlert(title: "エラー", message: error.localizedDescription)
            
        case .none:
            displayAlert(title: "成功", message: "画像が保存されました！")
        }
    }
  
  
  //fiter settings ->
  let filterArray = ["CIPhotoEffectMono",
                     "CIPhotoEffectChrome",
                     "CIPhotoEffectFade",
                     "CIPhotoEffectInstant",
                     "CIPhotoEffectNoir",
                     "CIPhotoEffectProcess",
                     "CIPhotoEffectTonal",
                     "CIPhotoEffectTransfer",
                     "CISepiaTone"
  ]
  
  var effectImage: UIImage!
  //選択中のエフェクト添字
  var filterSelectNumber = 0
  
  func imageFiltering() {
    //フィルター名を指定
    let filterName = filterArray[filterSelectNumber]
    
    //次の選択するエフェクト添字に更新
    filterSelectNumber += 1
    //添字が配列の数と同じか？チェック
    if filterSelectNumber == filterArray.count {
      //同じ場合は最後まで選択されたので先頭に戻す
      filterSelectNumber = 0
    }
    
    //元々の画像の回転角度を取得
    let rotate = effectImage.imageOrientation
    
    //UIImage形式の画像をCIImage形式の画像に変換
    let inputImage = CIImage(image: effectImage)
    
    //フィルターの種類を引数で指定された種類を指定してCIFilterのインスタンスを取得
    let effectFilter = CIFilter(name: filterName)!
    
    // エフェクトのパラメータを初期化
    effectFilter.setDefaults()
    
    //インスタンスにエフェクトする元画像を設定
    effectFilter.setValue(inputImage, forKey: kCIInputImageKey)
    
    //エフェクト後のCIImage形式の画像を取り出す
    let outputImage = effectFilter.outputImage
    
    //CIContextのインスタンスを取得
    let ciContext = CIContext(options: nil)
    
    //エフェクト後の画像をCIContext上に描画し，結果をcgImageとしてCGImage形式の画像を取得
    let cgImage = ciContext.createCGImage(outputImage!, from: outputImage!.extent)
    
    //エフェクト後の画像をCGImage形式の画像からUIImage形式の画像に回転角度を指定して変換しImageViewに表示
    imageView.image = UIImage(cgImage: cgImage!, scale: 1.0, orientation:rotate)
  }
}





