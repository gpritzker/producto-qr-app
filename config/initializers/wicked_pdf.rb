if Rails.env.production?
  WickedPdf.config = {
    exe_path: '/app/bin/wkhtmltopdf'
  }
else
  WickedPdf.config ||= {
    exe_path: Gem.bin_path('wkhtmltopdf-binary', 'wkhtmltopdf')
  }
end
