//
//  LoginViewController.swift
//  Twitter-Tool
//
//  Created by Byron J. Williams on 10/25/16.
//  Copyright © 2016 Byron J. Williams. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
                       // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func onLoginButton(_ sender: AnyObject) {
        let twitterClient =  TwitterClient.sharedInstance
        
        twitterClient?.login(success: {
//            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            self.performSegue(withIdentifier: "hamburgerSegue", sender: nil)

        }, failure: { (error: Error) in
            print("Error trying to Login (onLoginButton) from ViewController: \(error.localizedDescription)")
        })
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
