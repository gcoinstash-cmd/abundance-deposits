import SwiftUI

public struct DashboardView: View {
    @ObservedObject var store = DepositStore.shared
    @ObservedObject var notificationManager = NotificationManager.shared
    @State private var showingSettings = false
    @State private var showingLockPreview = false

    public init() {}

    public var body: some View {
        NavigationView {
            ZStack {
                // Background dark radial / linear gradient
                LinearGradient(
                    colors: [
                        Color(red: 10/255, green: 14/255, blue: 23/255),
                        Color(red: 5/255, green: 7/255, blue: 12/255)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                // Ambient emerald/gold glow in the background
                Circle()
                    .fill(Color(red: 16/255, green: 185/255, blue: 129/255).opacity(0.12))
                    .frame(width: 320, height: 320)
                    .blur(radius: 80)
                    .offset(y: -180)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {

                        // Top Title & Manifested Revenue Header
                        VStack(spacing: 8) {
                            Text("Total manifested revenue for")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color(white: 0.7))

                            Text("+\(store.formattedTotalToday())")
                                .font(.system(size: 38, weight: .heavy, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 250/255, green: 204/255, blue: 21/255), // Warm Gold
                                            Color(red: 52/255, green: 211/255, blue: 153/255)  // Emerald
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: Color(red: 52/255, green: 211/255, blue: 153/255).opacity(0.4), radius: 15, x: 0, y: 5)

                            Text("Today")
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .foregroundColor(Color(red: 110/255, green: 231/255, blue: 183/255))
                        }
                        .padding(.top, 10)

                        // Trigger Instant Rain Button
                        Button(action: {
                            store.triggerInstantRainSession()
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: "bolt.fill")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color(red: 250/255, green: 204/255, blue: 21/255))

                                Text(store.isRainActive ? "⚡ Manifesting Abundance..." : "⚡ Trigger Instant Rain ($999 - $5k)")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color(red: 18/255, green: 24/255, blue: 38/255))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .stroke(
                                                LinearGradient(
                                                    colors: [
                                                        Color(red: 250/255, green: 204/255, blue: 21/255).opacity(0.8),
                                                        Color(red: 52/255, green: 211/255, blue: 153/255).opacity(0.8)
                                                    ],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                ),
                                                lineWidth: 1.5
                                            )
                                    )
                                    .shadow(color: Color(red: 52/255, green: 211/255, blue: 153/255).opacity(0.3), radius: 10, x: 0, y: 4)
                            )
                        }
                        .disabled(store.isRainActive)
                        .padding(.horizontal, 4)

                        // Manifestation Schedule Card
                        GlassCard {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("Manifestation Schedule")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(.white)

                                HStack {
                                    Text("Interval:")
                                        .foregroundColor(Color(white: 0.6))
                                    Spacer()
                                    Text("Every \(store.intervalMinutes) mins")
                                        .foregroundColor(.white)
                                        .fontWeight(.semibold)
                                }
                                .font(.system(size: 14))

                                Divider().background(Color.white.opacity(0.1))

                                HStack {
                                    Text("Active Hours:")
                                        .foregroundColor(Color(white: 0.6))
                                    Spacer()
                                    Text("8:00 AM – 10:00 PM")
                                        .foregroundColor(.white)
                                        .fontWeight(.semibold)
                                }
                                .font(.system(size: 14))
                            }
                        }

                        // Recent Abundance Flow (Live simulated feed)
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Recent Abundance Flow")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)

                                Spacer()

                                Button(action: {
                                    showingLockPreview = true
                                }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "lock.shield.fill")
                                        Text("Preview Lockscreen")
                                    }
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(Color(red: 99/255, green: 102/255, blue: 241/255))
                                }
                            }

                            ForEach(store.transactions) { tx in
                                TransactionRowView(transaction: tx)
                            }
                        }
                        .padding(.top, 6)

                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Abundance")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingLockPreview = true
                    }) {
                        Image(systemName: "lock.iphone")
                            .foregroundColor(.white)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.white)
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showingLockPreview) {
                LockScreenPreviewView()
            }
            .onAppear {
                notificationManager.requestAuthorization()
            }
        }
        .preferredColorScheme(.dark)
    }
}
