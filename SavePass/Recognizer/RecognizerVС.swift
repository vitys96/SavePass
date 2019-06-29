//
//  RecognizerVС.swift
//  SavePass
//
//  Created by Виталий Охрименко on 29/06/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import UIKit
import PayCardsRecognizer

class RecognizerViewController: UIViewController, PayCardsRecognizerPlatformDelegate {
    
    lazy var activityView: UIBarButtonItem = {
        let activityView = UIActivityIndicatorView(style: .gray)
        activityView.startAnimating()
        let item = UIBarButtonItem(customView: activityView)
        return item
    }()
    
    var recognizer: PayCardsRecognizer!
    
    @IBOutlet weak var recognizerContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recognizer = PayCardsRecognizer(delegate: self, resultMode: .async, container: recognizerContainer, frameColor: .green)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        recognizer.startCamera()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        recognizer.stopCamera()
        navigationItem.rightBarButtonItem = nil
    }
    
    func payCardsRecognizer(_ payCardsRecognizer: PayCardsRecognizer, didRecognize result: PayCardsRecognizerResult) {
        if result.isCompleted {
            performSegue(withIdentifier: "CardDetailsViewController", sender: result)
        } else {
            navigationItem.rightBarButtonItem = activityView
        }
    }
    
    @IBAction func start() {
        recognizer.startCamera()
    }
    
    @IBAction func stop() {
        recognizer.stopCamera()
    }
    
    @IBAction func restart() {
        recognizer.resumeRecognizer()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! NewCardTableVC
        vc.result = sender as? PayCardsRecognizerResult
    }
    
}
