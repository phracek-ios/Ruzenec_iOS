//
//  PlayerlistPlayer.swift
//  RuzeneciOS
//
//  Created by Petr Hracek on 25.09.2026.
//  Copyright © 2026 Petr Hracek. All rights reserved.
//

import Foundation
import AVFoundation

class PlaylistPlayer: NSObject, AVAudioPlayerDelegate {
    var audioPlayer: AVAudioPlayer?
    var playlist: [URL] = []
    var currentIndex: Int = 0
    var onPlaybackFinished: (() -> Void)?
    var isPaused: Bool = false

    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }

    func setupPlaylist(fileNames: [String]) {
        stop()
        currentIndex = 0
        playlist = fileNames.compactMap { name in
            guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
                debugPrint("PlaylistPlayer: file not found: \(name).mp3")
                return nil
            }
            return url
        }
    }

    func play() {
        guard !playlist.isEmpty else { return }
        currentIndex = 0
        playCurrentItem()
    }

    func pause() {
        audioPlayer?.pause()
    }

    func resume() {
        audioPlayer?.play()
    }

    func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
        currentIndex = 0
    }

    func skipToNext() {
        currentIndex += 1
        if currentIndex < playlist.count {
            playCurrentItem()
        } else {
            stop()
            onPlaybackFinished?()
        }
    }

    private func playCurrentItem() {
        guard currentIndex < playlist.count else {
            onPlaybackFinished?()
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: playlist[currentIndex])
            audioPlayer?.delegate = self
            audioPlayer?.play()
        } catch {
            debugPrint("PlaylistPlayer: error playing \(playlist[currentIndex]): \(error)")
            skipToNext()
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        skipToNext()
    }
}
