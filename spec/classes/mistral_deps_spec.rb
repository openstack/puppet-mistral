require 'spec_helper'

describe 'mistral::deps' do

  it 'set up the anchors' do
    is_expected.to contain_anchor('mistral::install::begin')
    is_expected.to contain_anchor('mistral::install::end')
    is_expected.to contain_anchor('mistral::config::begin')
    is_expected.to contain_anchor('mistral::config::end')
    is_expected.to contain_anchor('mistral::db::begin')
    is_expected.to contain_anchor('mistral::db::end')
    is_expected.to contain_anchor('mistral::dbsync::begin')
    is_expected.to contain_anchor('mistral::dbsync::end')
    is_expected.to contain_anchor('mistral::service::begin')
    is_expected.to contain_anchor('mistral::service::end')
  end
end
