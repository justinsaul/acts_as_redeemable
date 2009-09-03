require File.dirname(__FILE__) + '/../test_helper'

class <%= redemption_class_name %>Test < ActiveRecord::TestCase
  fixtures :<%= redemption_file_name.pluralize %>

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
