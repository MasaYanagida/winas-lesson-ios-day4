# winas-lesson-ios-day4
2020/12/11のiOS Lesson Day4のサンプルと課題です

## 課題
Day4Homeworkプロジェクトにコードを記述して、以下のようなアプリを作ってください。
![Sample](https://user-images.githubusercontent.com/34995624/101751280-70557c00-3b13-11eb-92c8-40b9e19b3dc9.gif)

**要件**

```
・最初の画面でStartボタンを押したら、idFieldとpasswordFieldのテキストを、(1)UserDefaults、(2)Keychain、(3)Realmそれぞれに保存すること。
・コンテンツ画面のinfoボタンをタップしたらActionSheetにUserDefaults、Keychain、Realmの選択メニューを表示させ、メニューをタップしたらそれぞれ保存されたデータをアラートで表示すること
・コンテンツ画面は、最初にRealmに保存されているキャッシュを表示させること
・サーバ通信(SampleAPI.getList)でデータを取得して、コンテンツ画面に表示させること。取得したデータはRealmにも保存して次回のキャッシュとすること。
・TableViewの各セルをタップしたら、Contentの`description`を表示させること。
```
