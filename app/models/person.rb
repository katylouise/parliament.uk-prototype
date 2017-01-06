class Person < Grom::Base

  has_associations :constituencies, :sittings, :parties, :party_memberships, :houses, :contact_points
  # has_many_through :constituencies, via: :sittings
  # has_many_through :parties, via: :party_memberships
  # has_many_through :houses, via: :sittings
  # has_many :sittings
  # has_many :contact_points

  def self.property_translator
    {
        id: 'id',
        type: 'type',
        forename: 'forename',
        surname: 'surname',
        middleName: 'middle_name',
        dateOfBirth: 'date_of_birth',
        gender: 'gender'
    }
  end

  def display_name
    display_name = ''
    display_name += self.forename + ' ' unless self.forename.nil?
    display_name += self.surname unless self.surname.nil?
  end

end
