# gpst
プロコン用サブミッションCLI
送信用のスクリプトを置けば送信まで，デフォルトはCopy

## 現状

Submit :: AtCoder(ARC, ABC)
Copy :: For all

Language

+ Java
+ Bash

## Installation

    bundler install
    $PATHにgpstを入れる

## How to use

+ DSLでコンフィグを作る(e.g. abc_test.gpst)
+ サブミット用のスクリプトを追加する(Copyモードなら必要ない)
+ gpst abc_test.gpst を実行して対話的にファイルを選択する
+ copyがしたい場合は -p copy を追加して実行する

## DSL

    contest {
        type "abc" # コンテストの識別子 (e.g. arc)
        title "AtCoder Beginner Contest" # タイトル．情報表示用
        path "~/Projects/procon/atcoder/BashCoder/abc" # コンテスト用Dir root
        url 'http://#{@type}#{@tasks.revision}.contest.atcoder.jp/' # コンテストページのURL. contestのblockがスコープ

        tasks {
            revision "001" # コンテストリビジョン
            path_rel "001" # 親からの相対パス(Dir)

            task ("a") {
                path_rel "a.sh" # 親からの相対パス(File)．実際のソースファイル
                lang "bash" # 提出言語
                memo "A" # ただのメモ
            }
        }
    }


    Sample: abc_test.gpst

## Directories
+--Gemfile
|--LICENSE
|--README.md
|--abc_test.gpst
|--gpst
|--lang
|  |--bash.lang.rb
|  |--java.lang.rb
|  |--lang.rb
|  └--lang.template
└--process
   |--copy.process.rb
   |--process.rb
   |--process.template
   |--submit.process.rb
   └--submit
      |--abc.submit.rb
      |--arc.submit.rb
      └--atcoder.submit.sh

## Extension

### Language

    lang.templateや他のファイルを参考に，${language name}.lang.rb としてlang/に保存
    必要なメソッドはfilter
    言語や個人ごとにデバッグ情報，パッケージ情報などを除去するために利用

### Process

    process.templateや他のファイルを参考，${process name}.lang.rb としてprocess/に保存
    必要なメソッドはprocess
    Languageごとのfilterを終えたファイル内容に対して何らかの処理をするために利用

### Submit
    
    process/submit化にスクリプトを置く
    必要なメソッドはsubmit
    提出のために利用