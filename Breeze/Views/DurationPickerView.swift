//
//  DurationPickerView.swift
//  Breeze
//
//  Created by Katherine Taylor on 1/19/22.
// from: https://stackoverflow.com/questions/58574463/how-can-i-set-countdowntimer-mode-in-datepicker-on-swiftui
//

import SwiftUI
import UIKit

struct DurationPickerView: UIViewRepresentable {
    @Binding var time: Time
    @Binding var changeTriggered: Bool;

    func makeCoordinator() -> DurationPickerView.Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .countDownTimer
        datePicker.addTarget(context.coordinator, action: #selector(Coordinator.onDateChanged), for: .valueChanged)
        return datePicker
    }

    func updateUIView(_ datePicker: UIDatePicker, context: Context) {
        let date = Calendar.current.date(bySettingHour: time.hours, minute: time.minutes, second: time.seconds, of: datePicker.date)!
        datePicker.setDate(date, animated: true)
    }

    class Coordinator: NSObject {
        var durationPicker: DurationPickerView

        init(_ durationPicker: DurationPickerView) {
            self.durationPicker = durationPicker
        }

        @objc func onDateChanged(sender: UIDatePicker) {
            
            durationPicker.changeTriggered = true;
            let calendar = Calendar.current
            let date = sender.date
            durationPicker.time = Time(hours: calendar.component(.hour, from: date), minutes: calendar.component(.minute, from: date), seconds: calendar.component(.second, from: date))
        }
    }
}
