require 'spec_helper'

describe Incoming::Cli do
  it 'has a version number' do
    expect(Incoming::Cli::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
