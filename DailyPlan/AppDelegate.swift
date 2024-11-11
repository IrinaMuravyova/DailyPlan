//
//  AppDelegate.swift
//  DailyPlan
//
//  Created by Irina Muravyeva on 30.10.2024.
//

import UIKit

@main
  class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?
    var delegate: completionHistoryDelegate?
    var completionHistoryDelegate: completionHistoryDelegate?

      func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
          
      window = UIWindow(frame: UIScreen.main.bounds)
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
          
      // Инициализируем UINavigationController из Storyboard
      if let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController {
          window?.rootViewController = navigationController
          window?.makeKeyAndVisible()
              
              // Доступ к MainViewController, если он установлен как rootViewController в UINavigationController
              if let mainVC = navigationController.viewControllers.first as? MainViewController {
                          
              // Устанавливаем делегаты для методов фильтрации
              StorageManager.shared.delegate = mainVC
              completionHistoryDelegate = StorageManager.shared
                        
              if isFirstOpenToday() {
                  print("Это первое открытие приложения за сегодня")
                      completionHistoryDelegate?.checkAndCancelYesterdayCompletionHistory()
                      completionHistoryDelegate?.createTodayCompletionHistory()
              } else {
                  print("Приложение уже открывалось сегодня")
              }
              } else {
                  print("Не удалось найти MainViewController")
              }
      }
          
      return true
  }
        

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
//MARK: - Check date methods
extension AppDelegate {
    func isFirstOpenToday() -> Bool {
        // Получаем текущую дату без времени
        let today = Calendar.current.startOfDay(for: Date())
        
        // Получаем дату последнего открытия из UserDefaults
//        let lastOpenDate = UserDefaults.standard.object(forKey: "lastOpenDate") as? Date
        let lastOpenDate = Date() - 1 // для отладки
        // Проверяем, была ли дата последнего открытия сегодня
        if lastOpenDate == today {
            return false // Сегодня уже открывали
        } else {
            // Сохраняем текущую дату как дату последнего открытия
            UserDefaults.standard.set(today, forKey: "lastOpenDate")
            return true // Это первое открытие за сегодня
        }
    }

}
