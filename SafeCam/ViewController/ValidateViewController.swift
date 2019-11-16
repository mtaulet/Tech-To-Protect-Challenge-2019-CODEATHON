//
//  ValidateViewController.swift
//  SafeCam
//
//  Created by Jesús Aguas Acin on 03/11/2019.
//  Copyright © 2019 Jesus Aguas Acin. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG



class ValidateViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var ref = Database.database().reference()
    var image = UIImage()
    var validate = true
    
    let imagePicker = UIImagePickerController()

    @IBOutlet var imageView: UIImageView!

    @IBAction func loadImageButtonTapped(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)

    }

    @IBAction func Validate(_ sender: UIButton) {
        // Image to String
        if(validate){
            validate = false
            //Change view
            self.performSegue(withIdentifier: "correct", sender: self)
            
        }
        else{
            validate = true
            //Change view
            self.performSegue(withIdentifier: "false", sender: self)
            
        }
    }
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    func MD5(string: String) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)

        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }

    func readDB(hash: String){
        self.ref.child(hash).observeSingleEvent(of: .value, with: {
            (snapshot) in
            let data = snapshot.value as? String
            print(data)
            if (hash == data){
                print("Eyo")
            }else if (data == nil){
                print(":(")
            }
        })
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            self.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
