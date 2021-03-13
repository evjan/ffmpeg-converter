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
  `ffmpeg -i "raw/#{f}" -vf "scale=1920:1080p,fps=50,format=yuv422p10" -b:v 440M -c:a pcm_s16be -c:v dnxhd "converted/#{f}.mov"`
end

puts 'done'