A project to be used as the starting point for a new iOS project

## First steps
    cd to TSBoilerplate
    pod install
    sudo cp App/Model/CoreDataModel/MogenTemplate/mogenerator /usr/bin
    open TSBoilerplate.xcworkspace

## Includes:
* TSNetworking
* Mogenerator (Arc and NSCoding support for model files)
* Thanks to [Tyrone](https://github.com/tyrone-sudeium) for his guidance on Commands

## Data persistance:
When you want to change the data model, as in, add new entities, or change properties of existing ones, make the change in the Model.xcdatamodel file (like you would for a core data app), change the scheme to "Generate Data Model" and build the project. That will instigate mogenerator to make the change and your data model objects in App/Model/ModelObjects will be updated (or added).

The source files will be generated in App/Model/ModelObjects/ - you will need to drag these into the project after the entity is first created (they will simply update in place thereafter if you made changes to that model object in the .xcdatamodel).

When you want to add a new entity, make sure you set the data type to that entity's name. I.e.

![data model](http://i.imgur.com/8seiyZQ.png)

## Networking: 
TSNetworking - <a href="https://github.com/timsawtell/TSNetworking" target="_blank">https://github.com/timsawtell/TSNetworking</a>

## Commands:
The commands subsystem is broken up into synchronous and asynchronous command which are executed by TSCommandRunner.
Commands are the way of having your controllers tell "the system" to do something and don't get bogged down with the business logic. As a general rule, anything can READ from the Model, however only COMMANDS can change the model. 
Your view controller will get the user's data, for example a name, and set that on a command. It will then run a command to update a model object with that data. This allows decoupling of view controllers to model objects.

Example usage for Synchronous

    GroupCommand *groupCommand = [GroupCommand new];
    groupCommand.groupName = kGroupName;
    groupCommand.saveModel = YES; // at the end of the execute method, save the model.
    [[TSCommandRunner sharedCommandRunner] executeSynchronousCommand:groupCommand];

or Asynchronous

    MemberDisplayCommand *memberDisplayCommand = [MemberDisplayCommand new];
    memberDisplayCommand.group = [Model sharedModel].group;
    memberDisplayCommand.commandCompletionBlock = ^ (NSError *error) {
        DLog(@"Your first completion block!");
        DLog(@"Erorr says: %@", [error localizedDescription]);
    };
    [[TSCommandRunner sharedCommandRunner] executeAsynchronousCommand:memberDisplayCommand];

an Asynchronous Webservice command

    TwitterCommand *twitterCommand = [TwitterCommand new];
    twitterCommand.screenName = kTwitterScreenName;
    twitterCommand.includeRetweets = YES;
    twitterCommand.includeEntities = NO;
    twitterCommand.tweetCount = kTweetCount;
    twitterCommand.twitterCommandCompletionBlock = ^ (NSError *error) {
        if (error != nil) {
            DLog(@":( Erorr says: %@", [error localizedDescription]);
        } else {
            /* we don't know what's happened, but we trust that the model is updated. 
            The programmer doesn't need to handle the tweet results, the command has already done that.
            you would usually call something like [self.tableView reloadData] here */
            for (Tweet *tweet in [Model sharedModel].tweets) {
                DLog(@"%@ - %@", tweet.user.name, tweet.text);
            }
        }
    };
    [[TSCommandRunner sharedCommandRunner] executeAsynchronousCommand:twitterCommand];

## License
MIT License as per the LICENSE file and http://www.opensource.org/licenses/MIT
