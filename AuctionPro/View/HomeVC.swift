import UIKit
import Alamofire
import JTMaterialSpinner
class HomeVC: UIViewController{
    var spinnerView = JTMaterialSpinner()
    var winnerVC : WinnerVC! = nil
    var loger : LoginController! = nil
    var profile : ProfileVC! = nil
    var purchase : PurchaseVC! = nil
    var contactVC : ContactVC! = nil
    var homeVC: HomeVC! = nil
    @IBOutlet weak var addcategoryVC: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var activeBids: UILabel!
    @IBOutlet weak var activeAuctions: UILabel!
    @IBOutlet weak var wonBids: UILabel!
    @IBOutlet weak var postAuction: UIButton!
    @IBOutlet weak var addCategory: UIButton!
    @IBOutlet weak var uiCongratulations: UIView!
    @IBOutlet weak var viewHome: UIButton!
    @IBOutlet weak var viewWonBids: UIButton!
    var avatar_url = ""
    var won = 0
    var role_state = "user"
    @IBOutlet weak var avatarImg: UIImageView!
    
    override func viewDidLoad() {
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        
        userName.text = Defaults.getNameAndValue(Defaults.USERNAME_KEY)
        print(userName.text!)
        userEmail.text = Defaults.getNameAndValue(Defaults.EMAIL_KEY)
        avatar_url = Defaults.getNameAndValue(Defaults.AVATAR_KEY)
        role_state = Defaults.getNameAndValue(Defaults.ROLE_KEY)
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.main.bounds
        avatarImg.frame = CGRect(x: 0, y: 0, width: screenSize.height * 0.2, height: screenSize.height * 0.2)
        avatarImg.layer.borderWidth = 1
        avatarImg.layer.masksToBounds = false
        avatarImg.layer.borderColor = UIColor.black.cgColor
        avatarImg.layer.cornerRadius = avatarImg.frame.height/2
        avatarImg.clipsToBounds = true
        print(avatarImg.frame.height)
        print(avatarImg.layer.cornerRadius)
        inforview()
        //get image from url
        if avatar_url == ""{
            avatar_url = "image/profile/default.jpg"
        }
        let imgUrl = Global.imageUrl + avatar_url
        print(imgUrl)
        let url = URL(string: imgUrl)
        do {
            let data = try Data(contentsOf: url!)
            let image = UIImage(data: data)
            avatarImg.image = image
        }catch let err {
            print("Error : \(err.localizedDescription)")
        }
        if role_state == "user" {
            addcategoryVC.isHidden = true
        }
        spinnerView.endRefreshing()
    }
    
    func inforview()
    {
        let parameters: Parameters = ["username": userName.text!]
        Alamofire.request(Global.baseUrl + "igetbiddata.php", method: .post, parameters: parameters).responseJSON{ response in
            print(response)
            if let value = response.value as? [String: AnyObject] {
                let status = value["status"] as! String
                if status == "ok" {
                    let total = value["total"] as! Int
                    let active = value["active"] as! Int
                    self.won = value["won"] as! Int
                    print(total)
                    if self.won == 0
                    {
                        self.uiCongratulations.isHidden = true
                    }
                    
                    self.activeBids.text = "\(active)"
                    self.activeAuctions.text = "\(total)"
                    self.wonBids.text = "\(self.won)"
                    //self.performSegue(withIdentifier: "loginToTabbarSegue", sender: self)
                }
                else{
                    let alert = UIAlertController(title: "Alert", message: "noproject", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
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
    }
    
    @IBAction func viewPurchase(_ sender: UIButton) {
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

