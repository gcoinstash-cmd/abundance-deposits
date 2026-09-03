import Foundation

public struct DepositTransaction: Identifiable, Codable {
    public let id: UUID
    public let amount: Double
    public let platform: PaymentPlatform
    public let sender: String
    public let note: String?
    public let timestamp: Date
    public let formattedDateString: String

    public init(
        id: UUID = UUID(),
        amount: Double,
        platform: PaymentPlatform,
        sender: String,
        note: String? = nil,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.amount = amount
        self.platform = platform
        self.sender = sender
        self.note = note
        self.timestamp = timestamp

        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        self.formattedDateString = formatter.string(from: timestamp)
    }

    public var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "$\(String(format: "%.2f", amount))"
    }

    // Default sample data matching mockup
    public static var samples: [DepositTransaction] {
        [
            DepositTransaction(
                amount: 1450.00,
                platform: .stripe,
                sender: "Horizon Studios",
                note: "Brand Strategy Retainer",
                timestamp: Calendar.current.date(byAdding: .minute, value: -12, to: Date()) ?? Date()
            ),
            DepositTransaction(
                amount: 850.00,
                platform: .cashApp,
                sender: "marcus_v",
                note: "Creative Direction",
                timestamp: Calendar.current.date(byAdding: .minute, value: -45, to: Date()) ?? Date()
            ),
            DepositTransaction(
                amount: 5000.00,
                platform: .wireTransfer,
                sender: "Global Media Partner Inc.",
                note: "Q3 Licensing Distribution",
                timestamp: Calendar.current.date(byAdding: .hour, value: -2, to: Date()) ?? Date()
            ),
            DepositTransaction(
                amount: 2499.00,
                platform: .shopify,
                sender: "Aura Luxury Goods",
                note: "VIP Package Purchase",
                timestamp: Calendar.current.date(byAdding: .hour, value: -4, to: Date()) ?? Date()
            )
        ]
    }
}
