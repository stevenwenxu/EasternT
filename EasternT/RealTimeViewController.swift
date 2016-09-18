//
//  FirstViewController.swift
//  EasternT
//
//  Created by Steven Xu on 2016-09-16.
//  Copyright © 2016 EasternT. All rights reserved.
//

import Foundation
import UIKit
import Speech


class RealTimeViewController: UIViewController, SFSpeechRecognizerDelegate, WriteValueBackDelegate {

    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var chooseLangButtonA: UIButton!
    @IBOutlet weak var chooseLangButtonB: UIButton!
    var selectedChooseLangBtn: UIButton!
    var selectedRecordButton: UIButton!
    @IBOutlet var selectLanguageContainerBottom: NSLayoutConstraint!
    @IBOutlet weak var selectLanguageContainer: UIView!

    @IBOutlet weak var resultTextView: UITextView!
    var languageTypeA: LanguageType = .english
    var languageTypeB: LanguageType = .chinese

    @IBOutlet weak var speechLabel: UILabel!

    let normal = UIImage(named: "recordButton")
    var waveImages = [UIImage]()
    var userId : UInt = 0

    var inputText = ""

    var isLeftButton = true

    var translateTextChunkList: [String] = []
    var textChunkSemaphore = DispatchSemaphore(value: 0)

    private var isRecordingInProgress = false {
        didSet {
            if (self.isRecordingInProgress) {
                self.selectedRecordButton.setImage(UIImage(named: "tmp-1"), for: .normal)
                self.selectedRecordButton.imageView?.animationImages = self.waveImages
                self.selectedRecordButton.imageView?.animationDuration = 0
                self.selectedRecordButton.imageView?.startAnimating()
            } else {
                self.selectedRecordButton.imageView?.stopAnimating()
                self.selectedRecordButton.setImage(self.normal, for: .normal)
                self.recognitionTask = nil
            }
        }
    }

    let model = ETBrain()

    // MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        TokenManager.sharedInstance.refreshToken()
        self.speechRecognizer.delegate = self

//        self.resultTextView.

        for i in 0...40 {
            self.waveImages.append(UIImage(named: "tmp-\(i)")!)
        }
    }

    @IBAction func recordButtonTapped(sender: UIButton) {
        // QuickBlox Chat stuffs

        self.selectedRecordButton = sender
        let languageTypeFrom = self.languageTypeA

        if audioEngine.isRunning || self.isRecordingInProgress {
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
            audioEngine.inputNode?.removeTap(onBus: 0)
            self.isRecordingInProgress = false

        } else {
            do {
                speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: languageTypeStringMapB[languageTypeFrom]!))!
                speechRecognizer.delegate = self

                try self.startRecording()
                self.isRecordingInProgress = true
            } catch {
                NSLog("Got exception in startRecording: \(error)")
            }
        }
    }

    @IBAction func languageButtonDidTap(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.selectLanguageContainerBottom.constant = 0
            self.view.layoutIfNeeded()
        }
        self.selectedChooseLangBtn = sender
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "realTimeSelectSegue") {
            let selectLanguageVC = segue.destination as! SelectLanguageViewController
            selectLanguageVC.delegate = self
        }
    }

    func startRecording() throws {

        // Cancel the previous task if it's running.
        if let recognitionTask = self.recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)

        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        guard let inputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }

        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = true

        // Initialize the translation service
        DispatchQueue.global(qos: .background).async {
            while (true) {
                if 0 == self.translateTextChunkList.count {
                    self.textChunkSemaphore.wait()
                } else {
                    let languageTypeFrom = self.languageTypeA
                    let languageTypeTo = self.languageTypeB
                    let translateTextChunk = self.translateTextChunkList[0]
                    self.translateTextChunkList.remove(at: 0)

                    NetworkManager.sharedInstance.getTranslate(originText: translateTextChunk, from: languageTypeFrom, to: languageTypeTo) { string in
                        if let str = string {
                            self.resultTextView.text = str
//                            self.model.textToSpeech(text: str, languageType: languageTypeTo)
                        }
                    }
                }
            }
        }

        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        self.recognitionTask = self.speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in

            var isFinal = false
            if let error = error {
                NSLog("Got error in recording: \(error)")
            }

            if let weakSelf = self, let result = result {
                let recognizedText = result.bestTranscription.formattedString
                weakSelf.inputText = recognizedText
                weakSelf.speechLabel.text = recognizedText

                weakSelf.tryTranslateText(recognizedText: recognizedText)

                isFinal = result.isFinal

                if error != nil || isFinal {
                    weakSelf.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    weakSelf.recognitionRequest = nil
                    weakSelf.recognitionTask = nil
                    weakSelf.isRecordingInProgress = false
                }
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

    // MARK: - WriteValueBackDelegate

    func writeValueBack(languageType: LanguageType) {
        UIView.animate(withDuration: 0.5) {
            self.selectedChooseLangBtn?.setTitle(languageType.rawValue, for: .normal)
            self.selectLanguageContainerBottom.constant = -250
            self.view.layoutIfNeeded()
        }

        if self.chooseLangButtonA == self.selectedChooseLangBtn {
            self.languageTypeA = languageType
        } else {
            self.languageTypeB = languageType
        }
    }

    // MARK: - SFSpeechRecognizerDelegate
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        self.recordButton.isEnabled = available
    }

    func tryTranslateText(recognizedText: String) {
        var recognizedTextWordList = recognizedText.tokenize()
        let recognizedTextWordListLength = recognizedTextWordList.count
        if (0 < recognizedTextWordListLength && 0 == recognizedTextWordListLength % 6) {
            let range = recognizedTextWordList.endIndex.advanced(by: -5)..<recognizedTextWordList.endIndex
            let textChunk = recognizedTextWordList[range].joined(separator: " ")
            NSLog("textChunk is: \(textChunk)")
            self.translateTextChunkList.append(textChunk)
            self.textChunkSemaphore.signal()
        }
    }
}
