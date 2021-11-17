//
//  SearchViewController.swift
//  CNSAPP
//
//  Created by Robert Colman Loch on 11/11/21.
//

import SwiftUI
import UIKit
import Foundation

import Firebase

struct SearchViewController: View {
    @ObservedObject var data = getUserData()
    @State var isOn = false
    var body: some View {
        NavigationView{
        ZStack(alignment: .top){
            GeometryReader{_ in
            
            }
            
      //  .background(Color.white.edgesIgnoringSafeArea(.all))
        .foregroundColor(Color("Light Gray"))
        CustomSearchBar(data: self.$data.datas)
        
        }//.navigationBarTitle("")
        .navigationTitle("Lookup Parents/Staff").padding(.top)
        
        .navigationBarHidden(false)
    
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
               // Rectangle()
                   // .foregroundColor(Color("LightGray"))
                HStack{
                    Image(systemName: "magnifyingglass")
                    TextField("Tap here to Search", text: self.$txt)
                    
                    if self.txt != ""{
                        Button(action: {
                            self.txt = ""
                        }){
                            Text("Cancel")
                        }
                       // .foregroundColor(.black)
                    }
                }
                .background(Color("LightGray"))
                .cornerRadius(13)
                .padding()
                
                if self.txt != ""{
                    
                    if  self.data.filter({$0.firstname.lowercased().contains(self.txt.lowercased())}).count == 0{
                        
                        Text("No Results Found")
                    }
                    else{
                        
                    List(self.data.filter{$0.firstname.lowercased().contains(self.txt.lowercased())}){i in
                                
                        NavigationLink(destination: Detail(data: i)) {
                            
                            Text(i.firstname)
                        }
                                
                            
                    }.frame(height: 250)
                            .cornerRadius(13)
                    }

                }
                
                
            }
       //     .frame(height: 40)
            //.cornerRadius(13)
          //  .background(Color.white)
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
                    let phoneNumber = i.get("phoneNumber") as! String
                        
                    self.datas.append(dataType(id: id, firstname: firstname, lastname: lastname, email: email, phoneNumber: phoneNumber))
                }
            }
        }
    }
       struct dataType : Identifiable {
        var id : String
        var firstname : String
        var lastname : String
        var email : String
        var phoneNumber : String
    }

    struct Detail: View {
        
        var data: dataType
        var body : some View{
            Text(data.firstname)
            Text(data.lastname)
            Text(data.email)
            Text(data.phoneNumber)
        }
    }

