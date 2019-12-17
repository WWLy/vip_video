//
//  YYMainController.swift
//  vip_video
//
//  Created by WWLy on 2019/12/16.
//  Copyright © 2019 YY. All rights reserved.
//

import UIKit

class YYMainController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
}

extension YYMainController {
    func initUI() {
        
        self.view.backgroundColor = UIColor.white
        
        let txBtn = UIButton(type: .custom)
        txBtn.setImage(UIImage.init(named: "tx_video"), for: .normal)
        txBtn.frame = CGRect(x: 100, y: 100, width: 150, height: 70);
        txBtn.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height * 0.5)
        txBtn.imageView?.contentMode = .scaleAspectFit
        self.view.addSubview(txBtn)
        txBtn.addTarget(self, action: #selector(txBtnClick), for: .touchUpInside)
    }
    
    @objc func txBtnClick() {
        let urlString = "https://m.v.qq.com/index.html"
        let webVC = YYWebController()
        webVC.showPlayButton(isShow: true)
        webVC.loadURL(urlString: urlString)
        self.navigationController?.pushViewController(webVC, animated: true)
    }
}
