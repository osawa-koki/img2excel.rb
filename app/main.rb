require 'rmagick'
require 'axlsx'

# 画像ファイルのパスを指定する
image_path = 'tako.png'

# 画像ファイルを読み込む
image = Magick::Image.read(image_path).first

Axlsx::Package.new do |p|
  p.workbook.add_worksheet(:name => "main") do |sheet|

    # 画像の幅と高さを取得する
    width = image.columns
    height = image.rows

    # ピクセルを縦横ループして1ピクセルずつ色を取得する
    (0..height-1).each do |y|
      (0..width-1).each do |x|
        pixel = image.pixel_color(x, y)
        red = pixel.red
        green = pixel.green
        blue = pixel.blue
        puts "x:#{x}, y:#{y}, color:#{red},#{green},#{blue}"
      end
    end

    # 行の高さを設定
    sheet.rows[0].height = 30
    sheet.rows[1].height = 20
    sheet.rows[2].height = 25

    # 列の幅を設定
    sheet.column_widths 5, 15, 10

    # スタイルを作成
    red_bg = p.workbook.styles.add_style :bg_color => "FF0000"
    green_bg = p.workbook.styles.add_style :bg_color => "00FF00"
    blue_bg = p.workbook.styles.add_style :bg_color => "0000FF"

    # セルにスタイルを適用
    sheet["A2"].style = red_bg
    sheet["B2"].style = green_bg
    sheet["C2"].style = blue_bg
  end
  p.serialize('sample.xlsx')
end
