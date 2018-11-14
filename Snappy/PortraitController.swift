//
//  PortraitController.swift
//  Snappy
//
//  Created by Nasim on 11/25/17.
//  Copyright © 2017 Nasim. All rights reserved.
//

import UIKit
import CLImageEditor


class PortraitController: UIViewController, CLImageEditorDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let editor = CLImageEditor(image: #imageLiteral(resourceName: "guitar"), delegate: self) else {
            return;
        }
        self.present(editor, animated: true, completion: {});
    }
  
    
    
    
//    func setUpViews(){
//        view.addSubview(originalImageView)
//
//        originalImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
//        originalImageView.image = #imageLiteral(resourceName: "guitar")
//    }
}
