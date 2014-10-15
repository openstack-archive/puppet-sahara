require 'puppet'
require 'puppet/type/sahara_config'
describe 'Puppet::Type.type(:sahara_config)' do
  before :each do
    @sahara_config = Puppet::Type.type(:sahara_config).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  it 'should require a name' do
    expect {
      Puppet::Type.type(:sahara_config).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'should not expect a name with whitespace' do
    expect {
      Puppet::Type.type(:sahara_config).new(:name => 'f oo')
    }.to raise_error(Puppet::Error, /Parameter name failed/)
  end

  it 'should fail when there is no section' do
    expect {
      Puppet::Type.type(:sahara_config).new(:name => 'foo')
    }.to raise_error(Puppet::Error, /Parameter name failed/)
  end

  it 'should not require a value when ensure is absent' do
    Puppet::Type.type(:sahara_config).new(:name => 'DEFAULT/foo', :ensure => :absent)
  end

  it 'should accept a valid value' do
    @sahara_config[:value] = 'bar'
    @sahara_config[:value].should == 'bar'
  end

  it 'should not accept a value with whitespace' do
    @sahara_config[:value] = 'b ar'
    @sahara_config[:value].should == 'b ar'
  end

  it 'should accept valid ensure values' do
    @sahara_config[:ensure] = :present
    @sahara_config[:ensure].should == :present
    @sahara_config[:ensure] = :absent
    @sahara_config[:ensure].should == :absent
  end

  it 'should not accept invalid ensure values' do
    expect {
      @sahara_config[:ensure] = :latest
    }.to raise_error(Puppet::Error, /Invalid value/)
  end
end
