module Fastlane
  module Actions
    class XamarinBuildAction < Action
      MDTOOL = '/Applications/Xamarin\ Studio.app/Contents/MacOS/mdtool'.freeze
      XBUILD = '/Library/Frameworks/Mono.framework/Commands/xbuild'.freeze

      def self.run(params)
        platform = params[:platform]
        project = params[:project]

        projects = (params[:projects] or '').split(',').select do |item|
          item.size > 0
        end

        projects << project if project != nil
        projects = projects.uniq

        if params[:build_util] == 'mdtool'
          if projects.size > 0
            mdtool_build_projects(params, projects)
          else
            mdtool_build_solution(params)
          end
        else
          if projects.size > 0
            puts "echo 'not supported yet'"
          else
            xbuild_build_solution(params)
          end
        end

        build_type = params[:build_type]
        solution = params[:solution]
        get_build_path(platform, build_type, solution)
      end



      def self.mdtool_build_projects(params, projects)
        platform = params[:platform]
        build_type = params[:build_type]
        target = params[:target]
        solution = params[:solution]

        for project in projects
          configuration = "--configuration:#{build_type}|#{platform}"
          command = "#{MDTOOL} build -t:#{target} -p:#{project} #{solution} \"#{configuration}\""
          Helper::XamarinBuildHelper.bash(command, !params[:print_all])
        end

      end

      def self.xbuild_build_solution(params)
        platform = params[:platform]
        build_type = params[:build_type]
        target = params[:target]
        solution = params[:solution]

        command = "#{XBUILD} "
        command << "/target:#{target} " if target != nil
        command << "/p:Platform=#{platform} " if platform != nil
        command << "/p:Configuration=#{build_type} " if build_type != nil
        command << solution

        Helper::XamarinBuildHelper.bash(command, !params[:print_all])
      end





      def self.mdtool_build_solution(params)
        platform = params[:platform]
        build_type = params[:build_type]
        target = params[:target]
        solution = params[:solution]

        configuration = "--configuration:#{build_type}|#{platform}"
        command = "#{MDTOOL} build -t:#{target} #{solution} \"#{configuration}\""
        Helper::XamarinBuildHelper.bash(command, !params[:print_all])
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
      PRINT_ALL = [true, false].freeze
      BUILD_UTIL = %w(xbuild mdtool).freeze

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
          ),

          FastlaneCore::ConfigItem.new(
              key: :project,
              env_name: 'FL_XAMARIN_BUILD_PROJECT',
              description: 'Project to build or clean',
              is_string: true,
              optional: true
          ),

          FastlaneCore::ConfigItem.new(
              key: :projects,
              env_name: 'FL_XAMARIN_BUILD_PROJECTS',
              description: 'Projects to build or clean, separated by ,',
              is_string: true,
              optional: true
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
