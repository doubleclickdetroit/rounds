require 'spec_helper'

describe Authorization do
  it 'belongs to a User'
  it 'validates presense of all attributes'
  it 'validates uniquness of :uid scoped by :provider'
end
