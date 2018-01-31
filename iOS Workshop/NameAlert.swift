//
//  NameAlert.swift
//  iOS Workshop
//
//  Created by John Kotz on 1/31/18.
//  Copyright © 2018 You!. All rights reserved.
//

import Foundation
import UIKit

func showNameAlert(on viewController: UIViewController, callback: @escaping (_ name: String) -> Void) {
	let alertController = UIAlertController(title: "Name the balace", message: nil, preferredStyle: .alert)
	var textField: UITextField? = nil
	alertController.addTextField { (field) in
		textField = field
	}
	alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
	alertController.addAction(UIAlertAction(title: "Create", style: .default, handler: { (action) in
		let name = textField!.text!
		callback(name)
	}))
	viewController.present(alertController, animated: true, completion: nil)
}
