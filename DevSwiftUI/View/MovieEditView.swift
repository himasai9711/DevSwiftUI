//
//  MovieEditView.swift
//  DevSwiftUI
//
//  Created by hima sai on 26/03/22.
//


import SwiftUI

enum Mode {
  case new
  case edit
}

enum Action {
  case delete
  case done
  case cancel
}

struct MovieEditView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State var presentActionSheet = false
    
    @ObservedObject var viewModel = MovieViewModel()
    var mode: Mode = .new
    var completionHandler: ((Result<Action, Error>) -> Void)?
    
    
    var cancelButton: some View {
      Button(action: { self.handleCancelTapped() }) {
        Text("Cancel")
      }
    }
    
    var saveButton: some View {
      Button(action: { self.handleDoneTapped() }) {
        Text(mode == .new ? "Done" : "Save")
      }
      .disabled(!viewModel.modified)
    }
    
    var body: some View {
      NavigationView {
        Form {
          Section(header: Text("Movie")) {
            TextField("Title", text: $viewModel.movie.title)
            TextField("Year", text: $viewModel.movie.year)
          }
          
          Section(header: Text("Description")) {
            TextField("Description", text: $viewModel.movie.description)
          }
          
          if mode == .edit {
            Section {
              Button("Delete Movie") { self.presentActionSheet.toggle() }
                .foregroundColor(.red)
            }
          }
        }
        .navigationTitle(mode == .new ? "New Movie" : viewModel.movie.title)
        .navigationBarTitleDisplayMode(mode == .new ? .inline : .large)
        .navigationBarItems(
          leading: cancelButton,
          trailing: saveButton
        )
        .actionSheet(isPresented: $presentActionSheet) {
          ActionSheet(title: Text("Are you sure?"),
                      buttons: [
                        .destructive(Text("Delete Movie"),
                                     action: { self.handleDeleteTapped() }),
                        .cancel()
                      ])
        }
      }
    }
    
    // Action Handlers
    
    func handleCancelTapped() {
      self.dismiss()
    }
    
    func handleDoneTapped() {
      self.viewModel.handleDoneTapped()
      self.dismiss()
    }
    
    func handleDeleteTapped() {
      viewModel.handleDeleteTapped()
      self.dismiss()
      self.completionHandler?(.success(.delete))
    }
    
    func dismiss() {
      self.presentationMode.wrappedValue.dismiss()
    }
  }

//struct MovieEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieEditView()
//    }
//}

struct MovieEditView_Previews: PreviewProvider {
  static var previews: some View {
    let movie = Movie(title: "Sample title", description: "Sample Description", year: "2020")
    let movieViewModel = MovieViewModel(movie: movie)
    return MovieEditView(viewModel: movieViewModel, mode: .edit)
  }
}
