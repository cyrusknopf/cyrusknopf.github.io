module Jekyll
  class SidenoteBlock < Liquid::Block
    def render(context)
      n = (context.registers[:sidenote_count] ||= 0) + 1
      context.registers[:sidenote_count] = n

      %(<label for="sn-#{n}" class="sidenote-toggle sidenote-number"></label>) +
        %(<input type="checkbox" id="sn-#{n}" class="sidenote-toggle"/>) +
        %(<span class="sidenote">#{super.strip}</span>)
    end
  end
end

Liquid::Template.register_tag('sidenote', Jekyll::SidenoteBlock)
