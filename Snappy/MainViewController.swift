//
//  MainViewController.swift
//  Snappy
//
//  Created by Nasim on 12/31/17.
//  Copyright © 2017 Nasim. All rights reserved.
//

import UIKit
import CLImageEditor
import Photos

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLImageEditorDelegate, GalleryPhotoDelegate{
    
    func didSelectImage(fromGallery image: UIImage) {
        presentImageEditingController(image: image)
    }
    
    let backgroundImage: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    
    let addImageButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "add_image"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleAddImage), for: .touchUpInside)
        return button
    }()
    
    let cameraButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCamera), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setUpViews()
    }
    
    func setUpViews(){
        view.addSubview(backgroundImage)
        view.addSubview(addImageButton)
        view.addSubview(cameraButton)
        
        
        backgroundImage.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        
        
        addImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addImageButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        addImageButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 100, height: 100)
        
        
        cameraButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 25, paddingRight: 0, paddingBottom: 0, width: 25, height: 22)
    }
    
    let gallerySelector = GalleryPhotoSelector()
    
    @objc func handleAddImage(){
        gallerySelector.delegate = self
        gallerySelector.showSettings()
        
    }
    
    @objc func handleCamera(){
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
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if picker.sourceType == .camera {
            dismiss(animated: true, completion: nil)
            if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
                guard let editor = CLImageEditor(image: pickedImage, delegate: self) else {
                    return;
                }
                self.present(editor, animated: true, completion: {});
               
            }
        }
        else {
            // Image, taken from another resource(Photo Gallery, Photo Album)
        }
    }
    
    
    func presentImageEditingController(image: UIImage){
        
        guard let editor = CLImageEditor(image: image, delegate: self) else {
            return;
        }
        
        self.present(editor, animated: true, completion: {});
    }
    
    func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        self.dismiss(animated: true, completion: nil)

        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Snappy", message: "Your image has been saved successfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
}
