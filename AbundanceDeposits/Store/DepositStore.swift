import SwiftUI
import Combine

public final class DepositStore: ObservableObject {
    public static let shared = DepositStore()

    // MARK: - Published State
    @Published public var transactions: [DepositTransaction] = []
    @Published public var totalToday: Double = 14290.00
    @Published public var isRainActive: Bool = false

    // Settings
    @AppStorage("enabledStripe") public var enabledStripe: Bool = true
    @AppStorage("enabledCashApp") public var enabledCashApp: Bool = true
    @AppStorage("enabledShopify") public var enabledShopify: Bool = true
    @AppStorage("enabledPayPal") public var enabledPayPal: Bool = true
    @AppStorage("enabledWire") public var enabledWire: Bool = true

    @AppStorage("selectedAmountPreset") public var selectedAmountPreset: Double = 999.00
    @AppStorage("minAmount") public var minAmount: Double = 100.00
    @AppStorage("maxAmount") public var maxAmount: Double = 5000.00
    @AppStorage("intervalMinutes") public var intervalMinutes: Int = 45
    @AppStorage("selectedSoundIndex") public var selectedSoundIndex: Int = 0 // 0: Shopify Cha-Ching, 1: Cash App Ding, 2: Stripe Chime

    private let sendersList = [
        "Horizon Studios", "Aura Luxury Goods", "Creative Apex", "Starlight Media",
        "Elysian Ventures", "marcus_v", "sarah_j", "charlie_k", "Quantum Design",
        "Evergreen Holdings", "Vanguard Direct", "Lumina Labs"
    ]

    private let notesList = [
        "Brand Strategy Retainer", "Creative Direction", "VIP Package Purchase",
        "Q3 Licensing Distribution", "Full-stack Engineering", "Ad Campaign Revenue",
        "Consulting Services", "Merchandise Drop", "Design Sprint"
    ]

    private init() {
        self.transactions = DepositTransaction.samples
    }

    public var enabledPlatforms: [PaymentPlatform] {
        var list: [PaymentPlatform] = []
        if enabledStripe { list.append(.stripe) }
        if enabledCashApp { list.append(.cashApp) }
        if enabledShopify { list.append(.shopify) }
        if enabledPayPal { list.append(.payPal) }
        if enabledWire { list.append(.wireTransfer) }
        return list.isEmpty ? [.stripe] : list
    }

    public func formattedTotalToday() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSNumber(value: totalToday)) ?? "$\(String(format: "%.2f", totalToday))"
    }

    public func generateRandomDeposit(amountOverride: Double? = nil) -> DepositTransaction {
        let platform = enabledPlatforms.randomElement() ?? .stripe
        let sender = sendersList.randomElement() ?? "Client Deposit"
        let note = notesList.randomElement()

        let amount: Double
        if let override = amountOverride {
            amount = override
        } else {
            let presets = [499.00, 850.00, 999.00, 1450.00, 2499.00, 5000.00]
            amount = presets.randomElement() ?? selectedAmountPreset
        }

        return DepositTransaction(
            amount: amount,
            platform: platform,
            sender: sender,
            note: note,
            timestamp: Date()
        )
    }

    public func addTransaction(_ tx: DepositTransaction) {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            transactions.insert(tx, at: 0)
            totalToday += tx.amount
        }
    }

    public func triggerInstantRainSession() {
        isRainActive = true
        HapticSoundManager.shared.triggerDepositHaptic()

        var rainTransactions: [DepositTransaction] = []
        let burstAmounts = [999.00, 1450.00, 2499.00, 5000.00]

        for i in 0..<burstAmounts.count {
            let tx = generateRandomDeposit(amountOverride: burstAmounts[i])
            rainTransactions.append(tx)

            // Add to UI state with staggered animation
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i + 1) * 2.5) {
                self.addTransaction(tx)
                HapticSoundManager.shared.triggerDepositHaptic()
                HapticSoundManager.shared.playCashSound()

                if i == burstAmounts.count - 1 {
                    self.isRainActive = false
                }
            }
        }

        // Schedule actual iOS system push notifications
        NotificationManager.shared.triggerInstantRain(transactions: rainTransactions)
    }
}
