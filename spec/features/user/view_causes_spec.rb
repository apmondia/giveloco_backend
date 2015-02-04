require 'rails_helper'

describe 'As a user I want to view the causes' do

  before(:each) do
    @b = create(:business)
    @c = create(:cause)
    @c.tag_list.add('foo')
    @c.save!
    @s = create(:sponsorship, :business => @b, :cause => @c)
    expect(@b.is_published).to eq(true)
    expect(@c.is_published).to eq(true)

    @b_not_pub = create(:business, :access_code => nil)
    expect(@b_not_pub.is_published).to eq(false)
    @c2 = create(:cause)
    @s = create(:sponsorship, :business => @b_not_pub, :cause => @c2)

    @c2 = create(:cause)
    @c2.tag_list.add('foo')
    @c2.save!

    @c3 = create(:cause)

  end

  it 'should show all published causes' do

    visit '/'
    click_link 'Start Shopping'
    click_link 'Causes'
    expect(page).to have_content(@c.company_name)
    expect(page).to have_content(@c2.company_name)

  end

  def click_cause(name)
    find("a[title='#{name}']").click
  end

  it 'should allow the user to explore via tag' do

    visit '/'
    click_link 'Start Shopping'
    click_link 'Causes'
    expect(page).to have_content(@c.company_name)
    expect(page).to have_content(@c2.company_name)
    expect(page).to have_content(@c3.company_name)
    click_cause(@c.company_name)
    click_link 'foo'
    expect(page).to have_content(@c.company_name)
    expect(page).to have_content(@c2.company_name)
    expect(page).not_to have_content(@c3.company_name)

  end

end