require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'validations' do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe 'relationships' do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions }
  end
  describe 'instance methods' do
    it 'total_revenue' do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10,
                             merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: 'Butterfly Clip', description: 'This holds up your hair but in a clip',
                             unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: '2012-03-27 14:54:09')
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10,
                                  status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10,
                                   status: 1)

      expect(@invoice_1.total_revenue).to eq(100)
    end

    it 'discounted revenue' do
      @merchant1 = Merchant.create!(name: 'Hair Care')

      @item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10,
                             merchant_id: @merchant1.id, status: 1)
      @item_2 = Item.create!(name: 'Conditioner', description: 'This makes your hair shiny', unit_price: 8,
                             merchant_id: @merchant1.id)

      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: '2012-03-27 14:54:09')
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 10,
                                  status: 2)
      @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 5, unit_price: 10,
                                  status: 2)

      @bulk_1 = @merchant1.bulk_discounts.create!(percentage: 10, threshold: 10)
      @bulk_2 = @merchant1.bulk_discounts.create!(percentage: 15, threshold: 15)

      expect(@invoice_1.discounted_revenue).to eq(10.0)
    end
    it 'discounted items' do
      @merchant1 = Merchant.create!(name: 'Hair Care')

      @item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10,
                             merchant_id: @merchant1.id, status: 1)
      @item_2 = Item.create!(name: 'Conditioner', description: 'This makes your hair shiny', unit_price: 8,
                             merchant_id: @merchant1.id)

      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: '2012-03-27 14:54:09')
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 10,
                                  status: 2)
      @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 5, unit_price: 10,
                                  status: 2)

      @bulk_1 = @merchant1.bulk_discounts.create!(percentage: 10, threshold: 10)
      @bulk_2 = @merchant1.bulk_discounts.create!(percentage: 15, threshold: 15)

      expect(@invoice_1.discounted_items.map { |i| i.id }).to eq([@ii_1.id])
    end
  end
end
