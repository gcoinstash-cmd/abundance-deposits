import SwiftUI

public struct LockScreenNotificationCard: View {
    public let transaction: DepositTransaction

    public var body: some View {
        let details = transaction.platform.generateNotification(
            amount: transaction.amount,
            sender: transaction.sender,
            note: transaction.note
        )

        HStack(alignment: .top, spacing: 12) {
            // App Icon
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(transaction.platform.brandColor)
                    .frame(width: 38, height: 38)

                Image(systemName: transaction.platform.iconSymbol)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(details.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)

                    Spacer()

                    Text("2m ago")
                        .font(.system(size: 12))
                        .foregroundColor(Color(white: 0.7))
                }

                Text(details.body)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(Color(white: 0.9))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(white: 0.15).opacity(0.85))
                .background(
                    .ultraThinMaterial,
                    in: RoundedRectangle(cornerRadius: 22, style: .continuous)
                )
        )
        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

public struct LockScreenPreviewView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var store = DepositStore.shared

    public var body: some View {
        ZStack {
            // Realistic wallpaper gradient
            LinearGradient(
                colors: [
                    Color(red: 30/255, green: 42/255, blue: 56/255),
                    Color(red: 15/255, green: 20/255, blue: 28/255)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                // Top status and clock
                VStack(spacing: 6) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(.top, 20)

                    Text("11:11")
                        .font(.system(size: 80, weight: .ultraLight, design: .rounded))
                        .foregroundColor(.white)

                    Text("Monday, May 18")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color(white: 0.85))
                }
                .padding(.top, 10)

                Spacer().frame(height: 10)

                // Stacked notifications matching reference
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        ForEach(store.transactions.prefix(4)) { tx in
                            LockScreenNotificationCard(transaction: tx)
                        }
                    }
                    .padding(.horizontal, 16)
                }

                Spacer()

                // Quick Action Bar
                HStack {
                    Button(action: {
                        store.triggerInstantRainSession()
                    }) {
                        HStack {
                            Image(systemName: "bolt.fill")
                            Text("Simulate Live Notification")
                        }
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        .background(
                            Capsule().fill(Color.white.opacity(0.2))
                        )
                    }

                    Spacer()

                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Close")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 20)
                            .background(
                                Capsule().fill(Color.white.opacity(0.2))
                            )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
            }
        }
    }
}
