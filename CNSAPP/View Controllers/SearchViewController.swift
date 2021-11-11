//
//  UsersPageViewController.swift
//  CNSAPP
//
//  Created by Robert Colman Loch on 11/4/21.
//

import Foundation
import SwiftUI
import Firebase

struct SearchViewController: View {
    
    @ObservedObject var data = getUserData()
    @State var isOn = false
    var body: some View {
        NavigationView{
        ZStack(alignment: .top){
            GeometryReader{_ in
            Text("Home")}
        .background(Color("Color").edgesIgnoringSafeArea(.all))
        CustomSearchBar(data: self.$data.datas).padding(.top)
        
        }.navigationBarTitle("")
                .navigationBarHidden(true)
    
}
    }}

    struct UserPageView_Previews: PreviewProvider {
       static var previews: some View {
    SearchViewController()
       }}

    struct CustomSearchBar: View {
        @State var txt = ""
        @Binding var data : [dataType]
        
        
        var body : some View{
            
            VStack(spacing: 0){
                HStack{
                    TextField("Search", text: self.$txt)
                    
                    if self.txt != ""{
                        Button(action: {
                            self.txt = ""
                        }){
                            Text("Cancel")
                        }
                        .foregroundColor(.white)
                    }
                }.padding()
                
                if self.txt != ""{
                    
                    if  self.data.filter({$0.firstname.lowercased().contains(self.txt.lowercased())}).count == 0{
                        
                        Text("No Results Found").foregroundColor(Color.black.opacity(0.5)).padding()
                    }
                    else{
                        
                    List(self.data.filter{$0.firstname.lowercased().contains(self.txt.lowercased())}){i in
                                
                        NavigationLink(destination: Detail(data: i)) {
                            
                            Text(i.firstname)
                        }
                                
                            
                        }.frame(height: UIScreen.main.bounds.height / 5)
                    }

                }
                
                
            }.background(Color.white)
            .padding()
        }
    }



    class getUserData : ObservableObject{
        @Published var datas = [dataType]()
        
        init(){
            let db = Firestore.firestore()
            db.collection("users").getDocuments { (snap, err)in
                if err != nil{
                    print((err?.localizedDescription)!)
                    return
                }
                for i in snap!.documents{
                    let id = i.documentID
                    let firstname = i.get("firstname") as! String
                    let lastname = i.get("lastname") as! String
                    let email = i.get("email") as! String
                        
                    self.datas.append(dataType(id: id, firstname: firstname, lastname: lastname, email: email))
                }
            }
        }
    }
    struct dataType : Identifiable {
        var id : String
        var firstname : String
        var lastname : String
        var email : String
    }

    struct Detail: View {
        
        var data: dataType
        var body : some View{
            Text(data.firstname)
            Text(data.lastname)
            Text(data.email)
        }
    }

    


