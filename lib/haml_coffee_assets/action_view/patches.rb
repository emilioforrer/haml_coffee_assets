# Monkey patches for rails to support our template engine.
# Hopefully these fixes will make it into rails or we find a
# better way to avoid this.
#
# TODO: Don't monkey patch rails

# See patch notes inline
class ::ActionView::Template

  # Patch, it's almost exaclty the same with a small tweak
  def handle_render_error(view, e) #:nodoc:
    if e.is_a?(::ActionView::Template::Error)
      e.sub_template_of(self)
      raise e
    else
      assigns  = view.respond_to?(:assigns) ? view.assigns : {}
      template = self

      # Here's the patch: if the javascript runtime throws an error
      # during compilation, we get to this handler but our view 
      # doesn't have a lookup_context - thus throwing a very hard
      # to debug error in Template#refresh. To circumvent, ensure the
      # view responds to lookup_context before refreshing.
      if view.respond_to?(:lookup_context) and template.source.nil?
        template = refresh(view)
        template.encode!
      end

      if Rails::VERSION::STRING < "4"
        raise ::ActionView::Template::Error.new(template, assigns, e)
      else
        raise ::ActionView::Template::Error.new(template, e)
      end
    end
  end
end
