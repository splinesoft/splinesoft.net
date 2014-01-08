require 'pygmentize'
class Jekyll::HighlightBlock < Liquid::Block
	def render_pygments(context, code)
		@options[:encoding] = 'utf-8'
		output = add_code_tags(
			Pygmentize.process(code, @lang),
			@lang
		)

		output = context["pygments_prefix"] + output if context["pygments_prefix"]
		output = output + context["pygments_suffix"] if context["pygments_suffix"]
		output
	end
end
