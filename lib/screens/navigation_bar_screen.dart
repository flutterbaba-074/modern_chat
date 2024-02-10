import 'package:chat_app/screens/chat_list_screen.dart';
import 'package:chat_app/screens/home_screen.dart';

import 'package:chat_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class NavigationBarScreen extends StatefulWidget {
  const NavigationBarScreen({super.key});

  @override
  State<NavigationBarScreen> createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen> {
  int selectedIndex=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: getBody(),
      bottomNavigationBar: customBottomNavigationBar(),
    );
  }
   
Widget customBottomNavigationBar(){
      var primaryColor = Theme.of(context).colorScheme.onPrimary;
       return Padding(
         padding: const EdgeInsets.fromLTRB(8,0,8,8),
         child: Card(
          color: Theme.of(context).colorScheme.primary,
           elevation: 15,
           shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
           ),
          child: Padding(
         
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                 GestureDetector(
                  onTap: (){
                    changeSelectedIndex(0);
                  },
                   child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      
                      color: selectedIndex==0? primaryColor.withOpacity(0.2):Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.home,
                        color: Theme.of(context).colorScheme.onPrimary,),
                        const SizedBox(width: 5,),
                     selectedIndex == 0?
                        Text("Home",
                        
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: selectedIndex==0?FontWeight.bold:FontWeight.w400
                        ),): const SizedBox()
                      ],
                    ),
                   ),
                 ),   
                 GestureDetector(
                  onTap: (){
                    changeSelectedIndex(1);
                  },
                   child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: selectedIndex==1? primaryColor.withOpacity(0.2):Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.message,
                        color: Theme.of(context).colorScheme.onPrimary,),
                        const SizedBox(width: 5,),
                               selectedIndex == 1?
                        Text("Messages",
                        
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: selectedIndex==0?FontWeight.bold:FontWeight.w400
                        ),): const SizedBox()
                      ],
                    ),
                   ),
                 ),   
                 GestureDetector(
                  onTap: (){
                    changeSelectedIndex(2);
                  },
                   child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: selectedIndex==2? primaryColor.withOpacity(0.2):Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.person,
                        color: Theme.of(context).colorScheme.onPrimary,),
                        const SizedBox(width: 5,),
                               
                        selectedIndex == 2?
                        Text("Profile",
                        
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: selectedIndex==0?FontWeight.bold:FontWeight.w400
                        ),): const SizedBox()
                      ],
                    ),
                   ),
                 ),   
                  
              ],
            ),
          ),
         ),
       );
}
void changeSelectedIndex(int index){

setState(() {
  selectedIndex = index;
});
}
 
  Widget getBody(){
   if(selectedIndex==0){
    return const HomeScreen();
   }
   else if(selectedIndex==1){
     return const ChatListScreen();
   }
   else{
    return const ProfileScreen();
   }
  }
}