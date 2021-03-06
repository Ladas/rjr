require 'rjr/local_node'
require 'rjr/dispatcher'

describe RJR::LocalNode do
  it "should invoke requests against local handler" do
    node = RJR::LocalNode.new :node_id => 'aaa'
    foobar_invoked = false
    RJR::Dispatcher.init_handlers
    RJR::Dispatcher.add_handler('foobar') { |param|
      @rjr_node.should == node
      @rjr_node_id.should == 'aaa'
      @rjr_node_type.should == :local
      param.should == 'myparam'
      foobar_invoked = true
      'retval'
    }

    res = node.invoke_request 'foobar', 'myparam'
    foobar_invoked.should == true
    res.should == 'retval'
  end

  it "should invoke callbacks against local handlers" do
    foobar_invoked = false
    callback_invoked = false
    RJR::Dispatcher.init_handlers
    RJR::Dispatcher.add_handler('foobar') {
      foobar_invoked = true
      @rjr_callback.invoke('callback', 'cp')
    }
    RJR::Dispatcher.add_handler('callback') { |*params|
      params.length.should == 1
      params[0].should == 'cp'
      callback_invoked = true
    }

    node = RJR::LocalNode.new
    node.invoke_request 'foobar', 'myparam'
  end

  # TODO make sure object attributes not serialized to json
  # are not available on remote end of local node invocation/response
end
