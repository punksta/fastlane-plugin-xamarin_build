module Fastlane
  module Actions
    class XamarinBuildAction < Action
      MDTOOL = '/Applications/Xamarin\ Studio.app/Contents/MacOS/mdtool'.freeze

      def self.run(params)
        platform = params[:platform]
        build_type = params[:target]

        configuration = "--configuration:#{build_type}|#{platform}"
        xamarin_command = "#{MDTOOL} build #{params[:solution]} \"#{configuration}\""

        Helper::XamarinBuildHelper.bash(xamarin_command, !params[:print_all])

        # it store logs in ram. Bad practive
        # FastlaneCore::CommandExecutor.execute(command: xamarin_command, print_all: params[:print_all],  print_command: true)

        get_build_path(platform, build_type, params[:solution])
      end

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

      PRINT_ALL = [true, false].freeze

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
            key: :target,
            env_name: 'FL_XAMARIN_BUILD_TARGET',
            description: 'Target build type',
            type: String
          ),

          FastlaneCore::ConfigItem.new(
            key: :print_all,
            env_name: 'FL_XAMARIN_BUILD_PRINT_ALL',
            description: 'Print std out',
            default_value: true,
            is_string: false,
            optional: true,
            verify_block: proc do |value|
              UI.user_error!("Unsupported print all Use one of #{PRINT_ALL.join '\' '}".red) unless PRINT_ALL.include? value
            end
          )
        ]
      end

      def self.is_supported?(platform)
        [:ios, :android].include?(platform)
      end
    end
  end
end
