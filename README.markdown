A project to be used as the starting point for a new iOS project.

This project uses Cocoapods.

## First steps
    cd to cloned directory
    pod install
    sudo cp App/Model/CoreDataModel/MogenTemplate/mogenerator /usr/bin
    open the .xcworkspace

## Includes:
* TSNetworking
* Mogenerator (Arc and NSCoding support for model files)

## Data persistance:
The app uses an archived root object as the data persistence mechanism. The data model lives in memory from app launch. The data model is designed using the standard Core Data editor, however the app does not use NSManagedObjects. The Mogenerator tool will build classes for you based on the templated in the MogenTemplate directory.

When you want to change the data model, as in, add new entities, or change properties of existing ones, make the change in the Model.xcdatamodel file (like you would for a core data app), change the scheme to "Generate Data Model" and build the project. That will instigate mogenerator to make the change and your data model objects in App/Model/ModelObjects will be updated (or added).

The source files will be generated in App/Model/ModelObjects/ - you will need to drag these into the project after the entity is first created (they will simply update in place thereafter if you made changes to that model object in the .xcdatamodel).

When you want to add a new entity, make sure you set the data type to that entity's name. I.e.

![data model](http://i.imgur.com/8seiyZQ.png)

## Networking: 
[TSNetworking](https://github.com/timsawtell/TSNetworking) library.
This project uses Builder classes to create model objects from the JSON data returned from the API.
A typical scenario

                                            ------- results ----------
                                            |                        |
                                            v                        |
    View Controller -> Command Center -> Command (Networking Task)  -|
                                            |
                                             --> Builder (to create model objects)            
                                          
                                           

## Business Logic
The app uses the concept of Commands to be self contained classes that execute one specific use case. The commands can be run synchronously (just subclass the Command class) or asynchronously (subclass the AsynchronousCommand class). The different between them is the thread that they run on. Synchronous commands run on the main thread, so when you call them in your view controllers or in Command Center they will execute before the next line of code starts. Asynchronous commands on the other hand are passed to a background queue and they will eventually execute on another thread, which means that they can't have any UI changes in the execute method. 

To perform UI changes after the command has finished, add the code to that command's completionBlock property. All networking use cases ("get customer details", "submit payment" etc.) are asynchronous, you need the app to do something when the data is fetched from the server.

## MVC and how it's used in this project
Model.m is the central data model instance, it is the data store, and it is used as the single source of truth. You won't find View Controllers owning business objects in this project.

View Controllers _NEVER_ change model objects. This is a self imposed rule to avoid what I usually find on other projects, your data is updated by some other unknown controller and it's very difficult to find out who did it.

CommandCenter.m is where you issue your use cases.

View Controller -> Command Center -> Command (which updates the model) 

or 

View Controller -> Command Center (which updates the model).

in this paradigm there are only two places that a model object can be updated, in a command or in CommandCenter.

View Controllers read data directly from the model, or through an Accessor (if business logic needs to be applied to a data structure, i.e. sorting).