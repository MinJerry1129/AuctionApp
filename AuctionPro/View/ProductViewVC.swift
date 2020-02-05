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

class ProductViewVC: UIViewController{
    var productVC : ProductVC! = nil
    var loger : LoginController! = nil
    var profile : ProfileVC! = nil
    var purchase : PurchaseVC! = nil
    var winnerVC : WinnerVC! = nil
    var contactVC : ContactVC! = nil
    var homeVC: HomeVC! = nil
    var spinnerView = JTMaterialSpinner()
    @IBOutlet weak var countdown: UILabel!
    @IBOutlet weak var lastbid: UILabel!
    @IBOutlet weak var timeleft: UILabel!
    @IBOutlet weak var txtdescription: UITextView!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var bid_btn: UIButton!
    @IBOutlet weak var productname: UILabel!
    var name : [String] = []
    var productprice : [String] = []
    var imageUrl : [String] = []
    var endtime : [String] = []
    var bids : [String] = []
    var proDscription : [String] = []
    var prolastbid : [String] = []
    var video : [String] = []
    var timer : Timer! = nil
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
        let parameters: Parameters = ["id": productVC.product_id]
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
                    print(devices)
                    self.name.append(devices?["name"] as! String)
                    self.productprice.append(devices?["price"]as! String)
                    self.imageUrl.append(devices?["image"] as! String)
                    self.endtime.append(devices?["endtime"]as! String)
                    self.bids.append(devices?["countdown"]as! String)
                    self.proDscription.append(devices?["description"]as! String)
                    self.prolastbid.append(devices?["lastbid"]as! String)
                    self.video.append(devices?["video"]as! String)
                    self.countdown.text = self.bids[0]
                    self.lastbid.text = self.prolastbid[0]
                    self.timeleft.text = self.endtime[0]
                    self.txtdescription.text = self.proDscription[0]
                    self.price.text = self.productprice[0]
                    self.productname.text = self.name[0]
                    
