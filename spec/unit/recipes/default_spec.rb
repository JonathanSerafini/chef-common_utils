#
# Cookbook Name:: common_utils
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'common_utils::default' do
  context 'when attributes are default' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'should include the environments recipe' do
      expect(chef_run).to include_recipe('common_utils::environments')
    end

    it 'should include the namespaces recipe' do
      expect(chef_run).to include_recipe('common_utils::namespaces')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
