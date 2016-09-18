## Inspiration

We are all multilingual and come from a different country. As language learners and world travellers, we have always wanted an app that could help us translate basic things fast and accurately in certain situations. For example, when I travel to Germany, I would love to understand local people better without having to study German for nights. When my mom travels to Canada, she could find herself easier in grocery stores and restaurants. 

## What it does

The voice translation app has two parts. The first part is turn-by-turn. User A presses to talk, presses again to stop, and then the phone speaks the translated version out so that user B understands. The other part is real time between two users (devices) as if they are talking on the phone. The app constantly listens to you and speaks out the result when it has it.

## How we built it

We use the new Speech framework in iOS 10 to recognize speech, and use Microsoft translation to translate the text. Socket.io and quickblox are also used to form Internet connections among phones.

## Challenges we ran into

* It is hard to translate when only a partial sentence is presented <br>
We used self correction to overcome this. Basically the translator will translate for each word chunk of the speech and every word chunk has its second half identical to the first half of the next word chunk. So that we can get a chance to exam the translation of the word chunk to see that if its translation makes sense. If the translation text of the second half of the first word chunk is different from the translation text of the first half of the second word chunk, we redo the translation for the combination of these two word chunks and let the app re-present this part of text quickly to correct the translation error.

* Swift 3 just came out in a week and is relatively new, so it is sometimes hard to find the solution for a swift issue

## Accomplishments that we're proud of

Conquer problems caused by new Swift 3 API

## What we learned

Development with Swift 3.0<br>
Multithreading management for Swift 3<br>
NLP

## What's next for EasternT

Enhance the accuracy of real time translation using NLP techniques<br>
Enable group chatting
