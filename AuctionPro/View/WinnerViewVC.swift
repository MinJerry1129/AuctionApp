//
//  ProductViewVC.swift
//  dancontrol
//
//  Created by Admin on 6/1/19.
//  Copyright © 2019 Dancontrol. All rights reserved.
//

import UIKit
import Alamofire
import ImageSlideshow
import JTMaterialSpinner

class WinnerViewVC: UIViewController{
    var winnerVC : WinnerVC! = nil
    var loger : LoginController! = nil
    var profile : ProfileVC! = nil
    var purchase : PurchaseVC! = nil
    var contactVC : ContactVC! = nil
    var homeVC: HomeVC! = nil
    var spinnerView = JTMaterialSpinner()
    @IBOutlet weak var txtdescription: UITextView!
    @IBOutlet weak var price: UITextField!
    
    @IBOutlet weak var productname: UILabel!
    var name : [String] = []
    var productprice : [String] = []
    var imageUrl : [String] = []
    var proDscription : [String] = []
    var video : [String] = []
    @IBOutlet weak var photobtn: UIButton!
    @IBOutlet weak var videobtn: UIButton!
    @IBOutlet weak var VideVC: VideoView!
    @IBOutlet weak var slideshow: ImageSlideshow!
    var image : [UIImage] = []
    override func viewDidLoad() {
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        //        //        print(purchaseVC.product_id)
        let parameters: Parameters = ["id": winnerVC.product_id]
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.pageIndicator = pageControl
        slideshow.activityIndicator = DefaultActivityIndicator()
        Alamofire.request(Global.baseUrl + "igetproductdata.php", method: .post, parameters: parameters).responseJSON{ returnValue in
            print(returnValue)
            if let value = returnValue.value as? [String: AnyObject] {
                let status = value["status"] as! String
                if status == "ok" {
                    let devices = value["product"] as? [String: Any]
                    self.name.append(devices?["name"] as! String)
                    self.productprice.append(devices?["price"]as! String)
                    self.imageUrl.append(devices?["image"] as! String)
                    self.proDscription.append(devices?["description"]as! String)
                    self.video.append(devices?["video"]as! String)
                    self.txtdescription.text = self.proDscription[0]
                    self.price.text = self.productprice[0]
                    self.productname.text = self.name[0]
                    let str = self.imageUrl[0]
                    let str0 = str.components(separatedBy: "_split_")
                    var inputSource: [InputSource] = []
                    for i in 0...str0.count-1 {
                        inputSource.append(AlamofireSource(urlString: Global.baseUrl + str0[i])!)
                    }
                    self.slideshow.setImageInputs(inputSource)
                    if self.video[0] != ""
                    {
                        let videoUrl = Global.baseUrl + self.video[0]
                        print(videoUrl)
                        self.videobtn.isHidden = false
                        self.VideVC.configure(url: videoUrl)
                        self.VideVC.isLoop = true
                        self.VideVC.play()
                    }
                    self.spinnerView.endRefreshing()
                }else{
                    let alert = UIAlertController(title: "Alert", message: "No Categories", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        //
        
        
        super.viewDidLoad()
    }
    @IBAction func videoBtn(_ sender: UIButton) {
        slideshow.isHidden = true
        videobtn.isHidden = true
        VideVC.isHidden = false
        photobtn.isHidden = false
    }
    @IBAction func photoBtn(_ sender: UIButton) {
        slideshow.isHidden = false
        videobtn.isHidden = false
        VideVC.isHidden = true
        photobtn.isHidden = true
    }
    @IBAction func gobakbtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func loginBack(_ sender: UIButton) {
        self.loger = self.storyboard?.instantiateViewController(withIdentifier: "firstVC") as? LoginController
        self.present(self.loger, animated: true, completion: nil)
    }
    
    @IBAction func viewProfile(_ sender: UIButton) {
        self.profile = self.storyboard?.instantiateViewController(withIdentifier: "profileVC") as? ProfileVC
        self.present(self.profile, animated: true, completion: nil)
    }
    
    @IBAction func viewHome(_ sender: UIButton) {
        self.homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as? HomeVC
        self.present(self.homeVC, animated: true, completion: nil)
    }
    
    @IBAction func viewpurchase(_ sender: UIButton) {
        self.purchase = self.storyboard?.instantiateViewController(withIdentifier: "purchaseVC") as? PurchaseVC
        self.present(self.purchase, animated: true, completion: nil)
    }
    @IBAction func viewWonbids(_ sender: UIButton) {
        self.winnerVC = self.storyboard?.instantiateViewController(withIdentifier: "winnerVC") as? WinnerVC
        self.present(self.winnerVC, animated: true, completion: nil)
    }
    @IBAction func viewContact(_ sender: Any) {
        self.contactVC = self.storyboard?.instantiateViewController(withIdentifier: "contactVC") as? ContactVC
        self.present(self.contactVC, animated: true, completion: nil)
    }
    
}




