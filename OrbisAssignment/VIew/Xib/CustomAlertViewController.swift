
//
//  CustomAlertViewController.swift
//  OrbisAssignment
//
//  Created by Suraj on 4/5/20.
//  Copyright © 2020 Mobikasa. All rights reserved.
//

import UIKit


class CustomAlertViewController: UIViewController {
    
    //MARK:- IBOutlets
    
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var subTitleLabel: UILabel!
    @IBOutlet fileprivate weak var leftButton: UIButton!
    @IBOutlet fileprivate weak var rightButton: UIButton!
    @IBOutlet fileprivate weak var alertView: UIView!
    @IBOutlet weak var btnContainer: UIView!
    @IBOutlet weak var centerButton: UIButton!
    
    //MARK:- Variables
    fileprivate var leftAction = {}
    fileprivate var rightAction = {}
    fileprivate var centerAction = {}
    fileprivate var retryAction = {}
    fileprivate var titleText:String = ""
    fileprivate var subTitleText:String = ""
    fileprivate var leftBtnTitle:String = ""
    fileprivate var rightBtnTitle:String = ""
    fileprivate var centerBtnTitle:String = ""
    fileprivate var retryBtnTitle:String = ""
    fileprivate var leftBtnColor:UIColor = UIColor.white
    fileprivate var rightBtnColor:UIColor = UIColor.white
    fileprivate static var presentedAlertVCsArr:Set<CustomAlertViewController> = Set()
    
    //MARK:- LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleText
        subTitleLabel.text = subTitleText
        leftButton.setTitle(leftBtnTitle, for: .normal)
        rightButton.setTitle(rightBtnTitle, for: .normal)
        centerButton.setTitle(centerBtnTitle, for: .normal)
        leftButton.backgroundColor = leftBtnColor
        rightButton.backgroundColor = rightBtnColor
        btnContainer.isHidden = !centerBtnTitle.isEmpty
        centerButton.isHidden = centerBtnTitle.isEmpty
        alertView.isHidden = !retryBtnTitle.isEmpty
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
    }
    

    //MARK: - IBActions
    @IBAction private func leftButtonClicked(_ sender: UIButton) {
        dismissAlert()
        leftAction()
    }
    @IBAction private func rightButtonClicked(_ sender: UIButton) {
        dismissAlert()
        rightAction()
    }
    @IBAction private func centerButtonClicked(_ sender: UIButton) {
        dismissAlert()
        centerAction()
    }
  
    
    fileprivate func dismissAlert(){
        CustomAlertViewController.presentedAlertVCsArr.remove(self)//------- Save before presenting
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Helper Methods
    private func setupView() {
        alertView.layer.cornerRadius = 8
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        leftButton.layer.cornerRadius = 4
        rightButton.layer.cornerRadius = 4
        centerButton.layer.cornerRadius = 4
        centerButton.layer.borderWidth = 0
    }
    
    private func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.8, options: UIView.AnimationOptions.curveLinear, animations: {
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        }, completion: nil)
    }
}

//MARK: - Extension

extension UIViewController{
    
    // ----- Checking if the alert is presented or not ------
    private func checkIfSameAlertExistFor(subtitleText: String?) -> Bool{
        let equalAlertsArr = CustomAlertViewController.presentedAlertVCsArr.filter { (alert) -> Bool in
            return ( alert.subTitleText == subtitleText )
        }
        return equalAlertsArr.count > 0
    }
    
    // ------ Single Button Alert ------
    func showSingleBtnAlertWith(title:String?, subTitle:String?, centerBtnTitle:String = "OK", centerBtnAction:@escaping (()->())){
        
        if checkIfSameAlertExistFor(subtitleText: subTitle){ return }//------- Don't show same alert
        let customAlert = CustomAlertViewController()
        customAlert.titleText = title ?? ""
        customAlert.subTitleText = subTitle ?? ""
        customAlert.centerBtnTitle = centerBtnTitle
        customAlert.centerAction = centerBtnAction
        CustomAlertViewController.presentedAlertVCsArr.insert(customAlert) //------- Save before presenting
        presentAlert(customAlert: customAlert)
    }
        
    func showAlertWith(title:String?, subTitle:String?, leftBtnTitle:String = "OK", rightBtnTitle: String = "Cancel", leftBtnColor:UIColor = UIColor.white, rightBtnColor:UIColor = UIColor.white, leftBtnAction:@escaping (()->()), rightBtnAction:@escaping (()->())){
        if checkIfSameAlertExistFor(subtitleText: subTitle){ return }//------- Don't show same alert
        let customAlert = CustomAlertViewController()
        customAlert.titleText = title ?? ""
        customAlert.subTitleText = subTitle ?? ""
        customAlert.leftBtnTitle = leftBtnTitle
        customAlert.rightBtnTitle = rightBtnTitle
        customAlert.leftBtnColor = leftBtnColor
        customAlert.rightBtnColor = rightBtnColor
        customAlert.leftAction = leftBtnAction
        customAlert.rightAction = rightBtnAction
        CustomAlertViewController.presentedAlertVCsArr.insert(customAlert) //------- Save before presenting
        presentAlert(customAlert: customAlert)
    }
 // ----- Presenting alert from here
    private func presentAlert(customAlert: UIViewController){
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        guard let root = UIApplication.shared.keyWindow?.rootViewController else { return }
        root.present(customAlert, animated: true, completion: nil)
    }
}
