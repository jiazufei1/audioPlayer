//
//  ViewController.swift
//  audioPlayer
//
//  Created by caofei on 2020/12/31.
//

import UIKit
import SwiftAudioPlayer
import AVFoundation
//import CCVodSDK

class ViewController: UIViewController {
    
    
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var currentTimeLB: UILabel!
    
    @IBOutlet weak var totalTimeLB: UILabel!
    
    var beingSeeked: Bool = false
    
    var duration: Double = 0.0
    
    var isPlayable: Bool = false {
        didSet {
            //控制一些按钮逻辑
            if isPlayable {
            } else {
            }
        }
    }
    
    let bufferSize = 2048
    lazy var analyzer: RealtimeAnalyzer = {
        let analyzer = RealtimeAnalyzer(fftSize: Int32(bufferSize))
        return analyzer
    }()
    lazy var spectrumView: SpectrumView = {
        let spectrumView = SpectrumView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200))
        return spectrumView
    }()
    ///CC播放器，包含渲染view
//    lazy var ccPlayerView:DWPlayerView = {
//        let player = DWPlayerView()
//        player!.frame = CGRect(x: 0, y: 200, width: self.view.frame.size.width, height: 200)
//        return player!
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupURL()
        setupPlayer()
        configUpdate()
    }

    func setupUI(){
        self.view.addSubview(spectrumView)
        self.slider.addTarget(self, action: #selector(scrubberStartedSeeking), for: .touchDown)
        self.slider.addTarget(self, action: #selector(scrubberSeeked(_:)), for: .touchUpInside)
        self.slider.addTarget(self, action: #selector(scrubberSeeked(_:)), for: .touchUpOutside)
    }
    
    func setupURL(){
     
        let url = URL(string: "https://s.aigei.com/pvaud/aud/mp3/69/694d7920d49a4db2b60ab5d26c7e6dd0.mp3?e=1609705440&token=P7S2Xpzfz11vAkASLTkfHN7Fw-oOZBecqeJaxypL:NYpdS6DFiba9LyHOuGxxrgFsTj8=")!
        SAPlayer.shared.startRemoteAudio(withRemoteUrl: url)
        SAPlayer.shared.DEBUG_MODE = true
    }
    func setupPlayer(){
        
        if let engine = SAPlayer.shared.engine ,let playerNode = SAPlayer.shared.playerNode {
            engine.attach(playerNode)
            let mixerNode = engine.mainMixerNode
            engine.connect(playerNode, to: mixerNode, format: mixerNode.outputFormat(forBus: 0))
            do {
                try engine.start()
                mixerNode.removeTap(onBus: 0)
                mixerNode.installTap(onBus: 0, bufferSize: AVAudioFrameCount(bufferSize), format: mixerNode.outputFormat(forBus: 0)) { [weak self](buffer:AVAudioPCMBuffer, when:AVAudioTime) in
                    if !playerNode.isPlaying {
                        return
                    }
                    buffer.frameLength = AVAudioFrameCount(self?.bufferSize ?? 2048)
                    if let spectrums:Array = self?.analyzer.analyse(buffer, withAmplitudeLevel: 5) {
                        self?.spectrumView.updateSpectra(spectrums, withStype: .round)
                    }
                }
            } catch {
                print(error)
            }
        }
        
    }
    
    
    func configUpdate(){
        
        _ = SAPlayer.Updates.Duration.subscribe { [weak self] (url, duration) in
            guard let self = self else { return }
//            guard url == self.selectedAudio.url || url == self.savedUrls[self.selectedAudio] else { return }
            self.totalTimeLB.text = SAPlayer.prettifyTimestamp(duration)
            self.duration = duration
        }
        
        _ = SAPlayer.Updates.ElapsedTime.subscribe { [weak self] (url, position) in
            guard let self = self else { return }
            self.currentTimeLB.text = SAPlayer.prettifyTimestamp(position)
            
            guard self.duration != 0 else { return }
            if !self.beingSeeked{
                self.slider.value = Float(position/self.duration)
            }
        }
        
        _ = SAPlayer.Updates.AudioDownloading.subscribe { [weak self] (url, progress) in
            guard self != nil else { return }
            print("audioDownloadingprogress = \(String(format: "%.2f", (progress * 100)))%")
        }
        
        _ = SAPlayer.Updates.StreamingBuffer.subscribe{ [weak self] (url, buffer) in
            guard let self = self else { return }

            
            if self.duration == 0.0 { return }
            print("bufferingProgress = \(String(format: "%.2f", (buffer.bufferingProgress * 100)))%")
            
            self.isPlayable = buffer.isReadyForPlaying
        }
        
        _ = SAPlayer.Updates.PlayingStatus.subscribe { [weak self] (url, playing) in
            guard let self = self else { return }
       
            switch playing {
            case .playing:
                self.isPlayable = true
                self.playBtn.setTitle("Pause", for: .normal)
                return
            case .paused:
                self.isPlayable = true
                self.playBtn.setTitle("Play", for: .normal)
                return
            case .buffering:
                self.isPlayable = false
                self.playBtn.setTitle("Loading", for: .normal)
                return
            case .ended:
                self.isPlayable = false
                self.playBtn.setTitle("Done", for: .normal)
                return
            }
        }
        
        
       
    }
    
    @objc func scrubberStartedSeeking(_ sender: UISlider) {
        beingSeeked = true
    }
    
    @objc  func scrubberSeeked(_ sender: Any) {
        let value = Double(slider.value) * duration
        SAPlayer.shared.seekTo(seconds: value)
        beingSeeked = false
    }
    
    @IBAction func btnAction(_ sender: Any) {
        SAPlayer.shared.togglePlayAndPause()
    }
    func  rateChanged(speed:Float){
        if let node = SAPlayer.shared.audioModifiers[0] as? AVAudioUnitTimePitch {
            node.rate = speed
            SAPlayer.shared.playbackRateOfAudioChanged(rate: speed)
        }
    }
     func skipBackwardTouched() {
        SAPlayer.shared.skipBackwards()
    }
    
     func skipForwardTouched() {
        SAPlayer.shared.skipForward()
    }
}

