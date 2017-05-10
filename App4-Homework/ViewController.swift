//
//  ViewController.swift
//  App4-Homework
//
//  Created by Huy Pham on 5/8/17.
//  Copyright © 2017 Huy Pham. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController , AVAudioPlayerDelegate {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var timeRun: UILabel!
    @IBOutlet weak var timeRun1: UILabel!
    @IBOutlet weak var PlayPause: UIImageView!
    
    var audioPlayer = AVAudioPlayer()
    var timer = Timer()
    var count : Int = 0
    var indexOfSong = 0
    var Music = [
            "Lac-Troi-Son-Tung-M-TP",
            "Noi-Nay-Co-Anh-Son-Tung-M-TP",
            "Yeu-La-Tha-Thu-Em-Chua-18-OST-OnlyC",
            "Anh-Se-Ve-Som-Thoi-Isaac",
            "Anh-Nang-Cua-Anh-Cho-Em-Den-Ngay-Mai-OST-Duc-Phuc",
            "Yeu-5-Rhymastic"
    ]
    
    var NameOfSong = [
        "Lac Troi",
        "Noi Nay Co Anh",
        "Yeu La Tha Thu",
        "Anh Se Ve Som Thoi",
        "Anh Nang Cua Anh",
        "Yeu 5",
    ]
    
    var Singer = [
        "Son Tung MTP",
        "Son Tung MTP",
        "OnlyC",
        "Isaac",
        "Duc Phuc",
        "Rhymastic",
    ]
    
    @IBOutlet weak var Slider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        music()
        
        var time2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: Selector("checkNextSong"), userInfo: nil, repeats: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func music() -> Void {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "\(Music[count])", ofType: "mp3")!))
            name.text = "\(Music[count])"
            audioPlayer.prepareToPlay()
    
            MPNowPlayingInfoCenter.default().nowPlayingInfo = [
                MPMediaItemPropertyTitle : "\(NameOfSong[count])",
                MPMediaItemPropertyArtist : "\(Singer[count])"
            ]
            UIApplication.shared.beginReceivingRemoteControlEvents()
            becomeFirstResponder()
        }
        catch {
            print("error")
        }
        Slider.maximumValue = Float(audioPlayer.duration)
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: Selector("updateSlider"), userInfo: nil, repeats: true)
    
        timeRun.text = changTime(time: Int(Slider.value))

    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        if let event = event {
            if event.type == .remoteControl {
                switch event.subtype {
                case .remoteControlPlay:
                    audioPlayer.play()
                case .remoteControlPause:
                    audioPlayer.pause()
                case .remoteControlNextTrack:
                    nextSong()
                case .remoteControlPreviousTrack:
                    backSong()
                default:
                    print("Nothing!!!")
                }
            }
        }
    }

    @IBAction func btPlay(_ sender: Any) {
        
        if(audioPlayer.isPlaying){
            audioPlayer.stop()
            PlayPause.image = UIImage(named: "play.png")
        }else {
            PlayPause.image = UIImage(named: "pause.jpeg")
            audioPlayer.play()
        }
        
    }
    
    @IBAction func btPause(_ sender: Any) {
        
        if audioPlayer.isPlaying {
            audioPlayer.stop()
        }
    }
    
    @IBAction func ChangeAudioTime(_ sender: UISlider) {
        audioPlayer.stop()
        audioPlayer.currentTime = TimeInterval(Slider.value)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }

    @IBAction func btNext(_ sender: Any) {
        nextSong()
        
    }

    @IBAction func btPrev(_ sender: Any) {
        backSong()
    }
    
    func nextSong()  {
        if count == Music.count - 1 {
            count = 0
            music()
            audioPlayer.play()
        }else{
            count += 1
            music()
            audioPlayer.play()
        }
        
    }
    func backSong()  {
        
        if count == 0 {
            count = Music.count - 1
            music()
            audioPlayer.play()
        }else{
            count -= 1
            music()
            audioPlayer.play()
        }
    }

    
    func changTime(time : Int) -> String {
        var timeString : String = " "
        let minutes : Int = time / 60;
        let seconds : Int = time % 60;
        if seconds < 10 {
            timeString = "0\(minutes):0\(seconds)"
        } else {
            timeString = "0\(minutes):\(seconds)"
        }
        return timeString
    }
    
    func timeDuration(){
        let songTime = Int(self.audioPlayer.duration) + 1
        timeRun1.text = changTime(time: songTime)
        timeRun.text = changTime(time: Int(Slider.value))
    }
    
    func updateSlider() {
        Slider.value = Float(audioPlayer.currentTime)
    }
    
    func checkNextSong()  {
        timeDuration()
        if( Int(Slider.value) ==  Int(audioPlayer.duration)){
            nextSong()
        }
        
    }

    
}

