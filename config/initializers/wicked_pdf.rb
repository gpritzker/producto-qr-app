if Rails.env.production?
  WickedPdf.config = {
    exe_path: '/app/bin/wkhtmltopdf',
    enable_local_file_access: true
  }
else
  WickedPdf.config ||= {
    exe_path: Gem.bin_path('wkhtmltopdf-binary', 'wkhtmltopdf'),
    enable_local_file_access: true
  }
end

