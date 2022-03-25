//
//  MoviesViewModel.swift
//  DevSwiftUI
//
//  Created by hima sai on 26/03/22.
//

import Foundation
import Combine
import FirebaseFirestore

class MoviesViewModel: ObservableObject {
  @Published var movies = [Movie]()
  
  private var db = Firestore.firestore()
  private var listenerRegistration: ListenerRegistration?
  
  deinit {
    unsubscribe()
  }
  
  func unsubscribe() {
    if listenerRegistration != nil {
      listenerRegistration?.remove()
      listenerRegistration = nil
    }
  }
  
  func subscribe() {
    if listenerRegistration == nil {
      listenerRegistration = db.collection("movielist").addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }
        
        self.movies = documents.compactMap { queryDocumentSnapshot in
          try? queryDocumentSnapshot.data(as: Movie.self)
        }
      }
    }
  }
  
  func removeMovies(atOffsets indexSet: IndexSet) {
    let movies = indexSet.lazy.map { self.movies[$0] }
    movies.forEach { movie in
      if let documentId = movie.id {
        db.collection("movielist").document(documentId).delete { error in
          if let error = error {
            print("Unable to remove document: \(error.localizedDescription)")
          }
        }
      }
    }
  }

  
}
