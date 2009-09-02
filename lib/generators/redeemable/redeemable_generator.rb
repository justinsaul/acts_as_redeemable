class RedeemableGenerator < Rails::Generator::NamedBase #:nodoc:
  attr_reader :redemption_file_name, :redemption_class_name, :redemption_table_name
  
  default_options :skip_migration => false, :multi_use => false, :unique_index => false
  
  def initialize(runtime_args, runtime_options = {})
    super
    derive_redemption_model_names
  end

  def manifest
    record do |m|
      m.class_collisions class_name
      
      m.template "app/models/model_template.rb", "app/models/#{file_name}.rb"
      m.template "test/fixtures/model.yml", "test/fixtures/#{table_name}.yml"
      m.template "test/unit/model_test.rb", "test/unit/#{file_name}_test.rb"
      
      if options[:multi_use]
        m.template "app/models/redemption_model_template.rb", "app/models/#{redemption_file_name}.rb"
        m.template "test/fixtures/redemption_model.yml", "test/fixtures/#{redemption_file_name.pluralize}.yml"
        m.template "test/unit/redemption_model_test.rb", "test/unit/#{redemption_file_name}_test.rb"
      end
      
      unless options[:skip_migration]
        m.directory 'db/migrate'
        m.migration_template 'db/migration.rb', 'db/migrate', :assigns => {
          :migration_name => "Create#{class_name.pluralize.gsub(/::/, '')}",
          :unique_index => options[:unique_index]
        }, :migration_file_name => "create_#{file_path.gsub(/\//, '_').pluralize}"
      end
    end
  end
  
  protected
  
    def derive_redemption_model_names
      if options[:multi_use]
        @redemption_file_name = file_name + "_redemption"
        @redemption_class_name = class_name + "Redemption"
        @redemption_table_name = singular_name + ((!defined?(ActiveRecord::Base) || ActiveRecord::Base.pluralize_table_names) ? "_redemptions" : "_redemption")
      end
    end

    def add_options!(opt)
      opt.separator ''
      opt.separator 'Options:'
      opt.on("--skip-migration", 
             "Don't generate a migration file for the model(s)") {|v| options[:skip_migration] = v}
      opt.on("--multi-use",
             "Allow this redeemable to be used multiple times") {|v| options[:multi_use] = v}
      opt.on("--unique-index",
             "Create a unique index for the redeemable code") {|v| options[:unique_index] = v}
    end
end