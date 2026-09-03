import SwiftUI
import AudioToolbox
import AVFoundation

public final class HapticSoundManager {
    public static let shared = HapticSoundManager()

    private init() {}

    // MARK: - Haptics
    public func triggerDepositHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            let impact = UIImpactFeedbackGenerator(style: .heavy)
            impact.prepare()
            impact.impactOccurred()
        }
    }

    public func triggerLightTap() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }

    public func triggerMediumTap() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }

    // MARK: - Audio Feedback
    public func playCashSound() {
        // System Sound IDs:
        // 1000: New mail / subtle ping
        // 1057: Payment / lock click
        // 1016: Tweet / chirp
        // 1025: Calypso
        AudioServicesPlaySystemSound(1057)
    }
}
