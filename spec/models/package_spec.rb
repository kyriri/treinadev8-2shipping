require 'rails_helper'

RSpec.describe Package, type: :model do
  # All fields on the package model are important for the delivery to occur.
  # However, the package info would be generated by a system external to this one,
  # so we will assume this other system validates the package data properly
  # before sending it to us 
end
