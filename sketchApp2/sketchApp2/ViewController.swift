import UIKit

// ユーティリティメソッド CGPoint同士の足し算を+で書けるようにする
func -(_ left:CGPoint, _ right:CGPoint)->CGPoint{
  return CGPoint(x:left.x - right.x, y:left.y - right.y)
}
// ユーティリティメソッド CGPoint同士の引き算を-で書けるようにする
func +(_ left:CGPoint, _ right:CGPoint)->CGPoint{
  return CGPoint(x:left.x + right.x, y:left.y + right.y)
}

class ViewController: UIViewController {
  
  // タッチ開始時のUIViewのorigin
  var orgOrigin: CGPoint!
  // タッチ開始時の親ビュー上のタッチ位置
  var orgParentPoint : CGPoint!
  
  // Viewのパンジェスチャーに反応し、処理するためのメソッド
  @objc func handlePanGesture(sender: UIPanGestureRecognizer){
    switch sender.state {
    case UIGestureRecognizerState.began:
      // タッチ開始:タッチされたビューのoriginと親ビュー上のタッチ位置を記録しておく
      orgOrigin = sender.view?.center
      orgParentPoint = sender.translation(in: self.view)
      break
    case UIGestureRecognizerState.changed:
      
      // 現在の親ビュー上でのタッチ位置を求める
      let newParentPoint = sender.translation(in: self.view)
      // パンジャスチャの継続:タッチ開始時のビューのoriginにタッチ開始からの移動量を加算する
      sender.view?.center = orgOrigin + newParentPoint - orgParentPoint
      
      break
      
    default:
      break
    }
  }
  
  var angleSave = CGFloat()
  var angle = CGFloat()
  var saveAngle = CGAffineTransform()
  //回転時の呼び出しメソッド
  @objc func rotateLabel(sender: UIRotationGestureRecognizer) {
    /*switch sender.state {
      
    case UIGestureRecognizerState.changed:
      angle = sender.rotation * 60 + angleSave
      if angle >= 360 {
        angle -= 360
      }
      
      sender.view?.transform = CGAffineTransform(rotationAngle: angle * CGFloat.pi / 180)
      break
     
    case UIGestureRecognizerState.ended:
      angleSave = angle
      break
     
    default:
      break
    }*/
    
    switch sender.state {
      
    case UIGestureRecognizerState.began:
      
      saveAngle = (sender.view?.transform)!
      break
      
    case UIGestureRecognizerState.changed:
      saveAngle.concatenating(saveScale)
      sender.view?.transform = saveAngle.rotated(by: sender.rotation)
      break
      
    case UIGestureRecognizerState.ended:
      saveAngle = (sender.view?.transform)!
      break
      
    default:
      break
    }
  }
  
  var saveScale = CGAffineTransform()
  @objc func pinchStamp(sender: UIPinchGestureRecognizer){
    switch sender.state {
      
    case UIGestureRecognizerState.began:
      saveScale = (sender.view?.transform)!
      break
      
    case UIGestureRecognizerState.changed:
      saveScale.concatenating(saveAngle)
      sender.view?.transform = saveScale.scaledBy(x: sender.scale, y: sender.scale)
      break
      
    case UIGestureRecognizerState.ended:
      saveScale = (sender.view?.transform)!
      break
      
    default:
      break
    }
  }
  
  //リコグナイザーの同時検知を許可するメソッド
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // ビューを2つ作成し、Subviewとして追加する
    // !!注意!!
    // UIGestureRecognizerのインスタンスは複数のViewで使いまわせないので、各View毎に作成する
    let view1 = UIView(frame: CGRect(x:10,y:20,width:100,height:50))
    view1.backgroundColor = UIColor.red
    view1.addGestureRecognizer(
      UIPanGestureRecognizer(target:self, action:#selector(handlePanGesture)))
    self.view.addSubview(view1)
    
    let view2 = UIView(frame: CGRect(x:10,y:100,width:100,height:50))
    view2.backgroundColor = UIColor.blue
    view2.addGestureRecognizer(
      UIPanGestureRecognizer(target:self, action:#selector(handlePanGesture)))
    self.view.addSubview(view2)
    
    let view3 = UIImageView(frame: CGRect(x:10,y:180,width:100,height:50))
    view3.backgroundColor = UIColor.yellow
    view3.isUserInteractionEnabled = true
    let panGesture = UIPanGestureRecognizer(target:self, action:#selector(handlePanGesture))
    panGesture.maximumNumberOfTouches = 1
    view3.addGestureRecognizer(panGesture)
    view3.addGestureRecognizer(
      UIRotationGestureRecognizer(target:self, action:#selector(rotateLabel)))
    view3.addGestureRecognizer(
      UIPinchGestureRecognizer(target:self, action:#selector(pinchStamp)))
    self.view.addSubview(view3)
    
    let view4 = UILabel(frame: CGRect(x:10,y:260,width:100,height:50))
    view4.text = "ことは貧乳！"
    view4.font = UIFont.systemFont(ofSize: 30)
    view4.backgroundColor = UIColor.clear
    view4.sizeToFit()
    view4.isUserInteractionEnabled = true
    view4.addGestureRecognizer(
      UIPanGestureRecognizer(target:self, action:#selector(handlePanGesture)))
    view4.addGestureRecognizer(
      UIPinchGestureRecognizer(target:self, action:#selector(pinchStamp)))
    self.view.addSubview(view4)
  }
  
  var stampImage = UIImage(named: "p")
  var tapLocation: CGPoint = CGPoint()
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    if stampImage != nil {
      // タッチイベントを取得する
      let touch = touches.first
      
      // タップした座標を取得する
      tapLocation = touch!.location(in: self.view)
      
      
      let stampSize = CGSize(width:32, height:32)
      let stampImageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: stampSize))
      
      stampImageView.center = tapLocation
      
      stampImageView.image = stampImage
      
      stampImageView.isUserInteractionEnabled = true
      
      stampImageView.addGestureRecognizer(
        UIPanGestureRecognizer(target:self, action: #selector(handlePanGesture)))
      
      self.view.addSubview(stampImageView)
      
      stampImage = nil
    }
   
    
  }
}
