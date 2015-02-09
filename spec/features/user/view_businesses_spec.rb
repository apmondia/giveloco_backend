require 'rails_helper'

describe 'As a user I want to view the businesses' do

  before(:each) do
    @b = create(:business)
    @b.tag_list.add('foo')
    @b.save!
    @c = create(:cause)
    @s1 = create(:sponsorship, :business => @b, :cause => @c, :status => :accepted)

    @b2 = create(:business)
    @b2.tag_list.add('foo')
    @b2.save!
    @c2 = create(:cause, :description => '')
    expect(@c2.is_published).to eq(false)
    @s2 = create(:sponsorship, :business => @b2, :cause => @c2)

    @b3 = create(:business)
    @s3 = create(:sponsorship, :business => @b3, :status => :accepted)
    @b3.tag_list.add('foo')
    @b3.save!

    @b4 = create(:business)
    @s4 = create(:sponsorship, :business => @b4, :status => :accepted)

  end

  it 'should show all published businesses' do

    expect(@b.is_published).to eq(true)
    expect(@b2.is_published).to eq(false)

    visit_root

    expect(page).to have_content(@b.company_name)
    expect(page).not_to have_content(@b2.company_name)

  end

  def click_company(name)
    find("a[title='#{name}']").click
  end

  it 'should allow the user to explore via tag' do

    visit_root

    expect(page).to have_content(@b.company_name)
    expect(page).to have_content(@b3.company_name)
    expect(page).to have_content(@b4.company_name)
    click_company(@b.company_name)
    click_link 'foo'
    expect(page).to have_content(@b.company_name)
    expect(page).to have_content(@b3.company_name)
    expect(page).not_to have_content(@b4.company_name)

  end

end