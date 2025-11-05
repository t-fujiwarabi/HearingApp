//
//  SettingViewController.swift
//  HearingApp
//
//  Created by 藤原崇志 on 2025/10/22.
//

import UIKit

struct SoundOption {
    let label: String       // 表示用（例："40 dB"）
    let value: Float        // 実際に使う数値（例：40.0）
}

    
class SettingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var sound40PickerView: UIPickerView! //40dBの音調整用
    @IBOutlet weak var sound45PickerView: UIPickerView! //45dBの音調整用
    
    // ユーザーデフォルトへの保存用キー
    private let UDKeySelected40Index = "selected40Index"
    private let UDKeySelected45Index = "selected45Index"
    
    // 40dB用（例：音圧レベルの微調整 ±5dB）
    var sound40Options: [SoundOption] = [
        SoundOption(label: "+4", value: 0.9),
        SoundOption(label: "+3", value: 0.8),
        SoundOption(label: "+2", value: 0.7),
        SoundOption(label: "+1", value: 0.6),
        SoundOption(label: "0", value: 0.5),
        SoundOption(label: "-1", value: 0.4),
        SoundOption(label: "-2", value: 0.3),
        SoundOption(label: "-3", value: 0.2),
        SoundOption(label: "-4", value: 0.1)
    ]

    // 45dB用
    var sound45Options: [SoundOption] = [
        SoundOption(label: "+4", value: 0.9),
        SoundOption(label: "+3", value: 0.8),
        SoundOption(label: "+2", value: 0.7),
        SoundOption(label: "+1", value: 0.6),
        SoundOption(label: "0", value: 0.5),
        SoundOption(label: "-1", value: 0.4),
        SoundOption(label: "-2", value: 0.3),
        SoundOption(label: "-3", value: 0.2),
        SoundOption(label: "-4", value: 0.1)
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // データソースの設定
        sound45PickerView.dataSource = self
        sound40PickerView.dataSource = self
        // デリゲートの設定
        sound45PickerView.delegate = self
        sound40PickerView.delegate = self
        // PickerViewの情報の保管
        restorePickerSelections()
    }

    // PickerView一つあたりの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // PickerView一つあたりの行の数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          if pickerView == sound40PickerView {
              return sound40Options.count
          } else {
              return sound45Options.count
          }
      }

    // MARK: - Picker Delegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == sound40PickerView {
            return sound40Options[row].label
        } else {
            return sound45Options[row].label
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let defaults = UserDefaults.standard
        if pickerView == sound40PickerView {
            defaults.set(row, forKey: UDKeySelected40Index)
            print("40dBピッカー 選択行\(row): \(sound40Options[row].label)")
        } else if pickerView == sound45PickerView {
            defaults.set(row, forKey: UDKeySelected45Index)
            print("45dBピッカー 選択行\(row): \(sound45Options[row].label)")
        }
    }

    // MARK: - 保存されたindexの復元

    private func restorePickerSelections() {
        let defaults = UserDefaults.standard

        // 40dBピッカー復元
        let saved40Index = defaults.integer(forKey: UDKeySelected40Index) // デフォルト0
        if saved40Index < sound40Options.count {
            sound40PickerView.selectRow(saved40Index, inComponent: 0, animated: false)
        }

        // 45dBピッカー復元
        let saved45Index = defaults.integer(forKey: UDKeySelected45Index)
        if saved45Index < sound45Options.count {
            sound45PickerView.selectRow(saved45Index, inComponent: 0, animated: false)
        }
    }
}
    
