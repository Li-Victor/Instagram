//
//  HomeViewController.swift
//  Instagram
//
//  Created by Victor Li on 9/18/18.
//  Copyright © 2018 Victor Li. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var homeFeedNavItem: UINavigationItem!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let resizedImage = resize(image: originalImage, newSize: CGSize(width: 300, height: 300))
        
        Post.postUserImage(image: resizedImage, withCaption: "ride or die") { (success: Bool, error: Error?) in
            if success {
                print("successfully posted image")
                // Dismiss UIImagePickerController to go back to your original view controller
                self.dismiss(animated: true, completion: nil)
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    @objc func onLogout() {
        NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
    }
    
    @objc func takePhoto() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up nav bar
        let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: nil, action: #selector(HomeViewController.onLogout))
        
        let takePhotoBarButtonItem = UIBarButtonItem(image: UIImage(named: "insta_camera_btn"), style: .plain, target: nil, action: #selector(HomeViewController.takePhoto))

        homeFeedNavItem.leftBarButtonItem = logoutBarButtonItem
        homeFeedNavItem.rightBarButtonItem = takePhotoBarButtonItem
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
