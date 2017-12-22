module MetaField
  module Concern
    extend ActiveSupport::Concern

    included do
      serialize :meta, JSON
    end

    module ClassMethods
      def has_meta_fields(*names)

        keys = []

        names.each do |name|
          keys << { name.to_s => [name.to_s] } if name.is_a? Symbol
          keys << { name => [name] } if name.is_a? String
          if name.is_a? Hash
            name.each do |key, values|
              keys << { key.to_s => [key.to_s] }
              values.each do |value|
                keys << { value.to_s => [key.to_s, value.to_s] }
              end
            end
          end
        end

        define_method :changed do
          changed_array = super()# - ['meta']
          keys.each do |item|
            item.each do |key, accessors|
              changed_array << key.to_s if send(:"#{key}_changed?")
            end
          end
          changed_array
        end

        define_method :changes do
          changes_hash = super()
          keys.each do |item|
            item.each do |key, accessors|
              changes_hash[key] = send("#{key}_change") if send(:"#{key}_changed?")
            end
          end
          changes_hash.delete 'meta'
          changes_hash
        end

        keys.each do |item|

          item.each do |key, accessors|
            define_method :"#{key}" do
              return nil if meta.blank?
              meta.dig(*accessors)
            end

            define_method :"#{key}=" do |value|
              self.meta ||= {}
              val = value.is_a?(String) ? value.strip : value
              if accessors.size > 1
                self.meta[accessors.first] ||= {}
                self.meta[accessors.first][accessors.second] = val
              else
                self.meta[accessors.first] = val
              end
            end


            define_method :"#{key}_was" do
              return send(key) unless meta_was
              meta_was.dig(*accessors)
            end

            define_method :"#{key}_changed?" do
              return false unless meta_was
              meta_was.dig(*accessors) != send(key)
            end

            define_method :"#{key}_change" do
              return nil unless meta_was
              [meta_was.dig(*accessors), send(key)]
            end
          end
        end

      end
    end
  end
end


ActiveRecord::Base.send(:include, MetaField::Concern)
