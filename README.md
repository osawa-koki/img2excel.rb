# img2excel.rb

🦔🦔🦔 Rubyを用いて画像をExcelに変換するスクリプトです。  
お遊びプログラムですので、実用性はありません。  

![成果物](./docs/img/fruit.gif)  

## 実行方法

```shell
ruby ./app/main.rb -i 対象画像ファイルパス -o 出力先Excelファイルパス
```

```shell
ruby ./app/main.rb -i tako.png -o tako.xlsx
ruby ./app/main.rb -i tuna.png -o tuna.xlsx
ruby ./app/main.rb -i shell.png -o shell.xlsx
```

## 使用している技術

- Ruby
  - axlsx (Excel操作)
  - RMagick (画像操作)
