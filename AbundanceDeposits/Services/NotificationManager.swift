import Foundation
import UserNotifications

public final class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    public static let shared = NotificationManager()

    @Published public var isAuthorized: Bool = false

    override private init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        checkAuthorization()
    }

    public func requestAuthorization(completion: @escaping (Bool) -> Void = { _ in }) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                self.isAuthorized = granted
                completion(granted)
            }
        }
    }

    public func checkAuthorization() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isAuthorized = (settings.authorizationStatus == .authorized)
            }
        }
    }

    /// Schedule an instant or staggered deposit notification
    public func scheduleDepositNotification(
        transaction: DepositTransaction,
        delaySeconds: TimeInterval = 1
    ) {
        let content = UNMutableNotificationContent()
        let details = transaction.platform.generateNotification(
            amount: transaction.amount,
            sender: transaction.sender,
            note: transaction.note
        )

        content.title = details.title
        content.body = details.body
        content.sound = .default
        content.badge = 1
        content.userInfo = [
            "transactionId": transaction.id.uuidString,
            "platform": transaction.platform.rawValue,
            "amount": transaction.amount
        ]

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(delaySeconds, 1.0), repeats: false)
        let request = UNNotificationRequest(
            identifier: "deposit-\(transaction.id.uuidString)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }

    /// Trigger Instant Rain (rapid burst of 3-5 realistic deposit notifications)
    public func triggerInstantRain(transactions: [DepositTransaction]) {
        for (index, transaction) in transactions.enumerated() {
            let delay = TimeInterval((index + 1) * 3) // 3s, 6s, 9s, 12s, 15s
            scheduleDepositNotification(transaction: transaction, delaySeconds: delay)
        }
    }

    // Deliver notification even when app is in foreground
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        HapticSoundManager.shared.triggerDepositHaptic()
        HapticSoundManager.shared.playCashSound()
        completionHandler([.banner, .sound, .badge, .list])
    }
}
