
import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

  @IBOutlet weak var scrollView: UIScrollView!
  
  @IBOutlet weak var pageCont: UIPageControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //スクロールビューのデリゲートを自分自身に設定
    scrollView.delegate = self
    
    //スクロールビューのサイズを設定
    scrollView.contentSize = CGSize(width: view.frame.size.width * 3, height: view.frame.size.width)
    
    let image1 = UIImageView()
    let image2 = UIImageView()
    let image3 = UIImageView()
    
    image1.backgroundColor = UIColor.blue
    image2.backgroundColor = UIColor.yellow
    image3.backgroundColor = UIColor.red
    
    //スクロールビューに表示する順番を設定
    image1.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width)
    image2.frame = CGRect(x: view.frame.size.width, y: 0, width: view.frame.size.width, height: view.frame.size.width)
    image3.frame = CGRect(x: (view.frame.size.width * 2), y: 0, width: view.frame.size.width, height: view.frame.size.width)
    
    //スクロールビューに追加
    scrollView.addSubview(image1)
    scrollView.addSubview(image2)
    scrollView.addSubview(image3)
    
    //スクロールバーを消す
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    
    //丸の数とサイズ設定
    pageCont.numberOfPages = 3
    pageCont.sizeToFit()
    
    //丸の位置合わせ
    let pageContY = scrollView.frame.origin.y + scrollView.frame.size.height
    let pageContX = view.frame.size.width / 2
    
    pageCont.center = CGPoint(x: pageContX, y: pageContY + 10)
    
  }

  //スクロールに合わせて●が動く
  func scrollViewDidScroll(_ scrollview: UIScrollView) {
    pageCont.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
  }
  
  //丸の横タップでスクロール
  @IBAction func pageControlTapped(sender:AnyObject) {
    scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width * CGFloat(pageCont.currentPage), y: 0)
  }
  


  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

