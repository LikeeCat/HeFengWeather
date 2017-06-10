//
//  PostDiscoverViewController.swift
//  和风天气
//
//  Created by 樊树康 on 17/3/23.
//  Copyright © 2017年 猫鼬鼠. All rights reserved.
//

import UIKit
import LeanCloud
class PostDiscoverViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate{

    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var img: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bg.image = UIImage.init(named: "bg_sunny_night.jpg")
        
        self.img.isHidden = true
        // Do any additional setup after loading the view.
    }

    
    @IBAction func camera(_ sender: Any) {
        let picker = UIImagePickerController.init()
        picker.allowsEditing = true
        picker.delegate = self
        popAlertSheet(picker:picker)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.img.image = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismiss(animated: true, completion: nil)
        self.img.isHidden = false
    }
    
    @IBOutlet weak var text: UITextView!
    
    
    @IBAction func post(_ sender: AnyObject) {
        
        let record = DiscoverTable()
        record.commentCount = 0
        record.isPraise = false
        record.praiseCount = 0
        record.location = "安阳市"
        if (self.img.image == nil){
            record.type = 0
        }else{
            record.type = LCNumber.init(1)
            record.imageCount = 1
            let data = UIImageJPEGRepresentation(self.img.image!, 0.5)
            record.image = LCData.init(data!)
        }
        if text.text != "" {
            record.text = LCString.init(text.text!)
        }
        record.createTime = "1:00"
        record.userName = LCString.init(UserDefaults.standard.value(forKey: "loginUser") as! String)
        record.save()
        self.dismiss(animated: true) {
            print("退出成功")
        }
    }

    
    
    
    
    func popAlertSheet(picker:UIImagePickerController){
        
        let alertVC = UIAlertController.init(title: "选择", message: "拍照还是图库", preferredStyle: .actionSheet)
        let camera = UIAlertAction.init(title: "拍照", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                picker.sourceType = .camera
                picker.navigationController?.navigationBar.backgroundColor = UIColor.blue
                self.show(picker, sender: self)
            }
        }
        let library = UIAlertAction.init(title: "图库", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                picker.sourceType = .photoLibrary
                picker.navigationController?.view.backgroundColor = UIColor.blue
                self.navigationController?.view.backgroundColor = UIColor.yellow
                self.show(picker, sender: self)
            }
        }
        let cancel  = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
        }
        alertVC.addAction(camera)
        alertVC.addAction(library)
        alertVC.addAction(cancel)
        
        self.present(alertVC, animated: true, completion:nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.text.resignFirstResponder()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true) {
            print("退出成功")
        }

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
