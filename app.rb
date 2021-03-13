require 'json'
require 'fileutils'

Dir.chdir('raw')
all_files = Dir.glob('**/*.MP4');

Dir.chdir('..')

proxy = ARGV[0] == "--proxy"

output_dir = ""
quality = ""

if(proxy)
  puts "Generating proxies..."
  output_dir = "converted/proxies"
  quality = '"scale=1920:1080p,fps=50,format=yuv422p" -b:v 36M'
else
  puts "Generating HQ videos..."
  output_dir = "converted/hq"
  quality = '"scale=1920:1080p,fps=50,format=yuv422p10" -b:v 440M'
end

FileUtils.rm_rf output_dir
FileUtils.mkdir_p output_dir

all_files.each do |f|
  puts "Converting #{f}"
  info = JSON.parse(`ffprobe -v quiet -print_format json -show_streams -show_format "#{f}"`)
  dirname = f.split('/')[0...-1].join("/")
  puts "DIRNAME: #{dirname}"
  FileUtils.mkdir_p("#{output_dir}/#{dirname}")
  `ffmpeg -i "raw/#{f}" -vf #{quality} -c:a pcm_s16be -c:v dnxhd "#{output_dir}/#{f}.mov"`
end