require 'puppet'
require 'puppet/type/sahara_node_group_template'

describe Puppet::Type.type(:sahara_node_group_template) do

  before :each do
    Puppet::Type.rmtype(:sahara_node_group_template)
  end

  it 'should reject empty node_processes' do
    incorrect_input = {
      :name           => 'test_type',
      :plugin         => 'plugin',
      :plugin_version => 'version',
      :flavor         => 'flavor',
      :node_processes => []
    }
    expect { Puppet::Type.type(:sahara_node_group_template).new(incorrect_input) }.to raise_error(Puppet::ResourceError, /You should specify at least one node process/)
  end

  it 'should autorequire cinder-api service' do
    catalog = Puppet::Resource::Catalog.new
    service = Puppet::Type.type(:service).new(:name => 'sahara-api')
    correct_input = {
      :name           => 'test_type',
      :plugin         => 'plugin',
      :plugin_version => 'version',
      :flavor         => 'flavor',
      :node_processes => [ 'process1', 'process2' ]
    }
    sahara_node_group_template = Puppet::Type.type(:sahara_node_group_template).new(correct_input)
    catalog.add_resource service, sahara_node_group_template
    dependency = sahara_node_group_template.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(sahara_node_group_template)
    expect(dependency[0].source).to eq(service)
  end
end
