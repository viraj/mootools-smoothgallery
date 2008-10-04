module MootoolSmoothgallery
  module ActionView::Helpers::AssetTagHelper
    @store_dir     = nil
    @thumb_postfix = nil
    # Use this method in your view to generate the required DOMs and Jabvascript.
    #
    # Example action:
    # 
    # def index
    #   @blogs = Blog.find(:all)
    # end
    # 
    # The plugin assume the blogs table include title, description and image fields
    #
    # Example view:
    #
    #   <div class="content">
    #     <%= smooth_gallery( "myGallery", @blogs, { :store_dir => "gallery/green/" } )%>
    #   </div>
    #
    # By default the :store_dir => "images/"
    #
    # TODO - Object fields mapping needed so the above assumption about the table stucture can be removed
    #
    def smooth_gallery( name, collection, options={} )
      set_store_dir ( options[:store_dir] ) if options[:store_dir]
      set_thumb_postfix ( options[:thumb] ) if options[:thumb]
      ret =  smooth_gallery_javascript_tag( name ) + "\n"
      ret << content_tag( :div, smooth_gallery_tags( collection, options ), :id => name )
    end
    
    # This method will generate the required DOMs for the colection
    #
    def smooth_gallery_tags( collection, options={} )
      return_html = ""
            
      collection.each{ |object|
        return_html += smooth_gallery_tag( :src =>"#{ @store_dir }/#{ object.image }",
             :thumb =>"#{ @store_dir }/#{ thumbnail_image( object.image ) }",
             :title=>object.title,
             :description=>object.description )
      }
      return return_html
    end
    
    def set_store_dir( opt )
      @store_dir = opt || "image"
    end
    
    def set_thumb_postfix( thumb )
      @thumb_postfix = thumb || "-mini"
    end
    # This will split the file name and extention and add '-mini' postfix to the file name
    # Assumption : image name => file_name.ext
    # TODO - have to pass the thumbnail postfix
    #
    def thumbnail_image( image )
      filename, extention = image.split( "." )
      thumbnail = "#{ filename }#{ @thumb_postfix }.#{ extention }"
    end
    
    # This method will generate the required DOM
    # Example :
    # 
    # <div class="imageElement">
    #   <h3>Title of the image</h3>
    #   <p>Description of the image</p>
    #   <a class="open" href="/images/gallery/brugges2006/image_name.jpg.?1165130528" title="open image"></a>
    #   <img alt="image_name" class="full" src="/images/gallery/brugges2006/image_name.jpg.?1165130528" />
    #   <img alt="image_name" class="thumbnail" src="/images/gallery/brugges2006/image_name-mini.jpg.?1165130528" />
    # </div>
    #
    def smooth_gallery_tag( options={} )
      options.symbolize_keys!
      options[:src] = path_to_image(options[:src])
      options[:alt] ||= File.basename(options[:src], '.*').split('.').first.capitalize
      options[:class] = 'full'
      
      if size = options.delete(:size)
        options[:width], options[:height] = size.split("x") if size =~ %r{^\d+x\d+$}
      end
      
      if mouseover = options.delete(:mouseover)
        options[:onmouseover] = "this.src='#{image_path(mouseover)}'"
        options[:onmouseout]  = "this.src='#{image_path(options[:src])}'"
      end
      
      title       = content_tag( :h3, options.delete( :title ) )
      description = content_tag( :p, options.delete( :description ) )
      thumbnail   = options.delete( :thumb )
      
      a_tag = content_tag(:a, "", :href=>"#{path_to_image(options[:src])}",:class => "open", :title=>"open image")
      full_image = tag("img", options)
      
      options[:class] = 'thumbnail'
      options[:src] = path_to_image( thumbnail )
      thumb_image = tag("img", options)
       "\n\t<div class=\"imageElement\">\n\t#{title}\n\t#{description}\n\t#{a_tag}\n\t#{full_image}\n\t#{thumb_image}\n\t</div>\n"
    end

    # This method will generate the required Javascript
    #
    # Example :
    # <script type="text/javascript">
    # //<![CDATA[
    #   function startGallery() {
    #     var myGallery = new gallery($('myGallery'), {
    #       timed: false
    # });
    # }
    #   window.addEvent('domready',startGallery);
    # //]]>
    # </script>
    #
    def smooth_gallery_javascript_tag(element_id)    
      function = "\tfunction startGallery() {\n\t\tvar myGallery = new gallery($('"+element_id+"'), {\n\t\t\ttimed: false\n\});\n}\n\twindow.addEvent('domready',startGallery);"
      
      javascript_tag( function )
    end

    # This method will generate the required Javascript
    #
    # Example :
    # <script type="text/javascript">
    # //<![CDATA[
    #   window.addEvent('domready', function() {
    #     document.myGallerySet = new gallerySet($('myGallerySet'), {
    #       timed: false
    # });
    #   });
    # //]]>
    # </script>
    #
    def smooth_gallery_set_javascript_tag( element_id )    
      js = "\twindow.addEvent('domready', function() {\n\t\tdocument.myGallerySet = new gallerySet($('"+element_id+"'), {\n\t\t\ttimed: false\n\});\n\t});"
      
      javascript_tag( js )
    end
    
    # Use this method in your view to generate the required DOMs and Jabvascript.
    #
    # Example action:
    # 
    # def index
    #   @blogs     = Blog.find(:all, :conditions=>["gallery=?", 1])
    #   @blogs_two = Blog.find(:all, :conditions=>["gallery=?", 2])
    # end
    # 
    # The plugin assume the blogs table include title, description and image fields
    #
    # Example view:
    #
    # <div class="content">
    # <%= smooth_gallery_set_javascript_tag( "myGallerySet" ) %>
    #   <div id="myGallerySet">
    #     <%= smooth_gallery_set( "gallery1", @blogs, { :store_dir => "gallery/green", :title=>"Brugges 2006" })%>
    #     <%= smooth_gallery_set( "gallery2", @blogs_two, { :store_dir => "gallery/green", :title=>"Stock Photos" } )%>
    #   </div>
    # </div>
    #
    # By default the :store_dir => "images"
    #
    # TODO - Object fields mapping needed so the above assumption about the table stucture can be removed
    #
    def smooth_gallery_set( name, collection, options={} )
      set_store_dir ( options[:store_dir] ) if options[:store_dir]
      set_thumb_postfix ( options[:thumb] ) if options[:thumb]      
      ret = content_tag( :div, content_tag( :h2, options[:title] ) + smooth_gallery_tags( collection, options ), :id => name, :class => 'galleryElement' )
    end
  end
end