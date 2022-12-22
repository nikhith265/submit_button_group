<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->
# submit_button_group
<a href="https://stackoverflow.com/questions/tagged/flutter?sort=votes">
   <img alt="Awesome Flutter" src="https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square" />
</a>


A flutter plugin to show button with inbuilt loading.

## Features

<table>
 <tr>
  <td><img src="https://raw.githubusercontent.com/nikhith265/submit_button_group/master/attachments/screen_shots/Screenshot_1671328831.png" alt="Button type one" width="300" height="540"></td>
  <td><img src="https://raw.githubusercontent.com/nikhith265/submit_button_group/master/attachments/screen_shots/Screenshot_1671330586.png" alt="Button type two" width="300" height="540"></td>
 </tr>
 <tr>
  <td><img src="https://raw.githubusercontent.com/nikhith265/submit_button_group/master/attachments/screen_shots/Screenshot_1671330607.png" alt="Button type three" width="300" height="540"></td>
<!-- <td>![Loading sample](https://github.com/nikhith265/submit_button_group/blob/298c26b5a3fcfe936f16deef0e8712c2fdc1b635/attachments/gif/sample_gif.gif?raw=true)</td> -->
    <td><img src="https://raw.githubusercontent.com/nikhith265/submit_button_group/298c26b5a3fcfe936f16deef0e8712c2fdc1b635/attachments/gif/sample_gif.gif" alt="gif" width="300" height="540">
 </td>
 </tr>
 <tr>
  
   <td><img src="https://raw.githubusercontent.com/nikhith265/submit_button_group/master/attachments/screen_shots/Group%20535.png" alt="Button type three" width="300" height="150"></td>
 
 </tr>
</table>

<h3>Handling the loading of buttons is an extra task for developers. Don't worry, now it's simple. Swipe down. </h3>


## Getting started

Add the latest submit_button_group as a dependency in your pubspec.yaml file.

Create a custom Widget to display a group of two buttons with an in-build loading action. In default Widget shows two buttons, the primary button and the secondary button.  The primary button shows the nature of a submit button and the secondary button shows the nature of a close button. Both are customizable and perform as needed.

## Usage
### Adding group of buttons
Display both buttons.

```dart
 SubmitButtonsGroup groupButton =  SubmitButtonsGroup(  
            loading: _loading,
            onSubmit: () async {
              _loading.value = true;
               await _incrementCounter();
              _loading.value = false;
            },
          );
```
### Adding a single button

Show only a single button.

```dart
SubmitButtonsGroup button =  SubmitButtonsGroup(
            isExpand: true,
            loading: _loading,
            hideSecondaryButton = true;
            onSubmit: () async {
              _loading.value = true;
              await _incrementCounter();
              _loading.value = false;
            },
          );
```       
## Road map

I am always open for suggestions and ideas for possible improvements or fixes.

Feel free to open a <a href ="https://github.com/nikhith265/submit_button_group/pulls"> <Strong>Pull Request</Strong></a> if you would like to contribute to the project.

If you would like to have a new feature implemented, just write a new issue.
