//
//  SoundViewController.swift
//  HearingApp
//
//  Created by 藤原崇志 on 2025/10/22.
//

import UIKit

class SoundViewController: UIViewController {
    
    @IBOutlet weak var soundButton: UIButton!
    
    @IBAction func changeButton(_ sender: UIButton) {
        if sender.backgroundColor == UIColor.systemMint {
            // ピンクに変える
            sender.backgroundColor = .systemPink
            sender.setTitle("停止", for: .normal)
            sender.setTitleColor(.black, for: .normal)
        } else {
            // ミントに変える
            sender.backgroundColor = .systemMint
            sender.setTitle("開始", for: .normal)
            sender.setTitleColor(.black, for: .normal)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButton()
        
        
    }
    
    func configureButton() {
        // 丸くする
         soundButton.layer.cornerRadius = soundButton.bounds.width / 2
         
         // 背景色を初期設定（ミント）
         soundButton.backgroundColor = .systemMint
         
         // 文字色と文字サイズ
         soundButton.setTitleColor(.black, for: .normal)
         soundButton.titleLabel?.font = UIFont.systemFont(ofSize: 38, weight: .bold)
         
         // 初期タイトル
         soundButton.setTitle("開始", for: .normal)
    }
}
