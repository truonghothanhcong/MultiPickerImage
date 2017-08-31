//
//  ViewController.swift
//  MultiImagePicker
//
//  Created by CongTruong on 8/29/17.
//  Copyright © 2017 congtruong. All rights reserved.
//

import UIKit
import Photos



class ViewController: UIViewController, MultiImagePickerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    func pickerMultiImage(images: [UIImage]) {
        print(images.count)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MultiPickerViewController
        
        vc.delegate = self
    }
}

