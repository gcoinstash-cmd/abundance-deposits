import SwiftUI

public struct TransactionRowView: View {
    public let transaction: DepositTransaction

    public var body: some View {
        HStack(spacing: 14) {
            // App / Platform Icon
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(transaction.platform.brandColor)
                    .frame(width: 44, height: 44)

                Image(systemName: transaction.platform.iconSymbol)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            .shadow(color: transaction.platform.brandColor.opacity(0.35), radius: 6, x: 0, y: 3)

            // Platform and details
            VStack(alignment: .leading, spacing: 3) {
                Text(transaction.platform.displayName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)

                Text(transaction.sender)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(Color(white: 0.65))
                    .lineLimit(1)
            }

            Spacer()

            // Amount and time
            VStack(alignment: .trailing, spacing: 3) {
                Text("+\(transaction.formattedAmount)")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 52/255, green: 211/255, blue: 153/255)) // Emerald green

                Text(transaction.formattedDateString)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color(white: 0.5))
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(red: 26/255, green: 32/255, blue: 44/255).opacity(0.7))
        )
    }
}
