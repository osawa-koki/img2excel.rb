require 'rmagick'
require 'axlsx'

# 画像ファイルのパスを指定する
image_path = 'tako.png'

# 画像ファイルを読み込む
image = Magick::Image.read(image_path).first

# 画像の幅と高さを取得する
width = image.columns
height = image.rows

puts "width:#{width}, height:#{height}"

# セルの大きさを設定する
cell_width = 0.7
cell_height = 5

Axlsx::Package.new do |p|
  p.workbook.add_worksheet(:name => "main") do |sheet|

    (0..height-1).each do |y|
      sheet.add_row Array.new(width, nil)
      sheet.rows[y].height = cell_height
    end

    (0..width-1).each do |x|
      sheet.column_info[x].width = cell_width
    end

    # ピクセルを縦横ループして1ピクセルずつ色を取得する
    (0..height-1).each do |y|
      (0..width-1).each do |x|
        pixel = image.pixel_color(x, y)
        red = pixel.red / 256
        green = pixel.green / 256
        blue = pixel.blue / 256

        color_code = "%02X%02X%02X" % [red, green, blue]

        # puts "x:#{x}, y:#{y}, color:#{red},#{green},#{blue}"
        # puts "color_code:#{color_code}"

        bg = p.workbook.styles.add_style :bg_color => color_code

        sheet.rows[y].cells[x].style = sheet.workbook.styles.add_style(:bg_color => 'FF0000')

      end
    end

  end

  p.serialize('sample.xlsx')
end
