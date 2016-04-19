require 'puppet'
require 'puppet/provider/sahara_node_group_template/openstack'

provider_class = Puppet::Type.type(:sahara_node_group_template).provider(:openstack)

describe provider_class do
    let(:attributes) do
      {
         :name           => 'node_group_template_1',
         :ensure         => :present,
         :plugin         => 'plugin_name',
         :plugin_version => 'some_version',
         :node_processes => [ 'process1', 'process2' ],
         :flavor         => 'small'
      }
    end

    let(:resource) do
      Puppet::Type::Sahara_node_group_template.new(attributes)
    end

    let(:provider) do
      resource.provider
    end

    subject { provider }

    describe 'managing template' do
      describe '#create' do
        it 'creates a template' do
          subject.class.expects(:request)
            .with('dataprocessing node group template', 'create', ['--name', 'node_group_template_1', '--plugin', 'plugin_name', '--plugin-version', 'some_version', '--auto-security-group', '--flavor', 'small', '--processes', ['process1', 'process2']])
          provider.create
        end
      end

      describe '#destroy' do
        it 'destroys a template' do
          subject.stubs(:id).returns('19e4d640-e88f-4241-9475-0543c2bc412b')
          subject.class.expects(:request)
            .with('dataprocessing node group template', 'delete', '19e4d640-e88f-4241-9475-0543c2bc412b')
          provider.destroy
        end
      end

      describe '#instances' do
        it 'finds templates' do

          hash = {
            flavor_id: "small",
            id: "33c85b61-e9b3-468a-ab06-ef60091c68b6",
            name: "node_group_template_2",
            node_processes: "process1, process2",
            plugin_name: "plugin_name_2",
            plugin_version: "another_version",
            description: "Some description.",
            security_groups: "None",
            auto_security_group: "True",
          }

          subject.class.expects(:request)
            .with('dataprocessing node group template', 'show', '33c85b61-e9b3-468a-ab06-ef60091c68b6')
            .returns(hash)

          hash = {
            flavor_id: "small",
            id: "19e4d640-e88f-4241-9475-0543c2bc412b",
            name: "node_group_template_1",
            node_processes: "process1, process2",
            plugin_name: "plugin_name",
            plugin_version: "some_version",
            description: "Some description.",
            security_groups: "None",
            auto_security_group: "True",
          }

          subject.class.expects(:request)
            .with('dataprocessing node group template', 'show', '19e4d640-e88f-4241-9475-0543c2bc412b')
            .returns(hash)

          list = [
            {
              name: "node_group_template_1",
              id: "19e4d640-e88f-4241-9475-0543c2bc412b",
              plugin_name: "plugin_name",
              plugin_version: "some_version",
            },
            {
              name: "node_group_template_2",
              id: "33c85b61-e9b3-468a-ab06-ef60091c68b6",
              plugin_name: "plugin_name_2",
              plugin_version: "another_version",
            }
          ]

          subject.class.expects(:request)
            .with('dataprocessing node group template', 'list')
            .returns(list)
          instances = provider_class.instances
          expect(instances.count).to eq(2)
          expect(instances[0].name).to eq('node_group_template_1')
          expect(instances[1].name).to eq('node_group_template_2')
        end
      end

      describe '#string2list' do
        it 'should return an empty array when input None' do
          s = "None"
          expect(provider_class.string2list(s)).to eq([])
        end

        it 'should return non-empty array when have some input' do
          s = "[u'default']"
          expect(provider_class.string2list(s)).to eq(['default'])
        end
      end
    end
end
