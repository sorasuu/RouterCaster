 **RMIT University Vietnam**
 
 **Course:** COSC2659 iOS Development
 
 **Semester:** 2019A
 
 **Assessment:** Assignment 3
 
 **Created date:** 16/05/2019
 
 **Author:** 
   -  Tang Quang An (s3695273)
   -  Nguyen Tuan Loc (s3695769)
   -  Nguyen Dinh Anh Khoi (s3695517)
   -  Le Minh Kien (s3651471)
   -  Le Nghia (s3654028)
   
<br/>
<br/>

 **TABLE OF CONTENTS**
 1. Introduction [Go to section](#introduction)
 2. Installation and Setup [Go to section](#installation-and-setup)
 3. Features [Go to section](#features)
 4. Diagram [Go to section](#diagram)
 5. Acknowledgment [Go to section](#acknowledgement)
 
<br/>
<br/>

# Introduction
  This is a project from group 6 of IOS development course (COSC2659) in semester A2019. It is called Routecaster app, a combination 
  between social and map navigation app which allows users to have their location and route shared to their friends as well as having chat
  feature for conversations. The features will be specifically explained in terms of flow (not fully front-end or back-end explanation) in
  features section below.
  
# Installation and Setup

 Require: 
 - Xcode version 10.2.1
 - Swift 5
 
 Installation: You just need to download our zip file, open it in xcode and run it. There is no pod installation required.
 
# Features
 ###  Download the application
 
   The user will not be able to download and install the app in his/her device. Since the download and installation requires us to 
   follow the terms and rules of Apple and also, the stakeholders does not recommended us to upload to Appstore due to mentioned 
   reasons, we decided not to do the Appstore upload.

 ###  Sign up/Log in
 
   Yes, the user can sign up by Facebook, Gmail and even in-app register, log in with the registred account (use email and password 
   to log in). This features are hugely supported by Firebase.

 ###  Reset password 
   
   There are 2 places user can reset thier password. One is in Setting section, user can change their password amnually and one is in log in page for when user can not remember their password

 ###  Onboarding

 ###  Tracking their routes and their friend’s routes
The user' location is kept in realtime. Furthermore, he/she is allowed their start and end points and see the route on their map. The user will be able to assign different colors to their friends'route so that it will be able to be displayed on map. Also, distance (in different units) and estimation time for finishing the route will be shown in our app. When the user is out of route, they will be notified.

The user can choose to see the specific friend’s routes or their current location (or both) on their map in different colors. And once user come to their end point, they will be able to record their actual time and distance for that route.

  ###  Manage friends
The user will be able to view their friend list, send request to add new friend, delete existing friends on their contact.
The user can also send messages to their friends.

  ###  Share
Users can share their route in-app in real time. It means that by the time the route is online, friends in custom share list will be able to see the route. But only if they want to. There are location and route privacy settings. For viewers, they can choose either see the route their friend shares or hide it from the map. By that way user can either share their location/route for specifics friends and can also limit the number of routes to be shown in their map

 ###  Statistic
In Statistic page, the user can viw their weekly and monthly data. In the screen, the user just need to swipe right at the weekly section to see the weekly data. To compare, click Compare and select one of the friends to see the comparision data.

 ###  Manage settings
The user is able to choose to display their friend’s avatars, name or both on the map with friend’s location in Setting section.


# Diagram

1. [Package Diagram](https://github.com/sorasuu/RouterCaster/blob/master/Package_Diagram.pdf)

2. [Model Class Diagram](https://github.com/sorasuu/RouterCaster/blob/master/ModelClassDiagram.pdf)

3. [View Class Diagram](https://github.com/sorasuu/RouterCaster/blob/master/ViewClassDiagram.pdf)

4. [Controller Class Diagram](https://github.com/sorasuu/RouterCaster/blob/master/ControllerClassDiagram.pdf)

5. [Entity Realtional Diagram](https://github.com/sorasuu/RouterCaster/blob/master/ERD.pdf)

# Acknowledgement
   1. https://firebase.google.com/docs/firestore/manage-data/add-data#update-data
   
   2. https://github.com/rebeloper/FirestoreAuth
   
   3. https://stackoverflow.com/questions/22550849/drawing-route-between-two-places-on-gmsmapview-in-ios
   
   4. https://stackoverflow.com/questions/44282454/draw-polyline-using-google-maps-in-custom-view-with-swift-3
   
   5. https://firebase.google.com/docs/database/admin/retrieve-data
   
   6. https://www.raywenderlich.com/5359-firebase-tutorial-real-time-chat
   
   7. https://www.youtube.com/channel/UCuP2vJ6kRutQBfRmdcI92mA
