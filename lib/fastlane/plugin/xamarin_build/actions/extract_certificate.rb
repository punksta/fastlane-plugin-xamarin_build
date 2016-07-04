require 'plist'
require 'open3'
require 'openssl'
require 'provision_util'

module Fastlane
  module Actions
    class ExtractCertificateAction < Action
      PROVISIONS = "#{Dir.home}/Library/MobileDevice/Provisioning\ Profiles/".freeze

      def self.run(params)
        path = params[:provision_path]
        path = default_path(params[:uuid]) if path.nil?
        check_profile(path)
        return ProvisionUtil::get_cert_from_provision(path)
      end

      def self.description
        'Extract certificate public key from provision profile'
      end

      def self.details
        'You can use it to get info about signing certificate' \
          'like certificate name and id'
      end

      def self.check_profile(file)
        UI.user_error!('Empty input') if file.nil?
        UI.user_error!("#{file} does not exist") unless File.exist? file
        UI.user_error!("#{file} is not a file") unless File.file? file
      end

      def self.default_path(uuid)
        File.join PROVISIONS, "#{uuid}.mobileprovision"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :provision_path,
            env_name: 'FL_EXTRACT_CERTIFICATE_PR_PATH',
            description: 'Path to provision profile',
            is_string: true,
            optional: true,
            verify_block: proc do |path|
                            check_profile(path)
                          end
          ),

          FastlaneCore::ConfigItem.new(
            key: :uuid,
            env_name: 'FL_EXTRACT_CERTIFICATE_UUID',
            description: 'UUID of provision profile in default dir',
            is_string: true,
            optional: true,
            verify_block: proc do |uuid|
              provision_path = default_path(uuid)
              check_profile(provision_path)
            end
          ),

          FastlaneCore::ConfigItem.new(
            key: :log_certificate,
            env_name: 'FL_EXTRACT_CERTIFICATE_LOG',
            description: 'Logging extracting certificate',
            optional: true,
            default_value: true,
            is_string: false
          )
        ]
      end

      def self.return_value
        'Returns OpenSSL::X509::Certificate object representing' \
          'signing certificate from provision profile'
      end

      def self.authors
        ['punksta']
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end
    end
  end
end
