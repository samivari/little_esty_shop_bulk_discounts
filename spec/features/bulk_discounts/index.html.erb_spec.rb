require 'rails_helper'
describe 'merchant bulk discount index page' do
  before do
    @merchant1 = Merchant.create!(name: 'Hair Care')

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
    @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
    @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
    @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
    @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Kuhn')

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    @item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10,
                           merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: 'Conditioner', description: 'This makes your hair shiny', unit_price: 8,
                           merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: 'Brush', description: 'This takes out tangles', unit_price: 5,
                           merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: 'Hair tie', description: 'This holds up your hair', unit_price: 1,
                           merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203_942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230_948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234_092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230_429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102_938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879_799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203_942, result: 1, invoice_id: @invoice_2.id)

    @bulk_1 = @merchant1.bulk_discounts.create!(percentage: 5, threshold: 10)
    @bulk_2 = @merchant1.bulk_discounts.create!(percentage: 10, threshold: 15)
    @bulk_3 = @merchant1.bulk_discounts.create!(percentage: 15, threshold: 20)
    @bulk_4 = @merchant1.bulk_discounts.create!(percentage: 20, threshold: 25)
    visit "/merchant/#{@merchant1.id}/bulk_discounts"
  end

  it 'shows all of my bulk discounts and the percent and quantity threshold' do
    within "#discount-#{@bulk_1.id}" do
      expect(page).to have_content("#{@bulk_1.percentage} percent off of #{@bulk_1.threshold} items")
    end
    within "#discount-#{@bulk_2.id}" do
      expect(page).to have_content("#{@bulk_2.percentage} percent off of #{@bulk_2.threshold} items")
    end
    within "#discount-#{@bulk_3.id}" do
      expect(page).to have_content("#{@bulk_3.percentage} percent off of #{@bulk_3.threshold} items")
    end
    within "#discount-#{@bulk_4.id}" do
      expect(page).to have_content("#{@bulk_4.percentage} percent off of #{@bulk_4.threshold} items")
    end
  end

  it 'has each discount as a link to its show page' do
    within "#discount-#{@bulk_1.id}" do
      expect(page).to have_link(@bulk_1.percentage)
      click_link(@bulk_1.percentage)
      expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts/#{@bulk_1.id}")
    end
  end

  it 'has the new three holidays' do
    within '#holiday' do
      expect(page).to have_content('Good Friday')
      expect(page).to have_content('Memorial Day')
      expect(page).to have_content('Juneteenth')
    end
  end

  it 'has link to create a new discount' do
    expect(page).to have_link('Add New Discount')
  end

  it 'takes to a new page with a form to create a discount' do
    click_link('Add New Discount')
    expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts/new")
  end

  it 'has a button to delete a discount' do
    within "#discount-#{@bulk_1.id}" do
      expect(page).to have_button('Delete Discount')
    end
  end

  it 'deletes a discount' do
    expect(page).to have_content('5 percent off of 10 items')
    within "#discount-#{@bulk_1.id}" do
      click_button('Delete Discount')
    end
    expect(page).to_not have_content('5 percent off of 10 items')
  end
end
