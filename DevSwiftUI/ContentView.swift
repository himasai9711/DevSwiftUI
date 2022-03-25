import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = MoviesViewModel() //MovieViewModel.swift
    @State var presentAddMovieSheet = false
    
    
    private var addButton: some View {
      Button(action: { self.presentAddMovieSheet.toggle() }) {
        Image(systemName: "plus")
      }
    }
    
    private func movieRowView(movie: Movie) -> some View {
       NavigationLink(destination: MovieDetailsView(movie: movie)) { //MovieDetailsView.swift
         VStack(alignment: .leading) {
           Text(movie.title)
             .font(.headline)
           //Text(movie.description)
           //  .font(.subheadline)
            Text(movie.year)
             .font(.subheadline)
         }
       }
    }
    
    var body: some View {
      NavigationView {
        List {
          ForEach (viewModel.movies) { movie in
            movieRowView(movie: movie)
          }
          .onDelete() { indexSet in
            //viewModel.removeMovies(atOffsets: indexSet)
            viewModel.removeMovies(atOffsets: indexSet)
          }
        }
        .navigationBarTitle("Movie")
        .navigationBarItems(trailing: addButton)
        .onAppear() {
          print("MoviesListView appears. Subscribing to data updates.")
          self.viewModel.subscribe()
        }
        .sheet(isPresented: self.$presentAddMovieSheet) {
          MovieEditView() //MovieEditView.swift
        }
        
      }// End Navigation
    }// End Body
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
