//
//  ViewController.swift
//  Snappy
//
//  Created by Nasim on 11/24/17.
//  Copyright © 2017 Nasim. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var selectedImage:UIImage? {
        didSet{
            self.originalImageView.image = selectedImage
        }
    }
    
    private let filtersScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .black
        return scrollView
    }()
    
    let containerView: UIView = {
        let iv = UIView()
        iv.backgroundColor = .white
        return iv
    }()
    
    let originalImageView: UIImageView = {
       let oiv = UIImageView()
       oiv.image = #imageLiteral(resourceName: "guitar")
       oiv.contentMode = .scaleAspectFit
       return oiv
    }()
    
    let filteredImageView: UIImageView = {
        let oiv = UIImageView()
        oiv.contentMode = .scaleAspectFit
        return oiv
    }()
    
    
    var CIFilterNames = [
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISepiaTone",
        "CIVignette"
    ]
    
    override var prefersStatusBarHidden: Bool{
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        
        navigationItem.title = "Snappy"
        
        setUpNavigationButton()
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var xCoord: CGFloat = 5
        let yCoord: CGFloat = 5
        let buttonWidth: CGFloat = 70
        let buttonHeight:CGFloat = 70
        let gapBetweenButtons: CGFloat = 5
        
        var itemCount = 0
        
        for i in 0..<CIFilterNames.count{
            itemCount = i
            //Button properties
            let filterButton = UIButton(type: .custom)
            filterButton.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            filterButton.tag = itemCount
            filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
            filterButton.layer.cornerRadius = 6
            filterButton.clipsToBounds = true
            
            // Create filters for each button
            let ciContext = CIContext(options: nil)
            guard let img = originalImageView.image else {return}
            let coreImage = CIImage(image: img)
            let filter = CIFilter(name: "\(CIFilterNames[i])")
            filter?.setDefaults()
            filter?.setValue(coreImage, forKey: kCIInputImageKey)
            let filteredImageData = filter?.value(forKeyPath: kCIOutputImageKey) as! CIImage
            let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
            let imageForButton = UIImage(cgImage: filteredImageRef!)
            
            filterButton.setBackgroundImage(imageForButton, for: .normal)
            
            xCoord += buttonWidth + gapBetweenButtons
            filtersScrollView.addSubview(filterButton)
        }
        
        
        //Resize scroll view
        filtersScrollView.contentSize = CGSize(width: buttonWidth * CGFloat(itemCount + 2), height: yCoord)
    }
    

    func setUpNavigationButton(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleImageSave))
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func handleImageSave(){
        UIImageWriteToSavedPhotosAlbum(filteredImageView.image!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Snappy", message: "Your image has been saved successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handleCamera() {
        //This condition is used for check availability of camera
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true;
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Alert", message: "You don't have a camera for this device", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setUpViews(){
        view.addSubview(containerView)
        view.addSubview(filtersScrollView)
        
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: filtersScrollView.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        
        
        guard let heightTabBar = tabBarController?.tabBar.frame.height else {return}
        let estimatedHeight = -CGFloat(heightTabBar)
        
        
        filtersScrollView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 80)
        filtersScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: estimatedHeight).isActive = true
        
        containerView.addSubview(originalImageView)
        
        containerView.addSubview(filteredImageView)
        
        originalImageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        
        filteredImageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
    }
    
    @objc func filterButtonTapped(sender: UIButton){
        let button = sender as UIButton
        
        filteredImageView.image = button.backgroundImage(for: .normal)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if picker.sourceType == .camera {
            originalImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
            dismiss(animated: true, completion: nil)
        }
        else {
            // Image, taken from another resource(Photo Gallery, Photo Album)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
}

