//
//  Utils.swift
//  DisneyCodeTest
//
//  Created by Jonathan Duty on 8/8/17.
//  Copyright © 2017 Class Extension. All rights reserved.
//

import Foundation
import UIKit

func onMainThread(_ block: @escaping () -> Void) {
    DispatchQueue.main.async {
        block()
    }
}

public extension UIViewController {
    
    func presentAlertWithTitle(title: String, message: String, actions: [UIAlertAction] = []) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if actions.isEmpty {
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
        }
        else {
            actions.forEach({alertController.addAction($0)})
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    
}
