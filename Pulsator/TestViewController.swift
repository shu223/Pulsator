//
//  TestViewController.swift
//  PulsatorDemo
//
//  Created by Dane Thomas on 3/21/17.
//  Copyright © 2017 Shuichi Tsutsumi. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
	@IBOutlet weak var testButton: UIButton!
	let pulsator = Pulsator()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		//pulsator.autoCenter = false
		testButton.layer.addSublayer(pulsator)
		pulsator.start()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func start(_ sender: Any) {
		pulsator.start()
	}

	@IBAction func stop(_ sender: Any) {
		pulsator.stop()
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
