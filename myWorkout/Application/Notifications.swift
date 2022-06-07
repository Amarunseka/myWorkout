//
//  Notifications.swift
//  myWorkout
//
//  Created by Миша on 24.05.2022.
//

import UIKit
import UserNotifications

final class Notifications: NSObject {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    // запрашиваем разрешение на отправку нотификаций
    func requestAutorisation(){
        // alert - это чтобы появлялось уведомление
        // sound -  что бы со звуком
        // badge - что бы был кружок сверху с права что есть пропущенная нотификация
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else {return}
            self.getNotificationSettings()
        }
    }
    
    // просто метод просмотра настроек
    private func getNotificationSettings(){
        notificationCenter.getNotificationSettings { settings in
//            print(settings)
        }
    }
    
    
    func scheduleDateNotification(date: Date, id: String) {
        
        // создаем внешний вид нотификации
        // выбираем mutable что бы был изменяемым
        let content = UNMutableNotificationContent()
        content.title = "myWorkout"
        content.body = "Do you remember, you have a workout today."
        content.sound = .default // можно установить собственные звуки
        content.badge = 1
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC") ?? .current

        // создаем триггер когда нотификация должна сработать
        // это настройки тригера
        // мы берем дату из дня создания тренировки
        var triggerDate = calendar.dateComponents([.year, .month, .day], from: date)
        // а время подставляем сами
        triggerDate.hour = 12
        triggerDate.minute = 00
        // и в ту дату в 12:00 сработает нотификация
        
        // теперь добавляем триггер
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        // создаем реквест на нотификацию
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        // и добавляем в notificationCenter
        notificationCenter.add(request) { error in
            if error != nil {
                print(error?.localizedDescription ?? "Error is occurred")
            }
        }
    }
}

extension Notifications: UNUserNotificationCenterDelegate {
    
    // метод который показывает нотификацию
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    
    // метод который срабатывает когда мы кликаем на нотификацию
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // уменьшаем количество бейджей
        UIApplication.shared.applicationIconBadgeNumber = 0 // можно уменьшать типа:  - 1
        
        // удаляем все доставленные уведомления
        notificationCenter.removeAllDeliveredNotifications()
        
    }
}


