module JCov::Context

  # create a V8 context object with our context methods mapped onto it
  def create
    @context = V8::Context.new

    # map our context objects methods onto the v8 object
    # doing this instead of using :with because of this:
    # https://github.com/cowboyd/therubyracer/issues/251
    (self.methods - Object.new.methods - [:create]).each do |method|
      @context[method] = self.method(method)
    end

    @context
  end

end
