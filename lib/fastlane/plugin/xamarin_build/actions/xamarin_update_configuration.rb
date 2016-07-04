require 'nokogiri'

module Fastlane
  module Actions
    module SharedValues
    end

    class XamarinUpdateConfigurationAction < Action
      def self.run(params)
        project_path = params[:xamarin_project_file]


        file = File.new(project_path)
        doc = Nokogiri::XML(file.read)
        file.close

        configuration = "'#{params[:target]}|#{params[:platform]}'"

        doc.search('PropertyGroup').each do |group|
          next unless !group['Condition'].nil? && group['Condition'].include?(configuration)
          propery = group.search(params[:property])
          if propery.size > 0
            propery[0].content = params[:value]
          end
        end

        xml = doc.to_xml
        UI.command_output(xml) if $verbose
        File.write(project_path, xml)
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        'Set properties of specific build configuration in Xamarin configuration file'
      end

      def self.details
        "You can use set properties like provision profile(CodesignProvision) and certificate name(CodesignKey)" \
      end

      TARGET = ['Release', 'Debug', 'Ad-Hoc', 'AppStore'].freeze
      PLATFORM = %w(iPhone iPhoneSimulator AnyCPU).freeze

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :xamarin_project_file,
                                       env_name: 'FL_XAMARIN_UPDATE_CONFIGURATION_XAMARIN_PROJECT',
                                       description: 'path to xamarin .csproj project file',
                                       is_string: true,
                                       verify_block: proc do |value|
                                         UI.user_error!('Project file not found') unless File.exist? value
                                       end),

          FastlaneCore::ConfigItem.new(key: :target,
                                       env_name: 'FL_XAMARIN_UPDATE_CONFIGURATION_TARGET',
                                       description: 'Target of configuration PropertyGroup',
                                       is_string: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("Unsupported target! Use one of #{TARGET}") unless TARGET.include? value
                                       end),

          FastlaneCore::ConfigItem.new(key: :platform,
                                       env_name: 'FL_XAMARIN_UPDATE_CONFIGURATION_PLATFORM',
                                       description: 'platform of configuration PropertyGroup',
                                       is_string: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("Unsupported platform! use one of #{PLATFORM}") unless PLATFORM.include? value
                                       end),

          FastlaneCore::ConfigItem.new(key: :property,
                                       env_name: 'FL_XAMARIN_UPDATE_CONFIGURATION_PROPERTY',
                                       description: 'property in PropertyGroup',
                                       is_string: true),

          FastlaneCore::ConfigItem.new(key: :value,
                                       env_name: 'FL_XAMARIN_UPDATE_CONFIGURATION_VALUE',
                                       description: 'value of property',
                                       is_string: true,
                                       verify_block: proc do |value|
                                         UI.user_error!('Empty value') if value.nil?
                                       end)
        ]
      end

      def self.output
      end

      def self.return_value
        'build artifact dir path or null if can not find it'
      end

      def self.authors
        ['punksta']
      end

      def self.is_supported?(platform)
        platform == :ios || platform == :android
      end
    end
  end
end
