module MetaField
  module Concern
    extend ActiveSupport::Concern

    included do
      serialize :meta, JSON
      class_attribute :all_meta_fields
      self.all_meta_fields = []
    end

    module ClassMethods

      def has_meta_fields(*names, **options)
        self.all_meta_fields += names
        scope = options[:scope]

        names.each do |key|
          if scope
            accessors = [scope.to_s, key.to_s]
            define_method :"#{scope}=" do |hash|
              self.meta ||= {}
              self.meta[scope.to_s] = hash
            end
          else
            accessors = [key.to_s]
          end

          define_method :"#{key}" do
            return nil if meta.nil?
            meta.dig(*accessors)
          end

          define_method :"#{key}=" do |value|
            self.meta ||= {}
            val = value.is_a?(String) ? value.strip : value
            if scope
              self.meta[scope.to_s] ||= {}
              self.meta[scope.to_s][key.to_s] = val
            else
              self.meta[key.to_s] = val
            end
          end

          define_method :"#{key}_was" do
            return nil if meta_was.nil?
            meta_was.dig(*accessors)
          end

          define_method :"#{key}_changed?" do
            # return false unless meta_was
            send(:"#{key}_was") != send(key)
          end

          define_method :"#{key}_change" do
            [send(:"#{key}_was"), send(key)] if send(:"#{key}_changed?")
          end

        end

        define_method :changes do
          changes_hash = super()
          self.all_meta_fields.each do |key|
            changes_hash[key] = send(:"#{key}_change") if send(:"#{key}_changed?")
          end
          changes_hash.delete 'meta'
          changes_hash
        end

        define_method :changed do
          changed_array = super()
          self.all_meta_fields.each do |key|
            changed_array << key.to_s if send(:"#{key}_changed?")
          end
          changed_array
        end
      end
    end
  end
end


ActiveRecord::Base.send(:include, MetaField::Concern)
