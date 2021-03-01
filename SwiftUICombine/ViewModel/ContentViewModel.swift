//
//  ContentViewModel.swift
//  SwiftUICombine
//
//  Created by David U. Okonkwo on 3/1/21.
//

import SwiftUI
import Combine

class ContentViewModel: ObservableObject {
    let passThroughSubject = PassthroughSubject<String, Error>()
    let passThroughModelSubject = PassthroughSubject<TimeModel, Error>()
    @Published var time: String = "0 Seconds"
    @Published var seconds: String = "0"
    @Published var timeModel = TimeModel(seconds: 0)
    private var cancelable: Set<AnyCancellable> = []
    init() {
       passThroughSubject
        .dropFirst()
        .filter({ (value) -> Bool in
            value != "5"
        })
        .map{ value in
            return value + " Seconds"
        }
        
        .sink { (completion) in
        switch completion {
        
        case .finished:
            self.time = "finished"
        case .failure(let err):
            print(err.localizedDescription)
        }
        } receiveValue: { (value) in
            self.time = value
        }.store(in: &cancelable)
        
        passThroughModelSubject.sink { (completion) in
            print(completion)
        } receiveValue: { (timeModel) in
            self.timeModel = timeModel
            print(timeModel)
        }.store(in: &cancelable)


    }
    
    func startFetch() {
        Service.fetch { (result) in
            switch result {
            case .success( let value):
                if value == "10" {
                    self.passThroughSubject.send(completion: .finished)
                } else {
                    self.passThroughSubject.send(value)
                }
                self.seconds = value
            case .failure( let err):
                self.time = err.localizedDescription
                self.passThroughSubject.send(completion: .failure(err))
                self.seconds = err.localizedDescription
            }
        }
        
        Service.fetchModel { (result) in
            switch result {
            
            case .success( let timeModel):
                self.passThroughModelSubject.send(timeModel)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
