//
//  SoundViewController.swift
//  HearingApp
//
//  Created by 藤原崇志 on 2025/10/22.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {

    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var frequencySegment: UISegmentedControl!

    // AVAudioEngine関連
    var audioEngine: AVAudioEngine?
    var player: AVAudioPlayerNode?
    var buffer: AVAudioPCMBuffer?

    // 状態
    var currentFrequency: Double = 1000.0
    private var isPlaying = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSegment()
        configureButton()
        setupAudioSession()
        prepareTone(frequency: currentFrequency) // 次回再生用に音を準備
    }

    // Auto Layout後に角丸を確実に反映
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        soundButton.layer.cornerRadius = soundButton.bounds.width / 2
    }

    // 見た目設定（ボタン）
    func configureButton() {
        soundButton.backgroundColor = .systemMint
        soundButton.setTitleColor(.black, for: .normal)
        soundButton.titleLabel?.font = UIFont.systemFont(ofSize: 38, weight: .bold)
        soundButton.setTitle("開始", for: .normal)
    }

    // 見た目設定（周波数セグメント）
    func configureSegment() {
        frequencySegment.removeAllSegments()
        frequencySegment.insertSegment(withTitle: "1000 Hz", at: 0, animated: false)
        frequencySegment.insertSegment(withTitle: "2000 Hz", at: 1, animated: false)
        frequencySegment.selectedSegmentIndex = 0
        frequencySegment.isEnabled = true
    }

    // 🔈 サイン波のPCMデータを生成
    func prepareTone(frequency: Double) {
        let sampleRate: Double = 44_100
        let duration: Double = 1.0  // 1秒分をループ
        let frameCount = AVAudioFrameCount(sampleRate * duration)

        let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
        let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount)!
        buf.frameLength = frameCount

        let theta = 2.0 * Double.pi * frequency / sampleRate
        let channel = buf.floatChannelData!.pointee
        for i in 0..<Int(frameCount) {
            channel[i] = Float(sin(theta * Double(i)))
        }
        self.buffer = buf
    }

    // ▶️/⏹ ボタン
    @IBAction func changeButton(_ sender: UIButton) {
        if sender.backgroundColor == .systemMint {
            // 再生開始
            startTone()
            isPlaying = true
            frequencySegment.isEnabled = false  // 再生中は切替不可

            sender.backgroundColor = .systemPink
            sender.setTitle("停止", for: .normal)
        } else {
            // 停止
            stopTone()
            isPlaying = false
            frequencySegment.isEnabled = true   // 停止中のみ切替可

            sender.backgroundColor = .systemMint
            sender.setTitle("開始", for: .normal)
        }
    }

    // 周波数切替（停止中のみ反映）
    
    @IBAction func frequencyChanged(_ sender: UISegmentedControl) {
        if isPlaying {
            // 保険：再生中に触られても無視し、UIを元のインデックスに戻す
            sender.selectedSegmentIndex = (currentFrequency == 1000.0) ? 0 : 1
            return
        }
        currentFrequency = (sender.selectedSegmentIndex == 0) ? 1000.0 : 2000.0
        prepareTone(frequency: currentFrequency) // 次に再生したときに反映
    }

    // 再生開始
    func startTone() {
        guard let buffer = buffer else { return }

        let engine = AVAudioEngine()
        let node = AVAudioPlayerNode()
        engine.attach(node)
        engine.connect(node, to: engine.mainMixerNode, format: buffer.format)

        do {
            try engine.start()
            node.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
            node.play()
            self.audioEngine = engine
            self.player = node
        } catch {
            print("AudioEngine error: \(error.localizedDescription)")
        }
    }

    // 停止
    func stopTone() {
        player?.stop()
        audioEngine?.stop()
        audioEngine = nil
        player = nil
    }

    // サイレントスイッチでも鳴らす設定（必要なら）
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: [.defaultToSpeaker])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("AudioSession error: \(error.localizedDescription)")
        }
    }
}
