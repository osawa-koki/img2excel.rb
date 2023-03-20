require 'axlsx'

Axlsx::Package.new do |p|
  p.workbook.add_worksheet(:name => "main") do |sheet|
    # セルの値を設定
    width = 10
    sheet.add_row Array.new(width, nil)
    sheet.add_row Array.new(width, nil)
    sheet.add_row Array.new(width, nil)

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