                    let str = self.imageUrl[0]
                    let str0 = str.components(separatedBy: "_split_")
                    var inputSource: [InputSource] = []
                    for i in 0...str0.count-1 {
                        inputSource.append(AlamofireSource(urlString: Global.imageUrl + str0[i])!)
                    }
                    self.slideshow.setImageInputs(inputSource)
                    if self.video[0] != ""
                    {
                        let videoUrl = Global.imageUrl + self.video[0]
                        print(videoUrl)
                        self.videobtn.isHidden = false
                        self.VideVC.configure(url: videoUrl)
                        self.VideVC.isLoop = true
                        self.VideVC.play()
                    }
                    if self.endtime[0] == "Ended" {
                        self.bid_btn.isEnabled = false
                        self.bid_btn.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.5)
                        self.bid_btn.setTitle("Bid time End", for: .normal)
                    }
                    if self.endtime[0] == "Past" {
                        self.bid_btn.isEnabled = false
                        self.bid_btn.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.5)
                        self.bid_btn.setTitle("Bid time Past", for: .normal)
                    }
                    self.spinnerView.endRefreshing()
                    if self.endtime[0] != "Ended"{
                        if self.endtime[0] != "Past"{
                            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.fire), userInfo: nil, repeats: true)
                        }
                    }
                    
                    
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
    @objc func fire()
    {
        if endtime[0] != "Ended"
        {
            if endtime[0] != "Past"
            {
                var components: Array = endtime[0].components(separatedBy: ":")
                let hours = Int(components[0])
                let minutes = Int(components[1])
                let seconds = Int(components[2])
                var sec = hours! * 3600 + minutes! * 60 + seconds!
                sec = sec - 1
                if sec == 0 {
                    endtime[0] = "Ended"
                }
                else{
                    let hours_f = sec / 3600
                    let minutes_f = (sec - hours! * 3600) / 60
                    let seconds_f = sec % 60
                    print("\(hours_f)")
                    endtime[0] = "\(hours_f)" + ":" + "\(minutes_f)" + ":" + "\(seconds_f)"
                }
            }
        }
        //print("\(hours_f)" + ":" + "\(minutes_f)" + ":" + "\(seconds_f)")
        timeleft.text = endtime[0]
        
    }
    @IBAction func videoBtn(_ sender: Any) {
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
    @IBAction func bidBtn(_ sender: UIButton) {
        let myInt1 = Int(price.text!) ?? 0
        let myInt2 = Int(productprice[0]) ?? 0
        
        
        if myInt1 > myInt2
        {
            let myInt3 = Int(bids[0])! + 1
            let parameters: Parameters = ["id": productVC.product_id, "price":price.text!, "countdown":myInt3 ,"lastbid":name[0]]
            Alamofire.request(Global.baseUrl + "iupdatebid.php", method: .post, parameters: parameters).responseJSON{ returnValue in
                print(returnValue)
                if let value = returnValue.value as? [String: AnyObject] {
                    let status = value["status"] as! String
                    if status == "ok" {
                        let alert = UIAlertController(title: "Alert", message: "Update Price", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            print(myInt3)
            bid_btn.isEnabled = false
        }
        else{
            let alert = UIAlertController(title: "Alert", message: "Low Price", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func gobakbtn(_ sender: Any) {
        if self.endtime[0] != "Ended"{
            if self.endtime[0] != "Past"{
                timer.invalidate()
                timer = nil
            }
        }
        
        self.productVC = self.storyboard?.instantiateViewController(withIdentifier: "productVC") as? ProductVC
        self.present(self.productVC, animated: true, completion: nil)
    }
    @IBAction func loginBack(_ sender: UIButton) {
        if self.endtime[0] != "Ended"{
            if self.endtime[0] != "Past"{
                timer.invalidate()
                timer = nil
            }
        }
        self.loger = self.storyboard?.instantiateViewController(withIdentifier: "firstVC") as? LoginController
        self.present(self.loger, animated: true, completion: nil)
    }
    
    @IBAction func viewProfile(_ sender: UIButton) {
        if self.endtime[0] != "Ended"{
            if self.endtime[0] != "Past"{
                timer.invalidate()
                timer = nil
            }
        }
        self.profile = self.storyboard?.instantiateViewController(withIdentifier: "profileVC") as? ProfileVC
        self.present(self.profile, animated: true, completion: nil)
    }
    
    @IBAction func viewHome(_ sender: UIButton) {
        if self.endtime[0] != "Ended"{
            if self.endtime[0] != "Past"{
                timer.invalidate()
                timer = nil
            }
        }
        self.homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as? HomeVC
        self.present(self.homeVC, animated: true, completion: nil)
    }
    
    @IBAction func viewpurchase(_ sender: UIButton) {
        if self.endtime[0] != "Ended"{
            if self.endtime[0] != "Past"{
                timer.invalidate()
                timer = nil
            }
        }
        self.purchase = self.storyboard?.instantiateViewController(withIdentifier: "purchaseVC") as? PurchaseVC
        self.present(self.purchase, animated: true, completion: nil)
    }
    @IBAction func viewWonbids(_ sender: UIButton) {
        if self.endtime[0] != "Ended"{
            if self.endtime[0] != "Past"{
                timer.invalidate()
                timer = nil
            }
        }
        self.winnerVC = self.storyboard?.instantiateViewController(withIdentifier: "winnerVC") as? WinnerVC
        self.present(self.winnerVC, animated: true, completion: nil)
    }
    @IBAction func viewContact(_ sender: Any) {
        if self.endtime[0] != "Ended"{
            if self.endtime[0] != "Past"{
                timer.invalidate()
                timer = nil
            }
        }
        self.contactVC = self.storyboard?.instantiateViewController(withIdentifier: "contactVC") as? ContactVC
        self.present(self.contactVC, animated: true, completion: nil)
    }
    
}




