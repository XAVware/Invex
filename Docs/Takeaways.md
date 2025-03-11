# Key Takeaways
### Running list - oldest to newest
- Take the time to set up your git project and gitignore correctly to avoid tedious clean up in the future. Branches are powerful, use them.
- More complex code does not necessarily mean it's better code.
- Make smaller commits that use shorter messages. At the time of writing the long commit messages it seemed important - 01.2025 I don't think I've ever went back to read them.
- Merge conflicts are not fun, especially when you attempt to open the project in XCode afterwards.
- Ask yourself 'are you absolutely sure the user interface NEEDS to be laid out this way and it won't change in the future' before wasting time building custom components (ref. LazySplitX)
- Cleaning and solidifying the foundation is more difficult when the app has more features.
- When you begin going down the path of creating a reusable component (ref. ComponentsX - Invex v1.3) pause development and architect/design the full component before beginning development again. This will help avoid implementing a core piece of the component's foundation incorrectly (ref. cancel/submit buttons).
- If it's important that the app runs and appears well on iPhone and iPad, consider making two separate XCode projects.
- Sometimes input validation can be better handled before the user taps submit.
- Don't rush through the final stages of testing before a release.
