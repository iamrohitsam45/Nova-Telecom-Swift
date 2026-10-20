import SwiftUI

public struct SupportChatView: View {
    @State public var ticket: SupportTicket
    @State private var inputText: String = ""
    @State private var isSending: Bool = false

    public init(ticket: SupportTicket) {
        self.ticket = ticket
    }

    public var body: some View {
        ZStack {
            TelecomColors.backgroundGradient.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header Ticket Info Card
                VStack(spacing: 6) {
                    HStack {
                        Text(ticket.ticketNumber)
                            .font(TelecomTypography.badge)
                            .foregroundColor(TelecomColors.neonCyan)
                        Spacer()
                        StatusBadge(text: ticket.status.displayName.uppercased(), type: .pending)
                    }

                    HStack {
                        Text(ticket.title)
                            .font(TelecomTypography.titleSmall)
                            .foregroundColor(.white)
                        Spacer()
                    }

                    if let appt = ticket.scheduledAppointment {
                        HStack(spacing: 6) {
                            Image(systemName: "calendar.badge.clock")
                                .foregroundColor(TelecomColors.warningAmber)
                            Text("Technician Visit: \(appt.formatted(date: .abbreviated, time: .shortened))")
                                .font(TelecomTypography.captionSmall)
                                .foregroundColor(TelecomColors.warningAmber)
                            Spacer()
                        }
                        .padding(.top, 2)
                    }
                }
                .padding(14)
                .background(TelecomColors.cardBackground)

                // Messages Scroll
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(ticket.messages) { msg in
                                chatBubble(msg)
                            }
                        }
                        .padding(16)
                    }
                    .onChange(of: ticket.messages.count) { _ in
                        if let last = ticket.messages.last {
                            withAnimation {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                }

                // Chat Input Row
                HStack(spacing: 10) {
                    Button(action: {
                        HapticFeedback.light()
                        inputText = "Attached diagnostic trace: Optical RX -20.5dBm, Latency 4ms."
                    }) {
                        Image(systemName: "paperclip")
                            .font(.system(size: 18))
                            .foregroundColor(TelecomColors.neonCyan)
                    }

                    TextField("Type your message or query...", text: $inputText)
                        .padding(10)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .foregroundColor(.white)

                    Button(action: sendMessage) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(inputText.isEmpty ? TelecomColors.neutralMuted : TelecomColors.electricBlue)
                    }
                    .disabled(inputText.isEmpty || isSending)
                }
                .padding(12)
                .background(TelecomColors.cardBackground)
            }
        }
        .navigationTitle("Support Chat")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func chatBubble(_ msg: SupportMessage) -> some View {
        HStack {
            if msg.isFromUser { Spacer() }

            VStack(alignment: msg.isFromUser ? .trailing : .leading, spacing: 4) {
                Text(msg.sender)
                    .font(TelecomTypography.captionSmall)
                    .foregroundColor(TelecomColors.neutralMuted)

                Text(msg.message)
                    .font(TelecomTypography.bodyMedium)
                    .foregroundColor(.white)
                    .padding(12)
                    .background(
                        msg.isFromUser
                        ? TelecomColors.heroGradient
                        : LinearGradient(colors: [Color.white.opacity(0.12), Color.white.opacity(0.06)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                Text(msg.timestamp.formatted(date: .omitted, time: .shortened))
                    .font(TelecomTypography.captionSmall)
                    .foregroundColor(TelecomColors.neutralMuted)
            }
            .frame(maxWidth: 280, alignment: msg.isFromUser ? .trailing : .leading)

            if !msg.isFromUser { Spacer() }
        }
        .id(msg.id)
    }

    private func sendMessage() {
        guard !inputText.isEmpty else { return }
        HapticFeedback.light()
        let text = inputText
        inputText = ""

        let newMsg = SupportMessage(
            sender: "You",
            isFromUser: true,
            message: text,
            timestamp: Date()
        )
        ticket.messages.append(newMsg)

        // Simulated AI Assistant reply
        Task {
            try? await Task.sleep(nanoseconds: 1_200_000_000)
            let aiReply = SupportMessage(
                sender: "Nova AI Agent",
                isFromUser: false,
                message: "Telemetry reviewed. We have forwarded your trace details to the network operations desk. An engineer is monitoring the line.",
                timestamp: Date()
            )
            ticket.messages.append(aiReply)
            HapticFeedback.light()
        }
    }
}
