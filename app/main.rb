require 'rmagick'
require 'axlsx'
require 'optparse'

options = {}
options[:cell_width] = 0.7
options[:cell_height] = 5
opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on("-i", "--input INPUT_PATH", "Input file path") do |v|
    options[:input_path] = v
  end

  opts.on("-o", "--output OUTPUT_PATH", "Output file path") do |v|
    options[:output_path] = v
  end

  opts.on("-w", "--width [CELL_WIDTH]", Float, "Cell width (default: 0.7)") do |v|
    options[:cell_width] = v
  end

  opts.on("-h", "--height [CELL_HEIGHT]", Float, "Cell height (default: 5)") do |v|
    options[:cell_height] = v
  end
end

opt_parser.parse!(ARGV)

if options[:input_path].nil? || options[:output_path].nil?
  puts "Missing required arguments: -i/--input, -o/--output"
  exit
end

# 画像ファイルのパスを指定する
image_path = options[:input_path]

# 画像ファイルを読み込む
image = Magick::Image.read(image_path).first

# 画像の幅と高さを取得する
width = image.columns
height = image.rows

puts "width:#{width}, height:#{height}"

size = width * height
puts "size:#{size}"

if size > 128 * 128
  puts "Too large image size: #{size}"
  exit
end

# セルの大きさを設定する
cell_width = options[:cell_width].to_f
cell_height = options[:cell_height].to_f

puts "cell_width:#{cell_width}, cell_height:#{cell_height}"

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

        sheet.rows[y].cells[x].style = sheet.workbook.styles.add_style(:bg_color => color_code)
      end
    end

  end

  p.serialize(options[:output_path])
end

puts "Done!"
