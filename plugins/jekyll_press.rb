# jekyll_press 0.0.1
# https://github.com/stereobooster/jekyll_press

require 'html_press'

module Jekyll
  module Compressor
    def output_file(dest, content)
      FileUtils.mkdir_p(File.dirname(dest))
      File.open(dest, 'w') do |f|
        f.write(content)
      end
    end

    def output_html(path, content)
      self.output_file(path, HtmlPress.press(content))
    end
  end

  class Post
    include Compressor

    def write(dest)
      dest_path = self.destination(dest)
      self.output_html(dest_path, self.output)
    end
  end

  class Page
    include Compressor

    def write(dest)
      dest_path = self.destination(dest)
      self.output_html(dest_path, self.output)
    end
  end
end