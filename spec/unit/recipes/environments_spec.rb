#
# Cookbook Name:: common_utils
# Spec:: environments
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'common_utils::environments' do
  context 'when attributes are default' do
    cached(:chef_run) do
      runner = ChefSpec::ServerRunner.new do |node|
        node.set['policy_group'] = 'default_group'
        node.set['policy_name'] = 'default_name'
      end.converge(described_recipe)
    end

    it 'should create default common_environment resources' do
      expect(chef_run).to apply_common_environment('default_group')
      expect(chef_run).to apply_common_environment('default_name')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
