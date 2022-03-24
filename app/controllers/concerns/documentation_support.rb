# Ejected from `bullet_train-1.0.36`.

module DocumentationSupport
  extend ActiveSupport::Concern

  def docs
    target = params[:page].presence || "index"
    files = `find -L tmp/gems/*/docs | grep \.md`.lines.map(&:chomp).sort
    puts "㊙️"
    puts files.inspect
    puts "㊙️"
    raise "stop here"
    @file = files.detect { |file| file.include?(target) }
    render :docs, layout: "docs"
  end
end
