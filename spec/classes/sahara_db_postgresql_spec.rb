require 'spec_helper'

describe 'sahara::db::postgresql' do

  let :req_params do
    {:password => 'pw'}
  end

  let :facts do
    {
      :operatingsystemrelease => '6.5',
      :osfamily => 'RedHat',
    }
  end

  describe 'with only required params' do
    let :params do
      req_params
    end
    it { should contain_postgresql__server__db('sahara').with(
      :user         => 'sahara',
      :password     => 'md59b1dd0cc439677764ef5a848112ef0ab'
     ) }
  end

end
