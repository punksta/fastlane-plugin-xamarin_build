module Fastlane
  module Actions
    class XamarinBuildAction < Action
      MDTOOL = '/Applications/Xamarin\ Studio.app/Contents/MacOS/mdtool'.freeze
      XBUILD = '/Library/Frameworks/Mono.framework/Commands/xbuild'.freeze

      def self.run(params)
        platform = params[:platform]
        build_type = params[:build_type]
        target = params[:target]
        solution = params[:solution]
        util = params[:build_util]

        if util == 'mdtool'
          configuration = "--configuration:#{build_type}|#{platform}"
          command = "#{MDTOOL} build -t #{target} #{solution} \"#{configuration}\""
        else
          command = "echo 'not supported yet'"
        end

        # FastlaneCore::CommandExecutor.execute store logs in ram.
        Helper::XamarinBuildHelper.bash(command, !params[:print_all])

        get_build_path(platform, build_type, solution)
      end

      # Returns bin path for given platform and build_type or nil
      def self.get_build_path(platform, build_type, solution)
        root = File.dirname(solution)

        build = Dir.glob(File.join(root, "*/bin/#{platform}/#{build_type}/"))

        if build.size > 0
          b = build[0]
          UI.message("build artifact path #{b}".blue)
          return b
        else
          return nil
        end
      end

      def self.description
        'Build xamarin android and ios projects'
      end

      def self.authors
        ['punksta']
      end

      BUILD_TYPES = %w(Release Debug).freeze
      TARGET_TYPES = %w(Build Clean).freeze
      PRINT_ALL = [true, false].freeze
      BUILD_UTIL = [
          #'xbuild',
          'mdtool'
      ].freeze

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :solution,
              env_name: 'FL_XAMARIN_BUILD_SOLUTION',
              description: 'path to Xamarin .sln file',
              verify_block: proc do |value|
                UI.user_error!('File not found'.red) unless File.file? value
              end
          ),

          FastlaneCore::ConfigItem.new(
            key: :platform,
            env_name: 'FL_XAMARIN_BUILD_PLATFORM',
            description: 'build platform',
            type: String
          ),

          FastlaneCore::ConfigItem.new(
              key: :build_type,
              env_name: 'FL_XAMARIN_BUILD_TYPE',
              description: 'Release or Debug',
              type: String,
              verify_block: proc do |value|
                UI.user_error!("Unsupported build type! Use one of #{BUILD_TYPES.join '\' '}".red) unless BUILD_TYPES.include? value
              end
          ),

          FastlaneCore::ConfigItem.new(
            key: :target,
            env_name: 'FL_XAMARIN_BUILD_TARGET',
            description: 'Clean or Build',
            type: String,
            default_value: 'Build',
            verify_block: proc do |value|
              UI.user_error!("Unsupported target! Use one of #{TARGET_TYPES.join '\' '}".red) unless TARGET_TYPES.include? value
            end
          ),

          FastlaneCore::ConfigItem.new(
            key: :print_all,
            env_name: 'FL_XAMARIN_BUILD_PRINT_ALL',
            description: 'Print std out',
            default_value: true,
            is_string: false,
            optional: true,
            verify_block: proc do |value|
              UI.user_error!("Unsupported value! Use one of #{PRINT_ALL.join '\' '}".red) unless PRINT_ALL.include? value
            end
          ),

          FastlaneCore::ConfigItem.new(
              key: :build_util,
              env_name: 'FL_XAMARIN_BUILD_BUILD_UTIL',
              description: 'Build util which use to build project. mdtool',
              default_value: 'mdtool',
              is_string: false,
              optional: true,
              verify_block: proc do |value|
                UI.user_error!("Unsupported build util! Une of #{BUILD_UTIL.join '\' '}".red) unless BUILD_UTIL.include? value
              end
          )
        ]
      end

      def self.is_supported?(platform)
        # android not tested
        [:ios, :android].include?(platform)
      end
    end
  end
end
