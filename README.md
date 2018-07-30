# FitnessTracker

FitnessTracker is a simple calorie-counting app. It allows for tracking meals, calories, and macronutrients by providing & logging custom ingredients and recipes.

I use this app as a training ground for learning and exploring new frameworks and architectures. Each framework/architecture gets a full app re-write, usually. I keep basic shared logic (like model objects and the API) in a framework ([FitnessTrackerKit](https://github.com/smolster/FitnessTracker/tree/master/FitnessTrackerKit)). This framework only has one dependency: [Realm](https://github.com/realm/realm-cocoa), which is used for backing the API (storing recipes, ingredients, and meal entries).

So far, I've built the app using an MVVM architecture powered by RxSwift. The style and architecture are blatantly copied from the [Kickstarter iOS](https://github.com/kickstarter/ios-oss) codebase. Take a look at [this objc.io series](https://talk.objc.io/collections/ios-at-kickstarter) with the Kickstarter team to get an idea of how this code base works.

Currently, I'm working on rebuilding the app using the Redux architecture (using [ReSwift](https://github.com/ReSwift/ReSwift)).

If you'd like to look around in the codebase yourself, just checkout the repo, ensure you have [CocoaPods](https://github.com/CocoaPods/CocoaPods) installed, and run `pod update`.
