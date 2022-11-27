# codepath_ios_milestone
simple chat App
Original App Design Project - README Template
===

# ChatFish

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
 A simple chat app base on ios that allow group of people to chat and able to make todo list for work tracing.
[Description of your app]

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Soical Networking/ Chat
- **Mobile:** This app is only for ios simulator of xcode.
- **Story:** A simple chat app that easy to use. User can make a todo list.
- **Market:** This app is for people who working on the same project.
- **Habit:** This app can be use for share ideas and communicate for work.
- **Scope:** We first start with one group chat, then can add more group in the future

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- [x] User is able to sign up their own account.
- [x] User is able to sign in.
- [x] User is able to sign out.
- [x] User is able to send text message.
- [x] User is able to see past message from th user and other user.
- [x] User is able to see who sent the message.
- [x] User is able to create todo list items.

 [fill in your required user stories here]

**Optional Nice-to-have Stories**

- [x] User is able to see a launch screen when open the app.
- [x] User is able to stay log in when reopen the app.
- [x] User is able to check off todo list items.

 * [fill in your required user stories here]

### 2. Screen Archetypes

* Login and sign up
   * User can sign up or log in to their account.
* Chat
   * User can log out from this screen.
   * User can send text message.
   * User can see the past message from the user and other user.
   * User can go to the to do list screen.
* To Do List 
   * User can see to do list items.
   * User can add to do list items.
   * User can check off to do list items.
   * User can go back to chat screen.
<imag src ="https://i.imgur.com/aIz1ZQT.gif">
### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Log in
* Log out
* Add
* Back

**Flow Navigation** (Screen to Screen)

* Log in
   * Go to chat screen
* Log out
   * Back to log in screen
* Add
   * Go to to do list from chat screen
* Back
   * Back to chat screen from to do list

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="https://i.imgur.com/pkwBY04.jpg" width=600>



### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
#### Message
   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   |username       |String    |User who sent the message|
   |content        |String    |Content of the message|
   
#### ToDo List   
   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   |item           |String    |Description of the work need to be done|
   
[Add table of models]
### Networking
- Login Screen
    - (Read/Create) Create new user with input username and password
    - (Read/Get) Read the input username and password to see if it is match the record
- Chat Screen
    - (GET) Get all message's username and content to display on screen
    - (Read/Create) Read the string in input text bar and create new message
    - (Delete) Delete account status for log out
- To Do List Screen
    - (GET) Get all to do list items and display on screen
    - (Read/Create) Read the input string and create new item
    - (Update/PUT) Update item status
    
    
    
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
