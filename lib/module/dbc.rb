# Copyright (c) 2012 Kenichi Kamiya


class Foo

  extend DbC

  invariant { @name.kind_of? String }

  def func1(arg)
  end
  precondition :func1 {|arg|arg > 1}
  postcondition :func1 {|ret|ret > 1}

  dbc  do
    pre {}
    def func2
    end
    post {}

    pre {}
    def func3
    end
    post
  end

end


class Module

  module DbC

    private

    def precondition
    end

    def postcondition
    end

    def invariant
      yield
    end

  end

end
