import SwiftUI

public struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var store = DepositStore.shared

    let soundOptions = ["Shopify Cha-Ching", "Cash App Ding", "Stripe Chime"]
    let amountPresets = [499.00, 999.00, 2500.00]

    public var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {

                        // Platform Theme Section
                        GlassCard {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Select Platform Theme")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(.white)

                                Toggle(isOn: $store.enabledStripe) {
                                    HStack(spacing: 12) {
                                        Image(systemName: PaymentPlatform.stripe.iconSymbol)
                                            .foregroundColor(PaymentPlatform.stripe.brandColor)
                                            .font(.system(size: 20))
                                        Text(PaymentPlatform.stripe.displayName)
                                            .foregroundColor(.white)
                                    }
                                }
                                .tint(PaymentPlatform.stripe.brandColor)

                                Toggle(isOn: $store.enabledCashApp) {
                                    HStack(spacing: 12) {
                                        Image(systemName: PaymentPlatform.cashApp.iconSymbol)
                                            .foregroundColor(PaymentPlatform.cashApp.brandColor)
                                            .font(.system(size: 20))
                                        Text(PaymentPlatform.cashApp.displayName)
                                            .foregroundColor(.white)
                                    }
                                }
                                .tint(PaymentPlatform.cashApp.brandColor)

                                Toggle(isOn: $store.enabledShopify) {
                                    HStack(spacing: 12) {
                                        Image(systemName: PaymentPlatform.shopify.iconSymbol)
                                            .foregroundColor(PaymentPlatform.shopify.brandColor)
                                            .font(.system(size: 20))
                                        Text(PaymentPlatform.shopify.displayName)
                                            .foregroundColor(.white)
                                    }
                                }
                                .tint(PaymentPlatform.shopify.brandColor)

                                Toggle(isOn: $store.enabledPayPal) {
                                    HStack(spacing: 12) {
                                        Image(systemName: PaymentPlatform.payPal.iconSymbol)
                                            .foregroundColor(PaymentPlatform.payPal.brandColor)
                                            .font(.system(size: 20))
                                        Text(PaymentPlatform.payPal.displayName)
                                            .foregroundColor(.white)
                                    }
                                }
                                .tint(PaymentPlatform.payPal.brandColor)
                            }
                        }

                        // Deposit Amounts Section
                        GlassCard {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("Deposit Amounts")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(.white)

                                Text("$\(Int(store.selectedAmountPreset))")
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 4)

                                Slider(
                                    value: $store.selectedAmountPreset,
                                    in: 100...10000,
                                    step: 50
                                )
                                .tint(Color(red: 59/255, green: 130/255, blue: 246/255))

                                HStack {
                                    Text("$100")
                                        .font(.caption)
                                        .foregroundColor(Color(white: 0.5))
                                    Spacer()
                                    Text("$10,000")
                                        .font(.caption)
                                        .foregroundColor(Color(white: 0.5))
                                }

                                // Quick preset chips
                                HStack(spacing: 12) {
                                    ForEach(amountPresets, id: \.self) { preset in
                                        Button(action: {
                                            store.selectedAmountPreset = preset
                                            HapticSoundManager.shared.triggerLightTap()
                                        }) {
                                            Text("$\(Int(preset))")
                                                .font(.system(size: 15, weight: .semibold))
                                                .foregroundColor(store.selectedAmountPreset == preset ? .black : .white)
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 10)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .fill(store.selectedAmountPreset == preset ? Color.white : Color(white: 0.2))
                                                )
                                        }
                                    }
                                }
                                .padding(.top, 6)
                            }
                        }

                        // Notification Sound Section
                        GlassCard {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("Notification Sound")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(.white)

                                ForEach(0..<soundOptions.count, id: \.self) { index in
                                    HStack {
                                        Text(soundOptions[index])
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))

                                        Spacer()

                                        if store.selectedSoundIndex == index {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(Color(red: 59/255, green: 130/255, blue: 246/255))
                                        }
                                    }
                                    .contentShape(Rectangle())
                                    .padding(.vertical, 6)
                                    .onTapGesture {
                                        store.selectedSoundIndex = index
                                        HapticSoundManager.shared.playCashSound()
                                    }
                                }
                            }
                        }

                        // Frequency & Schedule Section
                        GlassCard {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("Frequency & Schedule")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(.white)

                                HStack {
                                    Text("Interval:")
                                        .foregroundColor(Color(white: 0.6))
                                    Spacer()
                                    Stepper("\(store.intervalMinutes) minutes", value: $store.intervalMinutes, in: 5...180, step: 5)
                                        .foregroundColor(.white)
                                }
                                .font(.system(size: 14))

                                Divider().background(Color.white.opacity(0.1))

                                HStack {
                                    Text("Start Time")
                                        .foregroundColor(Color(white: 0.6))
                                    Spacer()
                                    Text("8:00 AM")
                                        .foregroundColor(.white)
                                }
                                .font(.system(size: 14))

                                HStack {
                                    Text("End Time")
                                        .foregroundColor(Color(white: 0.6))
                                    Spacer()
                                    Text("10:00 PM")
                                        .foregroundColor(.white)
                                }
                                .font(.system(size: 14))
                            }
                        }

                    }
                    .padding(20)
                }
            }
            .navigationTitle("Abundance Deposits")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
