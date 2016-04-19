require 'spec_helper'
require 'puppet'
require 'puppet/provider/sahara_cluster_template/openstack'

provider_class = Puppet::Type.type(:sahara_cluster_template).provider(:openstack)

describe provider_class do
    let(:attributes) do
      {
         :name        => 'cluster_template_1',
         :ensure      => :present,
         :node_groups => [ 'group1:1', 'group2:2' ],
      }
    end

    let(:resource) do
      Puppet::Type::Sahara_cluster_template.new(attributes)
    end

    let(:provider) do
      resource.provider
    end

    subject { provider }

    describe 'managing template' do
      describe '#create' do
        it 'creates a template' do
          subject.class.expects(:request)
            .with('dataprocessing cluster template', 'create', ['--name', 'cluster_template_1', '--node-groups', ['group1:1', 'group2:2'], '--autoconfig'])
          provider.create
        end
      end

      describe '#destroy' do
        it 'destroys a template' do
          subject.stubs(:id).returns('19e4d640-e88f-4241-9475-0543c2bc412b')
          subject.class.expects(:request)
            .with('dataprocessing cluster template', 'delete', '19e4d640-e88f-4241-9475-0543c2bc412b')
          provider.destroy
        end
      end

      describe '#instances' do
        it 'finds templates' do

          hash = {
            id: "33c85b61-e9b3-468a-ab06-ef60091c68b6",
            name: "cluster_template_2",
            plugin_name: "plugin_name_2",
            plugin_version: "another_version",
            node_groups: "group:2",
            use_autoconfig: "False"
          }

          subject.class.expects(:request)
            .with('dataprocessing cluster template', 'show', '33c85b61-e9b3-468a-ab06-ef60091c68b6')
            .returns(hash)

          hash = {
            id: "19e4d640-e88f-4241-9475-0543c2bc412b",
            name: "cluster_template_1",
            node_groups: "group1:1, group2:2",
            plugin_name: "plugin_name",
            plugin_version: "some_version",
            use_autoconfig: "False"
          }

          subject.class.expects(:request)
            .with('dataprocessing cluster template', 'show', '19e4d640-e88f-4241-9475-0543c2bc412b')
            .returns(hash)

          list = [
            {
              name: "cluster_template_1",
              id: "19e4d640-e88f-4241-9475-0543c2bc412b",
              plugin_name: "plugin_name",
              plugin_version: "some_version",
            },
            {
              name: "cluster_template_2",
              id: "33c85b61-e9b3-468a-ab06-ef60091c68b6",
              plugin_name: "plugin_name_2",
              plugin_version: "another_version",
            }
          ]

          subject.class.expects(:request)
            .with('dataprocessing cluster template', 'list')
            .returns(list)
          instances = provider_class.instances
          expect(instances.count).to eq(2)
          expect(instances[0].name).to eq('cluster_template_1')
          expect(instances[1].name).to eq('cluster_template_2')
        end
      end
    end
end
