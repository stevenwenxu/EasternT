//
//  FirstViewController.swift
//  EasternT
//
//  Created by Steven Xu on 2016-09-16.
//  Copyright © 2016 EasternT. All rights reserved.
//

import UIKit
import Speech

class FirstViewController: UIViewController, SFSpeechRecognizerDelegate {

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    @IBOutlet weak var recordButtonA: UIButton!
    @IBOutlet weak var recordButtonB: UIButton!
    @IBOutlet weak var speechLabel: UILabel!

    let model = ETBrain()

    // MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.speechRecognizer.delegate = self
        self.requestPermission()
    }

    @IBAction func recordButtonTapped(sender: UIButton) {
        if self.audioEngine.isRunning {
            self.audioEngine.stop()
            recognitionRequest?.endAudio()
            sender.isEnabled = false
        } else {
            try! self.startRecording(sender: sender)
        }
    }

    func requestPermission() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.recordButtonA.isEnabled = true
                    self.recordButtonB.isEnabled = true

                default:
                    self.recordButtonA.isEnabled = false
                    self.recordButtonB.isEnabled = false
                }
            }
        }
    }

    func startRecording(sender: UIButton) throws {
        // Cancel the previous task if it's running.
        if let recognitionTask = self.recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)

        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        guard let inputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }

        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = true

        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        self.recognitionTask = self.speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false

            if let result = result {
                self.speechLabel.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }

            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil

                sender.isEnabled = true
            }
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }

        self.audioEngine.prepare()

        try self.audioEngine.start()

        self.speechLabel.text = "(Go ahead, I'm listening)"

    }

    // MARK: - SFSpeechRecognizerDelegate
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        self.recordButtonA.isEnabled = available
        self.recordButtonA.isEnabled = available
    }

}

