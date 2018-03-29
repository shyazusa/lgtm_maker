require 'sinatra'
require 'sinatra/reloader'
require 'slim'
require 'RMagick'

get '/' do
  @title = 'lgtm_maker'
  slim :index
end

post '/upload' do
  if params[:photo]
    image_path = "./public/images/#{params[:photo][:filename]}"
    File.open(image_path, 'wb') do |f|
      p params[:photo][:tempfile]
      f.write params[:photo][:tempfile].read
    end
    enchar image_path, params[:stroke]
  end
  redirect 'images'
end

get '/images' do
  @title = 'local images'
  images_name = Dir.glob('./public/images/*')
  @images_path = []
  images_name.sort!
  images_name.each do |image|
    @images_path << image.gsub('public/', './')
  end
  slim :images
end

helpers do
  def enchar(image_path, stroke)
    image_file_name = File.basename(image_path)
    img = Magick::ImageList.new(image_path)
    lgtm = 'LGTM'
    char = "\nLooks Good To Me."
    font = './public/fonts/Mamelon.otf'
    pointsize = 120
    fill = 'white'
    if img.columns > 1200
      scale = 1200.quo(img.columns).to_f
      img = img.resize(scale)
    end

    writePic(img, lgtm, font, fill, pointsize, stroke, 0)
    writePic(img, char, font, fill, pointsize / 3, stroke, 60)

    img.write("public/images/#{image_file_name}")
    img.destroy!
  end

  def writePic(img, char, font, fill, pointsize, stroke, hight)
    draw = Magick::Draw.new
    draw.annotate(img, 0, 0, 0, hight, char) do
      self.font = font
      self.fill = fill
      self.pointsize = pointsize
      self.stroke = stroke
      self.stroke_width = 4
      self.gravity = Magick::CenterGravity
    end

    draw.annotate(img, 0, 0, 0, hight, char) do
      self.font = font
      self.fill = fill
      self.pointsize = pointsize
      self.stroke = 'transparent'
      self.gravity = Magick::CenterGravity
    end
  end
end
