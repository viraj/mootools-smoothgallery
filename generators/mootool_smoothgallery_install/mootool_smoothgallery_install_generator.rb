class MootoolSmoothgalleryInstallGenerator < Rails::Generator::Base
  
	def manifest
    record do |m|
      ["jd.gallery", "jd.gallery.set", "jd.gallery.transitions", "mootools.v1.11"].each do |js_file|
        m.file "javascripts/#{js_file}.js", "public/javascripts/#{js_file}.js"
      end

      m.directory "public/stylesheets/img"
      
      ["carrow1.gif","carrow2.gif","fleche1.gif","fleche1.png","fleche2.gif","fleche2.png","loading-bar-black.gif","open.gif","open.png"].each do |img_file|
        m.file "stylesheets/img/#{img_file}", "public/stylesheets/img/#{img_file}"
      end

      ["jd.gallery.css","layout.css"].each do |css_file|
        m.file "stylesheets/#{css_file}", "public/stylesheets/#{css_file}"
      end

      # Sample data
      m.directory "public/images/gallery/garden"
      (1..9).each do |x|
        m.file "images/gallery/garden/image_0#{x}.jpg", "public/images/gallery/garden/image_0#{x}.jpg"
        m.file "images/gallery/garden/image_0#{x}-mini.jpg", "public/images/gallery/garden/image_0#{x}-mini.jpg"
      end
      m.directory "public/images/gallery/green"
      (1..8).each do |x|
        m.file "images/gallery/green/image_0#{x}.jpg", "public/images/gallery/green/image_0#{x}.jpg"
        m.file "images/gallery/green/image_0#{x}-mini.jpg", "public/images/gallery/green/image_0#{x}-mini.jpg"
      end

    end
  end
end