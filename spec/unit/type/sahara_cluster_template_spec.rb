require 'puppet'
require 'puppet/type/sahara_cluster_template'

describe Puppet::Type.type(:sahara_cluster_template) do

  before :each do
    Puppet::Type.rmtype(:sahara_cluster_template)
  end

  it 'should reject empty node_groups' do
    incorrect_input = {
      :name           => 'test_type',
      :node_groups => [ ]
    }
    expect { Puppet::Type.type(:sahara_cluster_template).new(incorrect_input) }.to raise_error(Puppet::ResourceError, /You should specify at least one node group/)
  end

  it 'should reject wrong node group format' do
    incorrect_input = {
      :name           => 'test_type',
      :node_groups => [ 'nodegroup_2' ]
    }
    expect { Puppet::Type.type(:sahara_cluster_template).new(incorrect_input) }.to raise_error(Puppet::ResourceError, /You should specify node_groups in format/)
  end

  it 'should reject wrong node group count' do
    incorrect_input = {
      :name           => 'test_type',
      :node_groups => [ 'nodegroup_2:sdf' ]
    }
    expect { Puppet::Type.type(:sahara_cluster_template).new(incorrect_input) }.to raise_error(Puppet::ResourceError, /Node group count should be an integer/)
  end

  it 'should autorequire sahara-api service' do
    catalog = Puppet::Resource::Catalog.new
    service = Puppet::Type.type(:service).new(:name => 'sahara-api')
    correct_input = {
      :name        => 'test_type',
      :node_groups => [ 'nodegroup_1:1', 'nodegroup_2:2' ]
    }
    sahara_cluster_template = Puppet::Type.type(:sahara_cluster_template).new(correct_input)
    catalog.add_resource service, sahara_cluster_template
    dependency = sahara_cluster_template.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(sahara_cluster_template)
    expect(dependency[0].source).to eq(service)
  end

  it 'should autorequire sahara_node_group_template' do
    catalog = Puppet::Resource::Catalog.new
    sahara_node_group_template = Puppet::Type.type(:sahara_node_group_template).new({
      :name           => 'test_type',
      :plugin         => 'plugin',
      :plugin_version => 'version',
      :flavor         => 'flavor',
      :node_processes => [ 'process1', 'process2' ]
    })
    sahara_cluster_template = Puppet::Type.type(:sahara_cluster_template).new({
      :name        => 'test_cluster_type',
      :node_groups => [ 'test_type:1' ]
    })
    catalog.add_resource sahara_node_group_template, sahara_cluster_template
    dependency = sahara_cluster_template.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(sahara_cluster_template)
    expect(dependency[0].source).to eq(sahara_node_group_template)
  end
end
