require 'thor'

module NexusCli
  module Tasks
    def self.included(base)
      base.send :include, ::Thor::Actions
      base.class_eval do

        method_option :destination, 
          :type => :string,
          :default => nil,
          :desc => "A different folder other than the current working directory."
        method_option :overrides,
          :type => :hash,
          :default => {},
          :desc => "A hashed list of overrides. Available options are 'url', 'repository', 'username', and 'password'."
        desc "pull_artifact artifact", "Pulls an artifact from Nexus and places it on your machine."
        def pull_artifact(artifact)
          begin
            path_to_artifact = Remote.pull_artifact(artifact, options[:destination], options[:overrides])
            say "Artifact has been retrived and can be found at path: #{path_to_artifact}", :green
          rescue NexusCliError => e
            say e.message, :red
            exit e.status_code
          end
        end

        method_option :insecure,
          :type => :boolean,
          :default => false,
          :desc => "Overrides any failures because of an 'insecure' SSL conncetion."
        method_option :overrides,
          :type => :hash,
          :default => {},
          :desc => "A hashed list of overrides. Available options are 'url', 'repository', 'username', and 'password'."
        desc "push_artifact artifact file", "Pushes an artifact from your machine onto the Nexus."
        def push_artifact(artifact, file)
          begin
            Remote.push_artifact(artifact, file, options[:insecure], options[:overrides])
            say "Artifact #{artifact} has been successfully pushed to Nexus.", :green
          rescue NexusCliError => e
            say e.message, :red
            exit e.status_code
          end
        end

        method_option :overrides,
          :type => :hash,
          :default => {},
          :desc => "A hashed list of overrides. Available options are 'url', 'repository', 'username', and 'password'."
        desc "get_artifact_info artifact", "Gets and returns the XML information about a particular artifact."
        def get_artifact_info(artifact)
          begin
            say Remote.get_artifact_info(artifact, options[:overrides]), :green
          rescue NexusCliError => e
            say e.message, :red
            exit e.status_code
          end
        end

        desc "get_nexus_configuration", "Prints out configuration from the .nexus_cli file that helps inform where artifacts will be uploaded."
        def get_nexus_configuration
          begin
            config = Remote.configuration
            say "*********Reading Configuration from #{File.expand_path('~/.nexus_cli')}*********", :blue
            say "Nexus URL: #{config['url']}", :blue
            say "Nexus Repository: #{config['repository']}", :blue
          rescue NexusCliError => e
            say e.message, :red
            exit e.status_code
          end
        end
      end
    end
  end
end