class <%= migration_name %> < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name %> do |t|
      t.integer :user_id
      t.string :code
<% if redemption_table_name -%>
      t.integer :redemptions_count, :default => 0
<% else -%>
      t.datetime :redeemed_at
      t.integer :redeemed_by_id
<% end -%>
      t.datetime :expires_on

      t.timestamps
    end
    
<% if unique_index -%>
    add_index :<%= table_name %>, [:code], :unique => true
<% end -%>
    
<% if redemption_table_name -%>
    create_table :<%= redemption_table_name %> do |t|
      t.integer :<%= singular_name %>_id
      t.integer :user_id
      
      t.timestamps
    end
<% end -%>
  end

  def self.down
<% if redemption_table_name -%>
    drop_table :<%= redemption_table_name %>
<% end -%>
    drop_table :<%= table_name %>
  end
end
