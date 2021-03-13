require 'json'
require 'fileutils'

Dir.chdir('raw')
all_files = Dir.glob('**/*.MP4');

Dir.chdir('..')
FileUtils.rm_rf 'converted'
Dir.mkdir 'converted'

all_files.each do |f|
  puts "Converting #{f}"
  info = JSON.parse(`ffprobe -v quiet -print_format json -show_streams -show_format "#{f}"`)
  dirname = f.split('/')[0...-1].join("/")
  puts "DIRNAME: #{dirname}"
  FileUtils.mkdir_p("converted/#{dirname}")
  `ffmpeg -i "raw/#{f}" -vf "scale=1280:720,fps=30000/1001,format=yuv422p" -b:v 110M -c:a pcm_s16le -c:v dnxhd "converted/#{f}.mov"`
end

puts 'done'