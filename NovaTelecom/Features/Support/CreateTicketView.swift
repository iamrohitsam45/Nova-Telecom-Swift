import SwiftUI

public struct CreateTicketView: View {
    @Environment(\.dismiss) private var dismiss
    public let defaultCategory: String
    public let initialDiagnosisNote: String?

    @State private var title: String = ""
    @State private var category: String = "Broadband Outage"
    @State private var priority: TicketPriority = .medium
    @State private var descriptionText: String = ""
    @State private var scheduleTechnician: Bool = false
    @State private var appointmentDate: Date = Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date()
    @State private var isSubmitting: Bool = false

    private let categories = ["Broadband Outage", "Slow Speed", "Wi-Fi Coverage", "Hardware & Router", "Billing & Invoices", "SIM & eSIM"]

    public init(defaultCategory: String = "Broadband Outage", initialDiagnosisNote: String? = nil) {
        self.defaultCategory = defaultCategory
        self.initialDiagnosisNote = initialDiagnosisNote
        self._category = State(initialValue: defaultCategory)
        if let note = initialDiagnosisNote {
            self._descriptionText = State(initialValue: note)
        }
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                TelecomColors.backgroundGradient.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        Text("Create Support Ticket")
                            .font(TelecomTypography.titleLarge)
                            .foregroundColor(.white)

                        GlassCard(cornerRadius: 20, padding: 16) {
                            VStack(alignment: .leading, spacing: 14) {
                                // Category Picker
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("ISSUE CATEGORY")
                                        .font(TelecomTypography.badge)
                                        .foregroundColor(TelecomColors.neutralMuted)
                                    Picker("Category", selection: $category) {
                                        ForEach(categories, id: \.self) { cat in
                                            Text(cat).tag(cat)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .tint(TelecomColors.neonCyan)
                                }

                                // Priority
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("PRIORITY LEVEL")
                                        .font(TelecomTypography.badge)
                                        .foregroundColor(TelecomColors.neutralMuted)
                                    Picker("Priority", selection: $priority) {
                                        Text("Low").tag(TicketPriority.low)
                                        Text("Medium").tag(TicketPriority.medium)
                                        Text("High").tag(TicketPriority.high)
                                        Text("Urgent").tag(TicketPriority.urgent)
                                    }
                                    .pickerStyle(.segmented)
                                }

                                // Title
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("ISSUE SUMMARY")
                                        .font(TelecomTypography.badge)
                                        .foregroundColor(TelecomColors.neutralMuted)
                                    TextField("e.g. SFP optical power dropping during peak hours", text: $title)
                                        .padding(10)
                                        .background(Color.white.opacity(0.08))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .foregroundColor(.white)
                                }

                                // Description
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("DETAILED DESCRIPTION")
                                        .font(TelecomTypography.badge)
                                        .foregroundColor(TelecomColors.neutralMuted)
                                    TextEditor(text: $descriptionText)
                                        .frame(height: 100)
                                        .padding(6)
                                        .background(Color.white.opacity(0.08))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .foregroundColor(.white)
                                        .scrollContentBackground(.hidden)
                                }

                                // Toggle Technician Appointment
                                Toggle(isOn: $scheduleTechnician) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Schedule Field Technician Visit")
                                            .font(TelecomTypography.bodyBold)
                                            .foregroundColor(.white)
                                        Text("On-site fiber line and optical gateway inspection")
                                            .font(TelecomTypography.captionSmall)
                                            .foregroundColor(TelecomColors.neutralMuted)
                                    }
                                }
                                .tint(TelecomColors.neonCyan)

                                if scheduleTechnician {
                                    DatePicker("Preferred Date & Time", selection: $appointmentDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                                        .foregroundColor(.white)
                                        .tint(TelecomColors.neonCyan)
                                }
                            }
                        }

                        TelecomButton(
                            title: "Submit Support Ticket",
                            icon: "paperplane.fill",
                            style: .primary,
                            isLoading: isSubmitting,
                            action: submitTicket
                        )
                    }
                    .padding(16)
                }
            }
            .navigationTitle("New Ticket")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(TelecomColors.neonCyan)
                }
            }
        }
    }

    private func submitTicket() {
        guard !title.isEmpty else { return }
        isSubmitting = true
        HapticFeedback.light()

        Task {
            try? await Task.sleep(nanoseconds: 700_000_000)
            let _ = DemoDataStore.shared.addSupportTicket(
                title: title,
                category: category,
                message: descriptionText,
                priority: priority
            )
            isSubmitting = false
            HapticFeedback.success()
            dismiss()
        }
    }
}
