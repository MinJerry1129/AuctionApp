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
import OpalImagePicker
import AVKit
import MobileCoreServices
import JTMaterialSpinner

class AddProductVC: UIViewController{
    var loger : LoginController! = nil
    var profile : ProfileVC! = nil
    var purchase : PurchaseVC! = nil
    var winnerVC : WinnerVC! = nil
    var contactVC : ContactVC! = nil
    var homeVC: HomeVC! = nil
    var spinnerView = JTMaterialSpinner()
    var imagePicker = UIImagePickerController()
    var uploadimages : [UIImage] = []
    @IBOutlet weak var VideoVC: VideoView!
    @IBOutlet weak var photoVC: ImageSlideshow!
    @IBOutlet weak var videobtn: UIButton!
    @IBOutlet weak var photobtn: UIButton!
    
    @IBOutlet weak var catlist: DropDown!
    @IBOutlet weak var proname: UITextField!
    @IBOutlet weak var proprice: UITextField!
    @IBOutlet weak var prodescription: UITextView!
    @IBOutlet weak var postbtn: UIButton!
    var catname : [String] = []
    var cat_name = ""
    var isvideo = "novideo"
    var isphoto = "nophoto"
    var video_str = ""
    var video_strBase64 = ""
    var image_strBase64 : [String] = []
    var fileupload : [String] = []
    var sel_camera = "nocamera"
    override func viewDidLoad() {
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        photoVC.pageIndicator = pageControl
        photoVC.activityIndicator = DefaultActivityIndicator()
        
        Alamofire.request(Global.baseUrl + "igetcategories.php").responseJSON{ returnValue in
            if let value = returnValue.value as? [String: AnyObject] {
                let status = value["status"] as! String
                if status == "ok" {
                    let devices = value["categories"] as? [[String: Any]]
                    for i in 0 ... (devices?.count)!-1 {
                        self.catname.append(devices?[i]["name"] as! String)
                        
                    }
                    self.catlist.optionArray = self.catname
                    self.catlist.didSelect{(selectedText , index , id) in
                        self.cat_name = selectedText
                    }
                }else{
                    let alert = UIAlertController(title: "Alert", message: "No Categories", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        
        super.viewDidLoad()
    }
    
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        let title = (error == nil) ? "Success" : "Error"
        let message = (error == nil) ? "Video was saved" : "Video failed to save"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func videoBtn(_ sender: UIButton) {
        photoVC.isHidden = true
        VideoVC.isHidden = false
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Video", style: .default, handler: { _ in
            self.openCameraVideo()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Video", style: .default, handler: { _ in
            self.openVideo()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        //If you want work actionsheet on ipad then you have to use popoverPresentationController to present the actionsheet, otherwise app will crash in iPad
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func photoBtn(_ sender: UIButton) {
        photoVC.isHidden = false
        VideoVC.isHidden = true
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        //If you want work actionsheet on ipad then you have to use popoverPresentationController to present the actionsheet, otherwise app will crash in iPad
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func newProduct(_ sender: Any) {
        if cat_name != "" && proname.text! != "" && prodescription.text! != "" && proprice.text! != "" {
            if isphoto == "photo"{
                for i in 0 ... uploadimages.count-1{
                    let data = UIImageJPEGRepresentation(uploadimages[i], 0.2)
                    fileupload.append(data!.base64EncodedString(options: .lineLength64Characters))
                }
            }
            if isvideo == "video"
            {
                fileupload.append(video_strBase64)
            }
            self.spinnerView.beginRefreshing()
            print(cat_name)
            print(proname.text!)
            print(prodescription.text!)
            print(proprice.text!)
            print(isvideo)
            print(Defaults.getNameAndValue(Defaults.USERNAME_KEY))
            print(fileupload[0])
            let parameters: Parameters = ["categoryname": cat_name, "name" : proname.text!, "description" : prodescription.text!, "price" : proprice.text!, "lastbid" : Defaults.getNameAndValue(Defaults.USERNAME_KEY) , "uploadfile" : fileupload, "isvideo" : isvideo ]
            Alamofire.request(Global.baseUrl + "iproductregister.php", method: .post, parameters: parameters).responseJSON{ returnValue in
                print(returnValue)
                if let value = returnValue.value as? [String: AnyObject] {
                    let status = value["status"] as! String
                    if status == "ok" {
                        self.postbtn.isEnabled = false
                        self.spinnerView.endRefreshing()
                        let alert = UIAlertController(title: "Alert", message: "New Product Added", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    else{
                        self.spinnerView.beginRefreshing()
                        let alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        else{
            let alert = UIAlertController(title: "Alert", message: "Write the empty field", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func gobackbtn(_ sender: Any) {
        self.homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as? HomeVC
        self.present(self.homeVC, animated: true, completion: nil)
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
    
    
    func openCamera(){
        let imagePicker = UIImagePickerController()
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Choose image from camera roll
    
    func openGallary(){
        let imagePicker = OpalImagePickerController()
        imagePicker.imagePickerDelegate = self
        imagePicker.maximumSelectionsAllowed = 5
        present(imagePicker, animated: true, completion: nil)
    }
    func openCameraVideo(){
        sel_camera = "camera"
        VideoHelper.startMediaBrowser(delegate: self, sourceType: .camera)
    }
    
    //MARK: - Choose image from camera roll
    
    func openVideo(){
        sel_camera = "nocamera"
        VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)
    }
}

//MARK: - UIImagePickerControllerDelegate

extension AddProductVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if sel_camera == "camera"
        {
            guard let mediaType = info[UIImagePickerControllerMediaType] as? String,
                mediaType == (kUTTypeMovie as String),
                let url = info[UIImagePickerControllerMediaURL] as? URL,
                UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
                else { return }
            
            let str = url.absoluteString
            self.VideoVC.configure(url: str)
            self.VideoVC.isLoop = true
            self.VideoVC.play()
            
            do {
                let videodata = try Data(contentsOf: url)
                video_strBase64 = videodata.base64EncodedString(options: .lineLength64Characters)
            } catch {
                print("Unable to load data: \(error)")
            }
            isvideo = "video"
            picker.dismiss(animated: true, completion: nil)
            UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(video(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        else{
            guard let mediaType = info[UIImagePickerControllerMediaType] as? String,
                mediaType == (kUTTypeMovie as String),
                let url = info[UIImagePickerControllerMediaURL] as? URL
                else { return }
            let str = url.absoluteString
            self.VideoVC.configure(url: str)
            self.VideoVC.isLoop = true
            self.VideoVC.play()
            do {
                let videodata = try Data(contentsOf: url)
                video_strBase64 = videodata.base64EncodedString(options: .lineLength64Characters)
            } catch {
                print("Unable to load data: \(error)")
            }
            isvideo = "video"
            picker.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
extension AddProductVC: OpalImagePickerControllerDelegate {
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        //Cancel action?
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        //Save Images, update UI
        uploadimages = images
        isphoto = "photo"
        var inputSource: [InputSource] = []
        for i in 0...images.count-1 {
            inputSource.append(ImageSource(image: images[i]))
        }
        self.photoVC.setImageInputs(inputSource)
        //Dismiss Controller
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerNumberOfExternalItems(_ picker: OpalImagePickerController) -> Int {
        return 1
    }
    
    func imagePickerTitleForExternalItems(_ picker: OpalImagePickerController) -> String {
        return NSLocalizedString("External", comment: "External (title for UISegmentedControl)")
    }
    
    func imagePicker(_ picker: OpalImagePickerController, imageURLforExternalItemAtIndex index: Int) -> URL? {
        return URL(string: "https://placeimg.com/500/500/nature")
    }
}



