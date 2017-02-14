class Postcard < ActiveRecord::Base
  belongs_to :user
  
  states_list = ['AK', 	'AL', 	'AR', 	'AZ', 	'CA', 	'CO', 	'CT', 	'DC', 	'DE', 	'FL', 	'GA', 	'HI', 	'IA', 	'ID', 	'IL', 	'IN', 	'KS', 	'KY', 	'LA', 	'MA', 	'MD', 	'ME', 	'MI', 	'MN', 	'MO', 	'MS', 	'MT', 	'NC', 	'ND', 	'NE', 	'NH', 	'NJ', 	'NM', 	'NV', 	'NY', 	'OH', 	'OK', 	'OR', 	'PA', 	'RI', 	'SC', 	'SD', 	'TN', 	'TX', 	'UT', 	'VA', 	'VT', 	'WA', 	'WI', 	'WV', 	'WY']
  
  validates :to_name, length: { in: 3..40 }
  validates :to_address_one, length: { in: 3..40 }
  validates :to_address_two, length: { maximum: 40 }
  validates :to_city, length: { in: 3..30 }
  validates :to_state, length: { is: 2 }, inclusion: { in: states_list }
  validates :to_zip, length: { is: 5 }, numericality: { only_integer: true }
  validates :from_name, length: { in: 3..40 }
  validates :from_address_one, length: { in: 3..40 }
  validates :from_address_two, length: { maximum: 40 }
  validates :from_city, length: { in: 3..30 }
  validates :from_state, length: { is: 2 }, inclusion: { in: states_list }
  validates :from_zip, length: { is: 5 }, numericality: { only_integer: true }
  validates :postcard_message, length: { maximum: 250 }
  
end
