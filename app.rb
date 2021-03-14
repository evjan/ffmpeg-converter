require 'json'
require 'fileutils'

all_files = Dir.glob('**/*.MP4');

proxy = ARGV[0] == "--proxy"

output_dir = ""
profile = 0

if(proxy)
  puts "Generating proxies..."
  output_dir = "converted/proxies"
  profile = 0 # proxy
else
  puts "Generating HQ videos..."
  output_dir = "converted/hq"
  profile = 3 # hq
end

FileUtils.rm_rf output_dir
FileUtils.mkdir_p output_dir

all_files.each do |f|
  puts "Converting #{f}"
  dirname = f.split('/')[0...-1].join("/")
  puts "DIRNAME: #{dirname}"
  FileUtils.mkdir_p("#{output_dir}/#{dirname}")
  `ffmpeg -i "#{f}" -c:v prores_ks -profile:v #{profile} -vendor apl0 -pix_fmt yuv422p10le "#{output_dir}/#{f}.mov"`
end