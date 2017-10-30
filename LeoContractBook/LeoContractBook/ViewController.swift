//
//  ViewController.swift
//  LeoContractBook
//
//  Created by vijay vir on 10/27/17.
//  Copyright © 2017 vijay vir. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
	@IBOutlet var leoSwiftAddressBookO: LeoSwiftAddressBookO!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		leoSwiftAddressBookO.configure()

		if "ffs8dd" =^ LeoRegex.LeoRegexType.alphabets.pattern {

			 print("Is alphabets")

		} else {
            print("Is not alphabets")
		}

		// Do any additional setup after loading the view, typically from a nib.
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}


